--[[Created by Slothpala]]--

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
addonTable.UnitAuraCache = {}
local UnitAuraCache = addonTable.UnitAuraCache

-- Speed references
-- WoW Api
local AuraUtil_ForEachAura = AuraUtil.ForEachAura
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local AuraUtil_ShouldDisplayBuff = AuraUtil.ShouldDisplayBuff
local AuraUtil_ShouldDisplayDebuff = AuraUtil.ShouldDisplayDebuff
-- Lua
local string_sub = string.sub

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

-- Dispel type callbacks 
local dispel_type_callbacks = {}
function UnitAuraCache:AddDispelTypeCallback(dispelType, key, callback)
   if not dispel_type_callbacks[dispelType] then
      dispel_type_callbacks[dispelType] = {}
   end
   dispel_type_callbacks[dispelType][key] = callback
end

function UnitAuraCache:RemoveDispelTypeCallback(dispelType, key)
   if not dispel_type_callbacks[dispelType] or not dispel_type_callbacks[dispelType][key] then
      return
   end
   dispel_type_callbacks[dispelType][key] = nil
end

-- spellId callbakcs
local spell_id_callbacks = {}

---@param spellId number
---@param callback function
function UnitAuraCache:AddSpellIdCallback(spellId, callback)
   spell_id_callbacks[spellId] = callback
end

---@param spellId number
function UnitAuraCache:RemoveSpellIdCallback(spellId)
   spell_id_callbacks[spellId] = nil
end

local function update_unit_auras(frame, unitAuraUpdateInfo)
   local unit = frame.unit or ""
   -- Get current cache or create one 
   local new_buff_cache = buff_cache[unit] or {}
   local new_debuff_cache = debuff_cache[unit] or {}
   -- Check if a full update is necessary
   if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
      -- Buffs
      new_buff_cache = {}
      local function handle_help_aura(aura)
         if not blacklist[aura.spellId] then
            new_buff_cache[aura.auraInstanceID] = aura
         end
      end
      AuraUtil_ForEachAura(frame.unit, "HELPFUL", nil, handle_help_aura, true)
      -- Debuffs
      new_debuff_cache = {}
      local function handle_harm_aura(aura)
         if not blacklist[aura.spellId] then
            new_debuff_cache[aura.auraInstanceID] = aura
         end
      end
      AuraUtil_ForEachAura(frame.unit, "HARMFUL", nil, handle_harm_aura, true)
   else
      -- Added auras
      if unitAuraUpdateInfo.addedAuras ~= nil then
         for _, aura in next, unitAuraUpdateInfo.addedAuras do
            if not blacklist[aura.spellId] then
               if aura.isHelpful then
                  new_buff_cache[aura.auraInstanceID] = aura
               elseif aura.isHarmful then
                  new_debuff_cache[aura.auraInstanceID] = aura
               end
            end
         end
      end
      -- Updated auraInstanceID
      if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
         for _, auraInstanceID  in next, unitAuraUpdateInfo.updatedAuraInstanceIDs do
            if new_buff_cache[auraInstanceID] then
               local new_aura = C_UnitAuras_GetAuraDataByAuraInstanceID(unit, auraInstanceID)
               new_buff_cache[auraInstanceID] = new_aura
            elseif new_debuff_cache[auraInstanceID] then
               local new_aura = C_UnitAuras_GetAuraDataByAuraInstanceID(unit, auraInstanceID)
               new_debuff_cache[auraInstanceID] = new_aura
            end
         end
      end
      -- Removed auraInstanceID
      if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
         for _, auraInstanceID in next, unitAuraUpdateInfo.removedAuraInstanceIDs do
            if new_buff_cache[auraInstanceID] then
               new_buff_cache[auraInstanceID] = nil
            elseif new_debuff_cache[auraInstanceID] then
               new_debuff_cache[auraInstanceID] = nil
            end
         end
      end
   end
   buff_cache[unit] = new_buff_cache
   debuff_cache[unit] = new_debuff_cache
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", function (frame, unitAuraUpdateInfo)
   -- Should filter out the same frames as HookFuncFiltered from HookRegistry
   if not frame or frame:IsForbidden() then
      return
   end
   local name = frame:GetName()
   if not name then
      return
   end
   if not string_sub(name, 1, 7) == "Compact" then
      return
   end
   update_unit_auras(frame, unitAuraUpdateInfo)
end)

-- Aura request functions
---@param UnitId
---@return table
function UnitAuraCache:RequestBuffs(unit)
   return buff_cache[unit] or {}
end

---@param UnitId
---@return table
function UnitAuraCache:RequestDebuffs(unit)
   return debuff_cache[unit] or {}
end