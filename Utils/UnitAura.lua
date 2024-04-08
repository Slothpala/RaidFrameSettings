--[[Created by Slothpala]]--

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
addonTable.UnitAura = {}
local UnitAura = addonTable.UnitAura
Mixin(UnitAura, addonTable.hooks)

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

function UnitAura:UpdateBlacklist()
   blacklist = {}
   for spellId, _ in pairs(addon.db.profile.Blacklist) do
      blacklist[tonumber(spellId)] = true
   end
end

-- [[ spellId and disple type functions here ]]

-- Cached auras
local buff_cache = {}
local debuff_cache = {}

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

-- Functions to control cache building based on if cache consumers are registered

local is_caching = false
function UnitAura:StartCaching()
   is_caching = true
   addon:IterateRoster(update_unit_auras)
   -- CompactUnitFrame_UpdateAuras delivers us the unitAuraUpdateInfo for all CompactUnitFrames which for this addon is all we care a about.
   self:HookFuncFiltered("CompactUnitFrame_UpdateAuras", update_unit_auras)
end

function UnitAura:StopCaching()
   is_caching = false
   self:DisableHooks()
end

local aura_cache_consumer = {}

---@param name any
function UnitAura:RegisterConsumer(name)
   if not is_caching then
      self:StartCaching()
   end
   aura_cache_consumer[name] = true
end

---@param name any
function UnitAura:UnregisterConsumer(name)
   aura_cache_consumer[name] = nil
   if next(aura_cache_consumer) == nil then
      self:StopCaching()
   end
end

-- Aura request functions
---@param UnitId
---@return table
function UnitAura:RequestBuffs(unit)
   return buff_cache[unit] or {}
end

---@param UnitId
---@return table
function UnitAura:RequestDebuffs(unit)
   return debuff_cache[unit] or {}
end