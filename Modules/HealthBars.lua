--[[
    Created by Slothpala
    i will rename this to StatusBars.lua at some point.
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local HealthBars = RaidFrameSettings:NewModule("HealthBars")
Mixin(HealthBars, addonTable.hooks)
local Media = LibStub("LibSharedMedia-3.0")

--wow api speed reference
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsTapDenied = UnitIsTapDenied
local UnitInVehicle = UnitInVehicle
local GetStatusBarTexture = GetStatusBarTexture
local SetStatusBarTexture = SetStatusBarTexture
local SetStatusBarColor = SetStatusBarColor
local SetTexture = SetTexture
local SetVertexColor = SetVertexColor
local SetPoint = SetPoint
local SetBackdrop = SetBackdrop
local ApplyBackdrop = ApplyBackdrop
local SetBackdropBorderColor = SetBackdropBorderColor


function HealthBars:OnEnable()
    --textures
    local backdropInfo = {
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        tileEdge = true,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1},
    }
    local statusBarTexture  = Media:Fetch("statusbar", RaidFrameSettings.db.profile.HealthBars.Textures.statusbar)
    local backgroundTexture = Media:Fetch("statusbar", RaidFrameSettings.db.profile.HealthBars.Textures.background)
    local powerBarTexture   = Media:Fetch("statusbar", RaidFrameSettings.db.profile.HealthBars.Textures.powerbar)
    local backgroundColor   = RaidFrameSettings.db.profile.HealthBars.Colors.background
    local borderColor       = RaidFrameSettings.db.profile.HealthBars.Colors.border
    --callbacks 
    --only apply the power bar texture if the power bar is shown
    local updateTextures
    --with powerbar
    if DefaultCompactUnitFrameSetupOptions and DefaultCompactUnitFrameSetupOptions.displayPowerBar == true then
        updateTextures = function(frame)
            frame.healthBar:SetStatusBarTexture(statusBarTexture)
            frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
            frame.background:SetTexture(backgroundTexture)
            frame.background:SetVertexColor(backgroundColor.r,backgroundColor.g,backgroundColor.b)
            frame.powerBar:SetStatusBarTexture(powerBarTexture)
            frame.powerBar.background:SetPoint("TOPLEFT",frame.healthBar, "BOTTOMLEFT", 0, 1)
            frame.powerBar.background:SetPoint("BOTTOMRIGHT", frame.background, "BOTTOMRIGHT", 0, 0) 
            if not frame.backdropInfo then
                Mixin(frame, BackdropTemplateMixin) 
                frame:SetBackdrop(backdropInfo)
            end
            frame:ApplyBackdrop()
            frame:SetBackdropBorderColor(borderColor.r,borderColor.g,borderColor.b)
        end
    --without power bar 
    else
        updateTextures = function(frame)
            frame.healthBar:SetStatusBarTexture(statusBarTexture)
            frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
            frame.background:SetTexture(backgroundTexture)
            frame.background:SetVertexColor(backgroundColor.r,backgroundColor.g,backgroundColor.b)
            if not frame.backdropInfo then
                Mixin(frame, BackdropTemplateMixin) 
                frame:SetBackdrop(backdropInfo)
            end
            frame:ApplyBackdrop()
            frame:SetBackdropBorderColor(borderColor.r,borderColor.g,borderColor.b)
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", updateTextures)
    self:HookFunc("DefaultCompactMiniFrameSetup", function(frame)
        local unit = frame.unit
        if not unit or not unit:match("pet") then 
            return
        end
        for _,border in pairs({
            "horizTopBorder",
            "horizBottomBorder",
            "vertLeftBorder",
            "vertRightBorder",
        }) do
            if frame[border] then
                frame[border]:SetAlpha(0)
            end
        end
        updateTextures(frame)
    end)
    --colors
    local selected = RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode
    local useClassColors = selected == 1 and true or false
    local useOverrideColor = selected == 2 and true or false
    local useCustomColor = selected == 3 and true or false
    local updateHealthColor
    if useClassColors then
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            C_CVar.SetCVar("raidFramesDisplayClassColor","1")
        end
        updateHealthColor = function(frame)
            if not frame or not frame.unit then 
                return 
            end
            local _, englishClass = UnitClass(frame.unit)
            local r,g,b = GetClassColor(englishClass)
            frame.healthBar:SetStatusBarColor(r,g,b)
        end
    elseif useOverrideColor then
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" then
            C_CVar.SetCVar("raidFramesDisplayClassColor","0")
        end
        updateHealthColor = function(frame)
            frame.healthBar:SetStatusBarColor(0,1,0)
        end
    elseif useCustomColor then
        local color = RaidFrameSettings.db.profile.HealthBars.Colors.statusbar
        updateHealthColor = function(frame)
            frame.healthBar:SetStatusBarColor(color.r,color.g,color.b) 
        end
        if not RaidFrameSettings.db.profile.Module.AuraHighlight then
            self:HookFuncFiltered("CompactUnitFrame_UpdateHealthColor", updateHealthColor)
        end
    end
    if RaidFrameSettings.db.profile.Module.AuraHighlight and addonTable.isRetail then
        RaidFrameSettings:UpdateModule("AuraHighlight")
    end
    RaidFrameSettings:IterateRoster(function(frame)
        updateTextures(frame)
        updateHealthColor(frame)
    end)
end

function HealthBars:OnDisable()
    self:DisableHooks()
    local restoreStatusBars = function(frame)
        frame.healthBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
        frame.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Bg")
        frame.background:SetTexCoord(0, 1, 0, 0.53125)
        frame.powerBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")
        frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
        if frame.backdropInfo then
            frame:ClearBackdrop() 
        end
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" then
            if not frame.unit then return end
            local _, englishClass = UnitClass(frame.unit)
            local r,g,b = GetClassColor(englishClass)
            frame.healthBar:SetStatusBarColor(r,g,b)
        else
            frame.healthBar:SetStatusBarColor(0,1,0)
        end
    end
    RaidFrameSettings:IterateRoster(restoreStatusBars)
end

