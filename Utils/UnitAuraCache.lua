--[[Created by Slothpala]]--

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

-- Speed references

-- Blacklist 
local blacklist = {}

function addon:UnitAuraCache_UpdateBlacklist()
   blacklist = {}
   for spellId, _ in pairs(addon.db.profile.Blacklist) do
      blacklist[tonumber(spellId)] = true
   end
end

-- Cached auras
local buff_cache = {}
local debuff_cache = {}

local function update_unit_auras(unit, unitAuraUpdateInfo)
   -- Get current cache or create one 
   local new_buff_cache = buff_cache[unit] or {}
   local new_debuff_cache = debuff_cache[unit] or {}
   -- Check if a full update is necessary

   buff_cache[unit] = new_buff_cache
   debuff_cache[unit] = new_buff_cache
end

-- Aura request functions
---@param UnitId
function addon:UnitAuraCache_RequestBuffCache(unit)
   return buff_cache[unit] or {}
end

---@param UnitId
function addon:UnitAuraCache_RequestDebuffCache(unit)
   return debuff_cache[unit] or {}
end