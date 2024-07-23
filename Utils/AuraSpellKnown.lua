--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local IsPlayerSpell = IsPlayerSpell
local IsSpellKnown = IsSpellKnown
local IsSpellKnownOrOverridesKnown = IsSpellKnownOrOverridesKnown

local cache_needs_rebuilding = true
local known_talent_cache = {}

local function build_known_talent_cache()
  table.wipe(known_talent_cache)

  local config_id = C_ClassTalents.GetActiveConfigID()
  if not config_id then
    return
  end

  local config_info = C_Traits.GetConfigInfo(config_id)
  if not config_info then
    return
  end

  for _, tree_id in ipairs(config_info.treeIDs) do
    local nodes = C_Traits.GetTreeNodes(tree_id)
    for i, node_id in ipairs(nodes) do
      local node_info = C_Traits.GetNodeInfo(config_id, node_id)
      for _, entry_id in ipairs(node_info.entryIDsWithCommittedRanks) do
        local entry_info = C_Traits.GetEntryInfo(config_id, entry_id)
        if entry_info and entry_info.definitionID then
          local definition_info = C_Traits.GetDefinitionInfo(entry_info.definitionID)
          local spell = Spell:CreateFromSpellID(definition_info.spellID)
          local spell_name = spell and spell:GetSpellName()
          if spell_name then
            known_talent_cache[spell_name] = true
          end
        end
      end
    end
  end

  cache_needs_rebuilding = false
end

--- IsPlayerSpell fails for some passive talents like Spring Blossoms.
local function is_player_spell(spell_id)
  if cache_needs_rebuilding then
    build_known_talent_cache()
  end
  local spell = Spell:CreateFromSpellID(spell_id)
  if not spell then
    return false
  end
  local spell_name = spell:GetSpellName()
  return known_talent_cache[spell_name] and true or false
end

local function set_update_flag()
  cache_needs_rebuilding = true
end

local event_frame = CreateFrame("Frame")
event_frame:SetScript("OnEvent", set_update_flag)
event_frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
event_frame:RegisterEvent("TRAIT_CONFIG_UPDATED")

--- Aura spellIds do not always match their "parent" spellIds.
---@param spell_id number
function addon:IsPlayerAura(spell_id)
  return IsPlayerSpell(spell_id) or IsSpellKnown(spell_id) or IsSpellKnownOrOverridesKnown(spell_id) or is_player_spell(spell_id)
end


