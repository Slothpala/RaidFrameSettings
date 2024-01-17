local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local module = RaidFrameSettings:NewModule("AuraHighlight")
Mixin(module, addonTable.hooks)
local LCD --LibCanDispel or custom defined in OnEnable

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

local Bleeds = addonTable.Bleeds
local auraMap = {}

local aura_missing_list = {}
local missingAuraColor = {r=0.8156863451004028,g=0.5803921818733215,b=0.658823549747467}

local blockColorUpdate = {}

local updateHealthColor 

local function toDebuffColor(frame, dispelName)
    blockColorUpdate[frame] = true
    frame.healthBar:SetStatusBarColor(debuffColors[dispelName].r, debuffColors[dispelName].g, debuffColors[dispelName].b)
end

local function updateColor(frame)
    for auraInstanceID, dispelName in next, auraMap[frame].debuffs do
        if auraInstanceID then
            toDebuffColor(frame, dispelName)
            return
        end
    end
    updateHealthColor(frame)
end

local function updateAurasFull(frame)
    auraMap[frame] = {}
    auraMap[frame].debuffs = {}
    auraMap[frame].missing_list = {}
    local function HandleHarmAura(aura)
        if aura.dispelName and LCD:CanDispel(aura.dispelName) then
            auraMap[frame].debuffs[aura.auraInstanceID] = aura.dispelName
        end
        if Bleeds[aura.spellId] and LCD:CanDispel("Bleed") then 
            auraMap[frame].debuffs[aura.auraInstanceID] = "Bleed"
        end
    end
    local function HandleHelpAura(aura)
        if aura_missing_list[aura.spellId] then
            auraMap[frame].missing_list[aura.auraInstanceID] = aura.spellId
        end
    end
    AuraUtil_ForEachAura(frame.unit, "HARMFUL", nil, HandleHarmAura, true)
    AuraUtil_ForEachAura(frame.unit, "HELPFUL", nil, HandleHelpAura, true)
    updateColor(frame)
end

local function updateAurasIncremental(frame, updateInfo)
    if updateInfo.addedAuras then
        for _, aura in pairs(updateInfo.addedAuras) do
            if aura.isHarmful and aura.dispelName and LCD:CanDispel(aura.dispelName) then
                auraMap[frame].debuffs[aura.auraInstanceID] = aura.dispelName
            end
            if Bleeds[aura.spellId] and LCD:CanDispel("Bleed") then 
                auraMap[frame].debuffs[aura.auraInstanceID] = "Bleed"
            end
            if aura_missing_list[aura.spellId] then
                auraMap[frame].missing_list[aura.auraInstanceID] = aura.spellId
            end
        end
    end
    if updateInfo.removedAuraInstanceIDs then
        for _, auraInstanceID in pairs(updateInfo.removedAuraInstanceIDs) do
            if auraMap[frame].debuffs[auraInstanceID] then
                auraMap[frame].debuffs[auraInstanceID] = nil
            end
            if auraMap[frame].missing_list[auraInstanceID] then
                auraMap[frame].missing_list[auraInstanceID] = nil
            end
        end
    end
    updateColor(frame)
end

function module:HookFrame(frame)
    auraMap[frame] = {}
    auraMap[frame].debuffs = {}
    auraMap[frame].missing_list = {}
    --[[
        CompactUnitFrame_UnregisterEvents removes the event handler with frame:SetScript("OnEvent", nil) and thus the hook.
        Interface/FrameXML/CompactUnitFrame.lua
    ]]--
    self:RemoveHandler(frame, "OnEvent") --remove the registry key for frame["OnEvent"] so that it actually gets hooked again and not just stores a callback for an non existing hook
    self:HookScript(frame, "OnEvent", function(frame,event,unit,updateInfo)
        if event ~= "UNIT_AURA" then
            return
        end
        if updateInfo.isFullUpdate then 
            updateAurasFull(frame)
        else
            updateAurasIncremental(frame, updateInfo)
        end
    end)
    self:HookScript(frame, "OnShow", function(frame)
        updateAurasFull(frame)
    end)
    self:HookScript(frame, "OnHide", function(frame)
        blockColorUpdate[frame] = nil
    end)
end

function module:SetUpdateHealthColor()
    if RaidFrameSettings.db.profile.Module.HealthBars then
        local selected = RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode
        local useClassColors = selected == 1 and true or false
        local useOverrideColor = selected == 2 and true or false
        local useCustomColor = selected == 3 and true or false
        local function hasMissingAura(frame) 
            if next(aura_missing_list) == nil then
                return false
            end
            if not auraMap[frame] then
                return false
            end
            local reverse_missing_list = {}
            for auraInstanceID, spellId in next, auraMap[frame].missing_list do
                reverse_missing_list[spellId] = true
            end
            for spellId, name in next, aura_missing_list do
                if not reverse_missing_list[spellId] then
                    return true
                end
            end
            return false
        end
        if useClassColors then
            updateHealthColor = function(frame)
                if not frame or not frame.unit then 
                    return 
                end
                blockColorUpdate[frame] = false
                if hasMissingAura(frame) then
                    frame.healthBar:SetStatusBarColor(missingAuraColor.r,missingAuraColor.g,missingAuraColor.b)
                else
                    local _, englishClass = UnitClass(frame.unit)
                    local r,g,b = GetClassColor(englishClass)
                    frame.healthBar:SetStatusBarColor(r,g,b)
                end
            end
        elseif useOverrideColor then
            updateHealthColor = function(frame)
                if not frame then 
                    return 
                end
                blockColorUpdate[frame] = false
                if hasMissingAura(frame) then
                    frame.healthBar:SetStatusBarColor(missingAuraColor.r,missingAuraColor.g,missingAuraColor.b)
                else
                    frame.healthBar:SetStatusBarColor(0,1,0)
                end
            end
        elseif useCustomColor then
            local color = RaidFrameSettings.db.profile.HealthBars.Colors.statusbar
            updateHealthColor = function(frame)
                if not frame then 
                    return 
                end
                blockColorUpdate[frame] = false
                if hasMissingAura(frame) then
                    frame.healthBar:SetStatusBarColor(missingAuraColor.r,missingAuraColor.g,missingAuraColor.b)
                else
                    frame.healthBar:SetStatusBarColor(color.r,color.g,color.b) 
                end
            end
        end
    else
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            updateHealthColor = function(frame)
                if not frame then 
                    return 
                end
                blockColorUpdate[frame] = false
                if hasMissingAura(frame) then
                    frame.healthBar:SetStatusBarColor(missingAuraColor.r,missingAuraColor.g,missingAuraColor.b)
                else
                    frame.healthBar:SetStatusBarColor(0,1,0)
                end
            end
        else
            updateHealthColor = function(frame)
                if not frame or not frame.unit then 
                    return 
                end
                blockColorUpdate[frame] = false
                if hasMissingAura(frame) then
                    frame.healthBar:SetStatusBarColor(missingAuraColor.r,missingAuraColor.g,missingAuraColor.b)
                else
                    local _, englishClass = UnitClass(frame.unit)
                    local r,g,b = GetClassColor(englishClass)
                    frame.healthBar:SetStatusBarColor(r,g,b)
                end
            end
        end
    end
end

function module:GetDebuffColors()
    local dbObj = RaidFrameSettings.db.profile.AuraHighlight.DebuffColors
    debuffColors.Curse = dbObj.Curse
    debuffColors.Disease = dbObj.Disease
    debuffColors.Magic = dbObj.Magic
    debuffColors.Poison = dbObj.Poison
    debuffColors.Bleed = dbObj.Bleed
end

function module:OnEnable()
    self:SetUpdateHealthColor()
    local dbObj = RaidFrameSettings.db.profile.AuraHighlight
    aura_missing_list = dbObj.MissingAura[addonTable.playerClass].spellIDs
    missingAuraColor = dbObj.MissingAura.missingAuraColor
    if dbObj.Config.operation_mode == 1 then
        LCD = {}
        LCD = LibStub("LibCanDispel-1.0")
    else
        local shownDispelType = {
            ["Curse"] = dbObj.Config.Curse,
            ["Disease"] = dbObj.Config.Disease,
            ["Magic"] = dbObj.Config.Magic,
            ["Poison"] = dbObj.Config.Poison,
            ["Bleed"] = dbObj.Config.Bleed,
        }
        LCD = {}
        function LCD:CanDispel(dispelName)
            return shownDispelType[dispelName]
        end
    end
    self:GetDebuffColors()
    self:HookFunc("CompactUnitFrame_RegisterEvents", function(frame)
        if frame.unit:match("na") then --this will exclude nameplates and arena
            return
        end
        if not UnitIsPlayer(frame.unit) then --exclude pet/vehicle frame
            return
        end
        self:HookFrame(frame)                          
    end)   
    local onUpdateHealthColor = function(frame) 
        if blockColorUpdate[frame] then
            updateColor(frame)
        else
            updateHealthColor(frame)
        end
    end

    --[[
        CompactUnitFrame_UpdateHealthColor checks the current healthbar color value and restores it to the designated color if it differs from it.
        If this happens while the frame has a debuff color, we will need to update it again.
    ]]--
    self:HookFuncFiltered("CompactUnitFrame_UpdateHealthColor", onUpdateHealthColor)
    RaidFrameSettings:IterateRoster(function(frame)
        self:HookFrame(frame)
        updateAurasFull(frame)
    end)
end

function module:OnDisable()
    self:DisableHooks()
end

