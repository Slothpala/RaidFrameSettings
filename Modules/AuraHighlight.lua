local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local module = RaidFrameSettings:NewModule("AuraHighlight")
Mixin(module, addonTable.hooks)
local LCD --LibCanDispel or custom defined in OnEnable
local LCG --libCustomGlow

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

local useHealthBarColor
local useHealthBarGlow

local glowOpt = {
    lines     = nil,
    frequency = nil,
    length    = nil,
    thickness = 3,
    XOffset   = nil,
    YOffset   = nil,
    border    = true,
}

local function toDebuffColor(frame, dispelName)
    blockColorUpdate[frame] = true
    if useHealthBarColor then
        frame.healthBar:SetStatusBarColor(debuffColors[dispelName].r, debuffColors[dispelName].g, debuffColors[dispelName].b)
    end
    if useHealthBarGlow then
        module:Glow(frame, debuffColors[dispelName])
    end
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
        if aura_missing_list[aura.spellId] and aura.sourceUnit == "player" then
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
            if aura_missing_list[aura.spellId] and aura.sourceUnit == "player" then
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

function module:Glow(frame, rgb)
    if not LCG then
        LCG = LibStub("LibCustomGlow-1.0")
    end
    if not frame then
        return
    end
    if not frame._rfs_glow_frame then
        frame._rfs_glow_frame = CreateFrame("Frame", nil, frame)
        frame._rfs_glow_frame:SetAllPoints(frame)
        frame._rfs_glow_frame:SetSize(frame:GetSize())
    end
    local glow_frame = frame._rfs_glow_frame

    if not rgb then
        -- glow off
        if glow_frame.started then
            LCG.PixelGlow_Stop(frame._rfs_glow_frame)
            glow_frame.started = false
        end
        return
    end

    -- glow on
    local scale = frame:GetParent():GetScale() or 1
    if glow_frame.started then
        if glow_frame.color.r == rgb.r and glow_frame.color.g == rgb.g and glow_frame.color.b == rgb.b and glow_frame.scale == scale then
            return
        end
        LCG.PixelGlow_Stop(frame._rfs_glow_frame)
        glow_frame.started = false
    end
    local scale = frame:GetParent():GetScale() or 1
    LCG.PixelGlow_Start(
        glow_frame,
        {rgb.r, rgb.g, rgb.b, 1},
        glowOpt.lines,
        glowOpt.frequency,
        glowOpt.length,
        glowOpt.thickness and glowOpt.thickness * scale,
        glowOpt.XOffset,
        glowOpt.YOffset,
        glowOpt.border and true or false
    )
    glow_frame.started = true
    glow_frame.color = rgb
    glow_frame.scale = scale
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
    local r,g,b = 0,1,0
    local useClassColors
    if RaidFrameSettings.db.profile.Module.HealthBars then
        local selected = RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode
        if selected == 1 then
            useClassColors = true
        elseif selected == 2 then
            -- r,g,b = 0,1,0 -- r,g,b default = 0,1,0

        elseif selected == 3 then
            local color = RaidFrameSettings.db.profile.HealthBars.Colors.statusbar
            r,g,b = color.r,color.g,color.b
        end
    else
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            -- r,g,b = 0,1,0 -- r,g,b default = 0,1,0
        else
            useClassColors = true
        end
    end

    updateHealthColor = function(frame)
        if not frame then
            return
        end
        blockColorUpdate[frame] = false
        if hasMissingAura(frame) then
            if useHealthBarColor then
                frame.healthBar:SetStatusBarColor(missingAuraColor.r,missingAuraColor.g,missingAuraColor.b)
            end
            if useHealthBarGlow then
                module:Glow(frame, missingAuraColor)
            end
        else
            if useClassColors then
                if not frame.unit then
                    return
                end
                local _, englishClass = UnitClass(frame.unit)
                r,g,b = GetClassColor(englishClass)
            end
            frame.healthBar:SetStatusBarColor(r,g,b)
            if useHealthBarGlow then
                module:Glow(frame, false)
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
    useHealthBarColor = dbObj.Config.useHealthBarColor
    useHealthBarGlow = dbObj.Config.useHealthBarGlow
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
    RaidFrameSettings:IterateRoster(function(frame)
        local r, g, b = 0, 1, 0
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            -- r,g,b = 0,1,0 -- this is default
        else
            if frame.unit then
                local _, englishClass = UnitClass(frame.unit)
                r, g, b = GetClassColor(englishClass)
            end
        end
        frame.healthBar:SetStatusBarColor(r, g, b)
        module:Glow(frame, false)
    end)
end

