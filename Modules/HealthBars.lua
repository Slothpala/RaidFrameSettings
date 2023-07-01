--[[
    Created by Slothpala
--]]
--wow api speed reference
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsTapDenied = UnitIsTapDenied
local UnitInVehicle = UnitInVehicle

local HealthBars = RaidFrameSettings:NewModule("HealthBars")
local Media = LibStub("LibSharedMedia-3.0")

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
    local UpdateAllCallback
    --with powerbar
    if C_CVar.GetCVar("raidFramesDisplayPowerBars") == "1" then
        UpdateAllCallback = function(frame)
            frame.healthBar:SetStatusBarTexture(statusBarTexture)
            frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
            frame.background:SetTexture(backgroundTexture)
            frame.background:SetVertexColor(backgroundColor.r,backgroundColor.g,backgroundColor.b)
            frame.powerBar:SetStatusBarTexture(powerBarTexture)
            frame.powerBar.background:SetPoint("TOPLEFT",frame.healthBar, "BOTTOMLEFT", 0, 1)
            frame.powerBar.background:SetPoint("BOTTOMRIGHT", frame.background, "BOTTOMRIGHT", 0, 0) 
            if not frame.Backdrop then
                Mixin(frame, BackdropTemplateMixin) 
                frame:SetBackdrop(backdropInfo)
            end
            frame:ApplyBackdrop()
            frame:SetBackdropBorderColor(borderColor.r,borderColor.g,borderColor.b)
        end
    --without power bar 
    else
        UpdateAllCallback = function(frame)
            frame.healthBar:SetStatusBarTexture(statusBarTexture)
            frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
            frame.background:SetTexture(backgroundTexture)
            frame.background:SetVertexColor(backgroundColor.r,backgroundColor.g,backgroundColor.b)
            if not frame.Backdrop then
                Mixin(frame, BackdropTemplateMixin) 
                frame:SetBackdrop(backdropInfo)
            end
            frame:ApplyBackdrop()
            frame:SetBackdropBorderColor(borderColor.r,borderColor.g,borderColor.b)
        end
    end
    RaidFrameSettings:RegisterOnUpdateAll(UpdateAllCallback)
    --colors
    if RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 3 then --static color
        local statusBarColor = RaidFrameSettings.db.profile.HealthBars.Colors.statusbar
        local function UpdateHealthColor(frame)
            frame.healthBar:SetStatusBarColor(statusBarColor.r,statusBarColor.g,statusBarColor.b) 
        end
        if not RaidFrameSettings.db.profile.Module.DispelColor then
            RaidFrameSettings:RegisterOnUpdateHealthColor(UpdateHealthColor)
        end
    elseif RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 1 then --class color
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            C_CVar.SetCVar("raidFramesDisplayClassColor","1")
        else
            local function toClassColor(frame)
                if not frame or not frame.unit then return end
                local _, englishClass = UnitClass(frame.unit)
                local r,g,b = GetClassColor(englishClass)
                frame.healthBar:SetStatusBarColor(r,g,b)
            end
            RaidFrameSettings:IterateRoster(toClassColor)
        end
    elseif RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 2 then --green color
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" then
            C_CVar.SetCVar("raidFramesDisplayClassColor","0")
        else
            local function toOverrideColor(frame)
                frame.healthBar:SetStatusBarColor(0,1,0)
            end
            RaidFrameSettings:IterateRoster(toOverrideColor)
        end
    end
end

function HealthBars:OnDisable()

end
