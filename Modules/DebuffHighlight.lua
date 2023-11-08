local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local module = RaidFrameSettings:NewModule("DebuffHighlight")
Mixin(module, addonTable.hooks)

local playerClass = select(2,UnitClass("player"))
local SetStatusBarColor = SetStatusBarColor
local UnitIsPlayer = UnitIsPlayer
local GetName = GetName
local match = match
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local pairs = pairs
local next = next
local AuraUtil_ForEachAura = AuraUtil.ForEachAura

local debuffColors = {
    Curse   = {r=0.6,g=0.0,b=1.0},
    Disease = {r=0.6,g=0.4,b=0.0},
    Magic   = {r=0.2,g=0.6,b=1.0},
    Poison  = {r=0.0,g=0.6,b=0.0},
    Bleed   = {r=0.8,g=0.0,b=0.0},
}
local canCure = {}
local auraMap = {}
local blockColorUpdate = {}

local updateHealthColor 

local function toDebuffColor(frame, dispelName)
    blockColorUpdate[frame] = true
    frame.healthBar:SetStatusBarColor(debuffColors[dispelName].r, debuffColors[dispelName].g, debuffColors[dispelName].b)
end

local function updateColor(frame)
    for auraInstanceID, dispelName in next, auraMap[frame] do
        if auraInstanceID then
            toDebuffColor(frame, dispelName)
            return
        end
    end
    updateHealthColor(frame)
end

local function updateAurasFull(frame)
    auraMap[frame] = {}
    local function HandleAura(aura)
        if canCure[aura.dispelName] then
            auraMap[frame][aura.auraInstanceID] = aura.dispelName
        end
    end
    AuraUtil_ForEachAura(frame.unit, "HARMFUL", nil, HandleAura, true)  
    updateColor(frame)
end

local function updateAurasIncremental(frame, updateInfo)
    if updateInfo.addedAuras then
        for _, aura in pairs(updateInfo.addedAuras) do
            if aura.isHarmful and canCure[aura.dispelName] then
                auraMap[frame][aura.auraInstanceID] = aura.dispelName
            end
        end
    end
    if updateInfo.removedAuraInstanceIDs then
        for _, auraInstanceID in pairs(updateInfo.removedAuraInstanceIDs) do
            if auraMap[frame][auraInstanceID] then
                auraMap[frame][auraInstanceID] = nil
            end
        end
    end
    updateColor(frame)
end

local hooked = {}
local function makeHooks(frame)
    auraMap[frame] = {}
    --[[
    CompactUnitFrame_UnregisterEvents removes the event handler with frame:SetScript("OnEvent", nil) and thus the hook.
    Interface/FrameXML/CompactUnitFrame.lua
    ]]--
    module:HookScript(frame, "OnEvent", function(frame,event,unit,updateInfo)
        if event ~= "UNIT_AURA" then
            return
        end
        if updateInfo.isFullUpdate then 
            updateAurasFull(frame)
        else
            updateAurasIncremental(frame, updateInfo)
        end
        hooked[frame] = true
    end)
    module:HookScript(frame, "OnShow", function(frame)
        updateAurasFull(frame)
    end)
    module:HookScript(frame, "OnHide", function(frame)
        blockColorUpdate[frame] = nil
    end)
end

function module:OnEnable()
    self:SetUpdateHealthColor()
    local dbObj = RaidFrameSettings.db.profile.DebuffHighlight
    if dbObj.Config.operation_mode == 1 then
        self:RegisterEvents()
        self:UpdateCurable()
    else
        canCure.Curse = dbObj.Config.Curse
        canCure.Disease = dbObj.Config.Disease
        canCure.Magic = dbObj.Config.Magic
        canCure.Poison = dbObj.Config.Poison
        canCure.Bleed = dbObj.Config.Bleed
    end
    self:GetDebuffColors()
    self:HookFunc("CompactUnitFrame_RegisterEvents", function(frame)
        if frame.unit:match("na") then --this will exclude nameplates and arena
            return
        end
        if not UnitIsPlayer(frame.unit) then --exclude pet/vehicle frame
            return
        end
        makeHooks(frame)
    end)  
    self:HookFunc("CompactUnitFrame_UnregisterEvents", function(frame)
        if hooked[frame] then
            blockColorUpdate[frame] = nil
            self:RemoveHandler(frame, "OnEvent")
            hooked[frame] = nil
        end
    end)  
    local onUpdateHealthColor
    if RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 3 then 
        onUpdateHealthColor = function(frame) 
            if blockColorUpdate[frame] then
                updateColor(frame)
            else
                updateHealthColor(frame)
            end
        end
    else
        onUpdateHealthColor = function(frame) 
            if blockColorUpdate[frame] then
                updateColor(frame)
            end
        end
    end
    --[[
        CompactUnitFrame_UpdateHealthColor checks the current healthbar color value and restores it to the designated color if it differs from it.
        If this happens while the frame has a debuff color, we will need to update it again.
    ]]--
    self:HookFuncFiltered("CompactUnitFrame_UpdateHealthColor", onUpdateHealthColor)
    RaidFrameSettings:IterateRoster(function(frame)
        makeHooks(frame)
        updateAurasFull(frame)
    end)
end

function module:OnDisable()
    self:DisableHooks()
    self:UnregisterEvents()
end

function module:UpdateCurable()
    canCure = {}
    local dispelAbilities = {
        ["DRUID"] = function()
            if IsSpellKnown(2782) then --Remove Corruption
                canCure.Curse = true
                canCure.Poison = true
            end
            if IsSpellKnown(88423) then --Nature's Cure
                canCure.Magic = true
                if IsPlayerSpell(392378) then --Improved Nature's Cure
                    canCure.Curse = true
                    canCure.Poison = true
                end
            end
        end,
        ["MAGE"] = function()
            if IsSpellKnown(475) then --Remove Curse
                canCure.Curse = true
            end
        end,
        ["MONK"] = function()
            if IsSpellKnown(218164) then --Detox BM/WW
                canCure.Poison = true
                canCure.Disease = true
            end
            if IsSpellKnown(115450) then --Detox MW 
                canCure.Magic = true
                if IsPlayerSpell(388874) then --Improved Detox 
                    canCure.Poison = true
                    canCure.Disease = true
                end
            end
            if IsSpellKnown(115310) then --Revival
                canCure.Magic = true
                canCure.Poison = true
                canCure.Disease = true
            end
            if IsSpellKnown(115310) then --Restoral
                canCure.Poison = true
                canCure.Disease = true
            end
        end,
        ["PALADIN"] = function()
            if IsSpellKnown(213644) then --Cleanse Toxins
                canCure.Poison = true
                canCure.Disease = true
            end
            if IsSpellKnown(4987) then --Cleanse
                canCure.Magic = true
                if IsPlayerSpell(393024) then --Improved Cleanse
                    canCure.Poison = true
                    canCure.Disease = true
                end
            end
        end,
        ["PRIEST"] = function()
            if IsSpellKnown(527) then --Purify
                canCure.Magic = true
                if IsPlayerSpell(390632) then --Improved Purify
                    canCure.Disease = true
                end
            end
            if IsSpellKnown(213634) then --Purify Disease
                canCure.Disease = true
            end
            if IsSpellKnown(32375) then --Mass Dispel
                canCure.Magic = true
            end
        end,
        ["SHAMAN"] = function()
            if IsSpellKnown(51886) then --Cleanse Spirit
                canCure.Curse = true
            end
            if IsSpellKnown(77130) then --Purify Spirit
                canCure.Magic = true
                if IsPlayerSpell(383016) then --Improved Purify Spirit
                    canCure.Curse = true
                end
            end
            if IsSpellKnown(383013) then --Poision Cleansing Totem
                canCure.Poison = true
            end
        end,
        ["WARLOCK"] = function()
            if IsSpellKnown(89808, true) then --Singe Magic
                canCure.Magic = true
            end
        end,
        ["EVOKER"] = function()
            if IsSpellKnown(374251) then --Cauterizing Flame
                canCure.Curse = true
                canCure.Poison = true
                canCure.Disease = true
            end
            if IsSpellKnown(365585) then --Expunge 
                canCure.Poison = true
            end
            if IsSpellKnownOrOverridesKnown(360823) then --Naturalize 
                canCure.Magic = true
                canCure.Poison = true
            end
        end,
        ["DEMONHUNTER"] = function()
            if IsSpellKnown(205604) then --Reverse Magic
                canCure.Magic = true
            end
        end,
        ["HUNTER"] = function()
            if IsSpellKnown(212640) then --Mending Bandage
                canCure.Poison = true
                canCure.Disease = true
            end
        end,
    }
    if dispelAbilities[playerClass] then
        dispelAbilities[playerClass]()
    end
end

function module:SetUpdateHealthColor()
    if RaidFrameSettings.db.profile.Module.HealthBars then
        local selected = RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode
        local useClassColors = selected == 1 and true or false
        local useOverrideColor = selected == 2 and true or false
        local useCustomColor = selected == 3 and true or false
        if useClassColors then
            updateHealthColor = function(frame)
                if not frame or not frame.unit then 
                    return 
                end
                blockColorUpdate[frame] = false
                local _, englishClass = UnitClass(frame.unit)
                local r,g,b = GetClassColor(englishClass)
                frame.healthBar:SetStatusBarColor(r,g,b)
            end
        elseif useOverrideColor then
            updateHealthColor = function(frame)
                if not frame then 
                    return 
                end
                blockColorUpdate[frame] = false
                frame.healthBar:SetStatusBarColor(0,1,0)
            end
        elseif useCustomColor then
            local color = RaidFrameSettings.db.profile.HealthBars.Colors.statusbar
            updateHealthColor = function(frame)
                if not frame then 
                    return 
                end
                blockColorUpdate[frame] = false
                frame.healthBar:SetStatusBarColor(color.r,color.g,color.b) 
            end
        end
    else
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            updateHealthColor = function(frame)
                if not frame then 
                    return 
                end
                blockColorUpdate[frame] = false
                frame.healthBar:SetStatusBarColor(0,1,0)
            end
        else
            updateHealthColor = function(frame)
                if not frame or not frame.unit then 
                    return 
                end
                blockColorUpdate[frame] = false
                local _, englishClass = UnitClass(frame.unit)
                local r,g,b = GetClassColor(englishClass)
                frame.healthBar:SetStatusBarColor(r,g,b)
            end
        end
    end
end

function module:GetDebuffColors()
    local dbObj = RaidFrameSettings.db.profile.DebuffHighlight.DebuffColors
    debuffColors.Curse = dbObj.Curse
    debuffColors.Disease = dbObj.Disease
    debuffColors.Magic = dbObj.Magic
    debuffColors.Poison = dbObj.Poison
    debuffColors.Bleed = dbObj.Bleed
end

local eventFrame = nil
function module:RegisterEvents()
    if not eventFrame then
        eventFrame = CreateFrame("Frame")
    end
    eventFrame:SetScript("OnEvent", function()
        self:UpdateCurable()
    end)
    eventFrame:RegisterEvent("LEARNED_SPELL_IN_TAB")
    eventFrame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
    if playerClass == "WARLOCK" then
        eventFrame:RegisterUnitEvent("UNIT_PET", "player")
    end
end

function module:UnregisterEvents()
    if not eventFrame then
        return
    end
    eventFrame:UnregisterAllEvents()
end