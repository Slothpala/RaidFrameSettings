local _, addonTable = ...
local addon = addonTable.addon

--------------------
--- Libs & Utils ---
--------------------

local CR = addonTable.CallbackRegistry

------------------------
--- Speed references ---
------------------------

-- Lua
local next = next
local ipairs = ipairs
-- WoW Api
local AuraUtil_ShouldDisplayBuff = AuraUtil.ShouldDisplayBuff
local AuraUtil_ShouldDisplayDebuff = AuraUtil.ShouldDisplayDebuff
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local AuraUtil_ForEachAura = AuraUtil.ForEachAura
local TableUtil_CreatePriorityTable = TableUtil.CreatePriorityTable
local AuraUtil_DefaultAuraCompare = AuraUtil.DefaultAuraCompare
local TableUtil_Constants_AssociativePriorityTable = TableUtil.Constants.AssociativePriorityTable

-----------------
--- Blacklist ---
-----------------

local buff_blacklist = {}

function addon:UpdateBuffBlacklist()
  buff_blacklist = addon.db.profile.BuffFrame.blacklist
end

local debuff_blacklist = {}

function addon:UpdateDebuffBlacklist()
  debuff_blacklist = addon.db.profile.DebuffFrame.blacklist
end

-----------------
--- Whitelist ---
-----------------

local whitelist = {}

local function should_display_whitelisted_buff(aura)
  local info = whitelist[aura.spellId]
  if not info then
    return false
  end
  if info and info.own_only and aura.sourceUnit ~= "player" then
    return false
  end
  return true
end

function addon:UpdateWhitelist()
  whitelist = {}
  if self:IsModuleEnabled("BuffFrame") then
    for spell_id, info in next, addon.db.profile.BuffFrame.watchlist do
      whitelist[spell_id] = info
    end
  end
  if self:IsModuleEnabled("DefensiveOverlay") then
    for _, v in next, self.db.profile.DefensiveOverlay do
      if type(v) == "table" then
        for spell_id, should_display in next, v do
          if should_display then
            whitelist[spell_id] = {}
          end
        end
      end
    end
  end
  if self:IsModuleEnabled("AuraGroups") then
    for _, v in next, self.db.profile.AuraGroups.aura_groups do
      if type(v) == "table" then
        for spell_id, should_display_info in next, v.auras do
          whitelist[spell_id] = should_display_info
        end
      end
    end
  end
end

-------------------
--- Aura Groups ---
-------------------

local grouped_aura_list = {}
local registered_groups = {}
local group_events = {
  ["BuffFrame"] = true,
  ["DebuffFrame"] = true,
}
local registered_groups_changed = false

---Register an event for a list of auras.
---@param event string The name of the event to fire when the auras of the group change.
---@param auras table A list of spellId numbers.
function addon:RegisterAuraGroup(event, auras)
  group_events[event] = true
  registered_groups[event] = true
  for spell_id, _ in next, auras do
    grouped_aura_list[spell_id] = event
  end
  registered_groups_changed = true
end

---@param event string
function addon:UnregisterAuraGroup(event)
  group_events[event] = nil
  registered_groups[event] = nil
  for spell_id, attached_event in next, grouped_aura_list do
    if attached_event == event then
      grouped_aura_list[spell_id] = nil
    end
  end
  registered_groups_changed = true
end

local function create_or_get_grouped_aura_tables(cuf_frame)
  local grouped_auras = cuf_frame.RFS_FrameEnvironment.grouped_auras
  if registered_groups_changed then
    for event, _ in next, registered_groups do
      if grouped_auras[event] == nil then
        grouped_auras[event] = TableUtil_CreatePriorityTable(AuraUtil_DefaultAuraCompare, TableUtil_Constants_AssociativePriorityTable)
      end
    end
  end
  return grouped_auras
end

-------------------
--- Aura Filter ---
-------------------

local function should_display_buff(aura)
  return not buff_blacklist[aura.spellId] and AuraUtil_ShouldDisplayBuff(aura.sourceUnit, aura.spellId, aura.canApplyAura) or should_display_whitelisted_buff(aura)
end

local function should_display_debuff(aura)
  return not debuff_blacklist[aura.spellId] and AuraUtil_ShouldDisplayDebuff(aura.sourceUnit, aura.spellId)
end

--------------------
--- Aura Scanner ---
--------------------

function addon:CreateOrUpdateAuraScanner(cuf_frame)
  local function update_unit_auras(_, _, unit, update_info)
    local unit = unit or cuf_frame.unit or "player" -- In some very rare cases the unit is nil, then we just fall back to "player".
    local buffs_changed = false
    local debuffs_changed = false
    local dispel_type_changed = false
    local aura_group_changed = {}
    for event, _ in next, group_events do
      aura_group_changed[event] = false
    end
    -- Assing the cache to a local table for readabilty.
    local buffs = cuf_frame.RFS_FrameEnvironment.buffs
    local debuffs = cuf_frame.RFS_FrameEnvironment.debuffs
    local dispel_types = cuf_frame.RFS_FrameEnvironment.dispel_types
    local grouped_auras = create_or_get_grouped_aura_tables(cuf_frame)
    -- Check if a full aura update is required.
    if update_info == nil or update_info.isFullUpdate then
      -- Dump all old data.
      buffs:Clear()
      debuffs:Clear()
      dispel_types:Clear()
      for _, aura_table in next, grouped_auras do
        aura_table:Clear()
      end
      -- Full updates trigger all events.
      buffs_changed = true
      debuffs_changed = true
      dispel_type_changed = true
      for event, _ in next, group_events do
        aura_group_changed[event] = true
      end
      -- Scan for HELPFUL auras.
      local function handle_help_aura(aura)
        if should_display_buff(aura) then
          local aura_group = grouped_aura_list[aura.spellId] or "BuffFrame"
          grouped_auras[aura_group][aura.auraInstanceID] = aura
        end
        buffs[aura.auraInstanceID] = aura
      end
      AuraUtil_ForEachAura(unit, "HELPFUL", nil, handle_help_aura, true)
      -- Scan for HARMFUL auras.
      local function handle_harm_aura(aura)
        if should_display_debuff(aura) then
          local aura_group = grouped_aura_list[aura.spellId] or "DebuffFrame"
          grouped_auras[aura_group][aura.auraInstanceID] = aura
        end
        debuffs[aura.auraInstanceID] = aura
        if aura.dispelName then
          dispel_types[aura.auraInstanceID] = aura
        end
      end
      AuraUtil_ForEachAura(unit, "HARMFUL", nil, handle_harm_aura, true)
    -- Otherwise, perform a partial update.
    else
      -- Check for added auras and filter them.
      if update_info.addedAuras ~= nil then
        for _, aura in ipairs(update_info.addedAuras) do
          if aura.isHelpful then
            if should_display_buff(aura) then
              local aura_group = grouped_aura_list[aura.spellId] or "BuffFrame"
              grouped_auras[aura_group][aura.auraInstanceID] = aura
              aura_group_changed[aura_group] = true
            end
            buffs[aura.auraInstanceID] = aura
            buffs_changed = true
          elseif aura.isHarmful then
            if should_display_debuff(aura) then
              local aura_group = grouped_aura_list[aura.spellId] or "DebuffFrame"
              grouped_auras[aura_group][aura.auraInstanceID] = aura
              aura_group_changed[aura_group] = true
            end
            debuffs[aura.auraInstanceID] = aura
            debuffs_changed = true
            if aura.dispelName then
              dispel_types[aura.auraInstanceID] = aura
              dispel_type_changed = true
            end
          end
        end
      end
      -- Check if the auras in an aura table have been updated.
      if update_info.updatedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(update_info.updatedAuraInstanceIDs) do
          for group, aura_table in next, grouped_auras do
            if aura_table[auraInstanceID] then
              local new_aura = C_UnitAuras_GetAuraDataByAuraInstanceID(unit, auraInstanceID)
              aura_table[auraInstanceID] = new_aura
              aura_group_changed[group] = true
              break
            end
          end
          if buffs[auraInstanceID] then
            local new_aura = C_UnitAuras_GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            buffs[auraInstanceID] = new_aura
            buffs_changed = true
          elseif debuffs[auraInstanceID] then
            local new_aura = C_UnitAuras_GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            debuffs[auraInstanceID] = new_aura
            debuffs_changed = true
          end
          if dispel_types[auraInstanceID] then
            local new_aura = debuffs[auraInstanceID] or C_UnitAuras_GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            dispel_types[auraInstanceID] = new_aura
            dispel_type_changed = true
          end
        end
      end
      -- Check if auras in an aura table have been removed.
      if update_info.removedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(update_info.removedAuraInstanceIDs) do
          for group, aura_table in next, grouped_auras do
            if aura_table[auraInstanceID] then
              aura_table[auraInstanceID] = nil
              aura_group_changed[group] = true
              break
            end
          end
          if buffs[auraInstanceID] then
            buffs[auraInstanceID] = nil
            buffs_changed = true
          elseif debuffs[auraInstanceID] then
            debuffs[auraInstanceID] = nil
            debuffs_changed = true
          end
          if dispel_types[auraInstanceID] then
            dispel_types[auraInstanceID] = nil
            dispel_type_changed = true
          end
        end
      end
    end
    -- Store the cache in the frame environment
    cuf_frame.RFS_FrameEnvironment.buffs = buffs
    cuf_frame.RFS_FrameEnvironment.debuffs = debuffs
    cuf_frame.RFS_FrameEnvironment.dispel_types = dispel_types
    cuf_frame.RFS_FrameEnvironment.grouped_auras = grouped_auras

    -- Only fire the events when an aura frame needs to be updated.
    if buffs_changed then
      CR:Fire("BUFFS_CHANGED", cuf_frame)
    end
    if debuffs_changed then
      CR:Fire("DEBUFFS_CHANGED", cuf_frame)
    end
    if dispel_type_changed then
      CR:Fire("DISPEL_TYPE_CHANGED", cuf_frame)
    end
    for event, _ in next, group_events do
      if aura_group_changed[event] == true then
        CR:Fire(event, cuf_frame)
      end
    end
  end

  -- Get the aura scanner frame or create one.
  local aura_scanner = cuf_frame.RFS_FrameEnvironment.aura_scanner or CreateFrame("Frame")
  cuf_frame.RFS_FrameEnvironment.aura_scanner = aura_scanner
  -- Register the UNIT_AURA event and start the scanner.
  aura_scanner:UnregisterAllEvents()
  aura_scanner:SetScript("OnEvent", update_unit_auras)
  aura_scanner:RegisterUnitEvent("UNIT_AURA", cuf_frame.unit)
  -- Auras are filtered differently in combat, so a full update is required.
  aura_scanner:RegisterEvent("PLAYER_REGEN_ENABLED")
  aura_scanner:RegisterEvent("PLAYER_REGEN_DISABLED")
  -- Update the auras
  update_unit_auras(nil, nil, cuf_frame.unit, nil)
end

function addon:StopAuraScanner(cuf_frame)
  local aura_scanner = cuf_frame.RFS_FrameEnvironment.aura_scanner
  if not aura_scanner then
    return
  end
  aura_scanner:UnregisterAllEvents()
end
