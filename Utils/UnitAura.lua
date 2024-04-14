--[[Created by Slothpala]]--

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
addonTable.UnitAura = {}
local UnitAura = addonTable.UnitAura
Mixin(UnitAura, addonTable.hooks)

-- many thanks to https://github.com/tukui-org/LibDispel for making it available. 
local LD = LibStub("LibDispel-1.0")
local BleedList = LD:GetBleedList()


-- Speed references
-- WoW Api
--[[ seems to make issues with continuationTokens
local AuraUtil_ForEachAura = AuraUtil.ForEachAura
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local AuraUtil_ShouldDisplayBuff = AuraUtil.ShouldDisplayBuff
local AuraUtil_ShouldDisplayDebuff = AuraUtil.ShouldDisplayDebuff
]]
-- Lua
local string_sub = string.sub

-- Blacklist 
local blacklist = {}

function UnitAura:UpdateBlacklist(is_enabled)
   blacklist = {}
   if is_enabled then
      for spellId, _ in pairs(addon.db.profile.Blacklist) do
         blacklist[tonumber(spellId)] = true
      end
   end
   self:UpdateAllAurasOnAllFrames()
end

-- Watchlist
local watchlist = {}

function UnitAura:UpdateWatchlist(is_enabled)
   watchlist = {}
   if is_enabled then
      for spellId, info in pairs(addon.db.profile.Watchlist) do
         watchlist[tonumber(spellId)] = info
      end
   end
   self:UpdateAllAurasOnAllFrames()
end

-- Callbacks
-- To register "clean up" function when auras have been removed
local removed_aura_instance_id_callbacks = {}

-- spellId callbacks
local spell_id_callbacks = {}

local function on_apply_aura(aura, frame)
   if not removed_aura_instance_id_callbacks[aura.auraInstanceID] then
      removed_aura_instance_id_callbacks[aura.auraInstanceID] = {}
   end
   for _, key in next, spell_id_callbacks[aura.spellId] do
      key.on_apply(aura, frame)
      -- Save remove callbacks per key in case several modules register the same spellId
      removed_aura_instance_id_callbacks[aura.auraInstanceID][key] = key.on_remove
   end
end

---@param spellId number
---@param key any has to be unique
---@param on_apply_callback function(arua, frame)
---@param on_remove_callback function(auraInstanceID, frame)
function UnitAura:RegisterSpellIdCallback(spellId, key, on_apply_callback, on_remove_callback)
   if not spell_id_callbacks[spellId] then
      spell_id_callbacks[spellId] = {}
   end
   spell_id_callbacks[spellId][key] = {}
   spell_id_callbacks[spellId][key].on_apply = on_apply_callback
   spell_id_callbacks[spellId][key].on_remove = on_remove_callback
end

---comment Remove a registered callback by key
---@param spellId number
---@param key any as registered
function UnitAura:UnregisterSpellIdCallback(spellId, key)
   if not spell_id_callbacks[spellId] then
      return
   end
   spell_id_callbacks[spellId][key] = nil
end

-- Dispel type callbacks
local dispel_type_callbacks = {
   --[[
   Curse   = {},
   Disease = {},
   Magic   = {},
   Poison  = {},
   Bleed   = {},
   ]]--
}

local function on_apply_dispel(dispelType, aura, frame)
   if not removed_aura_instance_id_callbacks[aura.auraInstanceID] then
      removed_aura_instance_id_callbacks[aura.auraInstanceID] = {}   
      for _, key in next, dispel_type_callbacks[dispelType] do
         key.on_apply(dispelType, aura, frame)
         removed_aura_instance_id_callbacks[aura.auraInstanceID][key] = key.on_remove
      end
   end
end

---comment
---@param dispelType string Curse or Disease or Magic or Poison or Bleed
---@param key any has to be unique
---@param on_apply_callback function(aura, frame)
---@param on_remove_callback function(auraInstanceID, frame)
function UnitAura:RegisterDispelTypeCallback(dispelType, key, on_apply_callback, on_remove_callback)
   if not dispel_type_callbacks[dispelType] then
      dispel_type_callbacks[dispelType] = {}
   end
   dispel_type_callbacks[dispelType][key] = {}
   dispel_type_callbacks[dispelType][key].on_apply = on_apply_callback
   dispel_type_callbacks[dispelType][key].on_remove = on_remove_callback
end

---comment
---@param dispelType string Curse or Disease or Magic or Poison or Bleed
---@param key any as registered
function UnitAura:UnregisterDispelTypeCallback(dispelType, key)
   if not dispel_type_callbacks[dispelType] then
      return
   end
   dispel_type_callbacks[dispelType][key] = nil
end

-- Cached auras 
-- buffs_changed and debuffs_changed indicate wether or not the auras changed in between two CompactUnitFrame_UpdateAuras calls which they often don't so this can be a huge performance boost.
local buff_cache = {}
local buffs_changed = {}
local debuff_cache = {}
local debuffs_changed = {}

-- Aura update
-- FIXME minor Improve performance by i.e. building a cache during combat
-- there will be more options at some point
local function should_show_watchlist_aura(aura)
   local info = watchlist[aura.spellId] or {}
   if ( info.ownOnly and aura.sourceUnit ~= "player" ) then
      return false
   else
      return true
   end
end

local function should_show_help_aura(aura)
   if blacklist[aura.spellId] then
       return false
   end
   if watchlist[aura.spellId] then
       return should_show_watchlist_aura(aura)
   end
   return AuraUtil.ShouldDisplayBuff(aura.sourceUnit, aura.spellId, aura.canApplyAura) 
end

local function should_show_harm_aura(aura)
   if blacklist[aura.spellId] then
       return false
   end
   if watchlist[aura.spellId] then
       return should_show_watchlist_aura(aura)
   end
   return AuraUtil.ShouldDisplayDebuff(aura.sourceUnit, aura.spellId) 
end

local function update_unit_auras(frame, unitAuraUpdateInfo)
   local unit = frame.unit or ""
   -- Get current cache or create one 
   local new_buff_cache = buff_cache[unit] or {}
   local new_buff = false
   local new_debuff_cache = debuff_cache[unit] or {}
   local new_debuff = false
   -- Check if a full update is necessary
   if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
      -- Buffs
      new_buff_cache = {}
      local function handle_help_aura(aura)
         if should_show_help_aura(aura) then
            new_buff_cache[aura.auraInstanceID] = aura
            new_buff = true
            if spell_id_callbacks[aura.spellId] then
               on_apply_aura(aura, frame)
            end
         end
      end
      AuraUtil.ForEachAura(frame.unit, "HELPFUL", nil, handle_help_aura, true)
      -- Debuffs
      new_debuff_cache = {}
      local function handle_harm_aura(aura)
         if should_show_harm_aura(aura) then
            new_debuff_cache[aura.auraInstanceID] = aura
            new_debuff = true
            if spell_id_callbacks[aura.spellId] then
               on_apply_aura(aura, frame)
            end
            if aura.dispelName and dispel_type_callbacks[aura.dispelName] then
               on_apply_dispel(aura.dispelName, aura, frame)
            end
            if dispel_type_callbacks["Bleed"] and BleedList[aura.spellId] then
               on_apply_dispel("Bleed", aura, frame)
            end
         end
      end
      AuraUtil.ForEachAura(frame.unit, "HARMFUL", nil, handle_harm_aura, true)
   else
      -- Added auras
      if unitAuraUpdateInfo.addedAuras ~= nil then
         for _, aura in next, unitAuraUpdateInfo.addedAuras do
            if aura.isHelpful and should_show_help_aura(aura) then
               new_buff_cache[aura.auraInstanceID] = aura
               new_buff = true
               if spell_id_callbacks[aura.spellId] then
                  on_apply_aura(aura, frame)
               end
            elseif aura.isHarmful and should_show_harm_aura(aura) then
               new_debuff_cache[aura.auraInstanceID] = aura
               new_debuff = true
               if spell_id_callbacks[aura.spellId] then
                  on_apply_aura(aura, frame)
               end
               if aura.dispelName and dispel_type_callbacks[aura.dispelName] then
                  on_apply_dispel(aura.dispelName, aura, frame)
               end
               if dispel_type_callbacks["Bleed"] and BleedList[aura.spellId] then
                  on_apply_dispel("Bleed", aura, frame)
               end
            end
         end
      end
      -- Updated auraInstanceID
      if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
         for _, auraInstanceID  in next, unitAuraUpdateInfo.updatedAuraInstanceIDs do
            if new_buff_cache[auraInstanceID] then
               local new_aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID)
               new_buff_cache[auraInstanceID] = new_aura
               new_buff = true
            elseif new_debuff_cache[auraInstanceID] then
               local new_aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID)
               new_debuff_cache[auraInstanceID] = new_aura
               new_debuff = true
            end
         end
      end
      -- Removed auraInstanceID
      if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
         for _, auraInstanceID in next, unitAuraUpdateInfo.removedAuraInstanceIDs do
            if new_buff_cache[auraInstanceID] then
               new_buff_cache[auraInstanceID] = nil
               new_buff = true
            elseif new_debuff_cache[auraInstanceID] then
               new_debuff_cache[auraInstanceID] = nil
               new_debuff = true
            end
            if removed_aura_instance_id_callbacks[auraInstanceID] then
               for _, callback in next, removed_aura_instance_id_callbacks[auraInstanceID] do 
                  callback(auraInstanceID, frame)
               end
               removed_aura_instance_id_callbacks[auraInstanceID] = nil
            end
         end
      end
   end
   buff_cache[unit] = new_buff_cache
   buffs_changed[unit] = new_buff
   debuff_cache[unit] = new_debuff_cache
   debuffs_changed[unit] = new_debuff
end

-- Update all auras on all frames 
-- Use this rarely it will also execute all registered callbacks
function UnitAura:UpdateAllAurasOnAllFrames()
   addon:IterateRoster(update_unit_auras)
end

-- Hooking it this way instead of with HookRegistry gurantees that this hook is first. I will rewrite HookRegistry at some point allowing for priority execution of callbacks
hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame, unitAuraUpdateInfo)
   if not frame or frame:IsForbidden() then
      return
   end
   local name = frame:GetName()
   if not name then
      return
   end
   if not string_sub(name, 1, 7) == "Compact" or string_sub(name, 8, 12) == "Arena" then
      return
   end
   update_unit_auras(frame, unitAuraUpdateInfo)
end)

-- Aura request functions
---@param UnitId
---@return table
function UnitAura:RequestBuffs(unit)
   return buff_cache[unit] or {}, buffs_changed[unit]
end

---@param UnitId
---@return table
function UnitAura:RequestDebuffs(unit)
   return debuff_cache[unit] or {}, debuffs_changed[unit]
end