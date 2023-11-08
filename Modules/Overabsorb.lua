--[[
    Created by Slothpala
    Based on https://www.curseforge.com/wow/addons/derangement-shieldmeters.
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local Overabsorb = RaidFrameSettings:NewModule("Overabsorb")
Mixin(Overabsorb, addonTable.hooks)

local ClearAllPoints = ClearAllPoints
local SetPoint = SetPoint
local SetParent = SetParent
local SetAlpha = SetAlpha
local IsShown = IsShown
local SetWidth = SetWidth
local SetTexCoord = SetTexCoord
local Show = Show

function Overabsorb:OnEnable()
    local function OnFrameSetup(frame)
        local absorbOverlay = frame.totalAbsorbOverlay
        local healthBar = frame.healthBar
        absorbOverlay:SetParent(healthBar)
        absorbOverlay:ClearAllPoints()
        local absorbGlow = frame.overAbsorbGlow
        absorbGlow:ClearAllPoints()
        absorbGlow:SetPoint("TOPLEFT", absorbOverlay, "TOPLEFT", -5, 0)
        absorbGlow:SetPoint("BOTTOMLEFT", absorbOverlay, "BOTTOMLEFT", -5, 0)
        absorbGlow:SetAlpha(1)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", OnFrameSetup)
    local function UpdateHealPredictionCallback(frame)
        local absorbBar = frame.totalAbsorb
        local absorbOverlay = frame.totalAbsorbOverlay
        local healthBar = frame.healthBar
        local _, maxHealth = healthBar:GetMinMaxValues()
        if ( maxHealth <= 0 ) then return end
        local totalAbsorb = UnitGetTotalAbsorbs(frame.displayedUnit or "") or 0
        if( totalAbsorb > maxHealth ) then
            totalAbsorb = maxHealth
        end
        if( totalAbsorb > 0 ) then	
            if ( absorbBar:IsShown() ) then		
                  absorbOverlay:SetPoint("TOPRIGHT", absorbBar, "TOPRIGHT", 0, 0)
                  absorbOverlay:SetPoint("BOTTOMRIGHT", absorbBar, "BOTTOMRIGHT", 0, 0)
            else
                absorbOverlay:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT", 0, 0)
                absorbOverlay:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)  			
            end
            local width, height = healthBar:GetSize()			
            local barSize = totalAbsorb / maxHealth * width
            absorbOverlay:SetWidth( barSize )
            absorbOverlay:SetTexCoord(0, barSize / absorbOverlay.tileSize, 0, height / absorbOverlay.tileSize)
            absorbOverlay:Show()
        end	
    end
    self:HookFuncFiltered("CompactUnitFrame_UpdateHealPrediction", UpdateHealPredictionCallback)
    RaidFrameSettings:IterateRoster(function(frame)
        OnFrameSetup(frame)
        UpdateHealPredictionCallback(frame)
    end)
end

function Overabsorb:OnDisable()
    self:DisableHooks()
    local restoreOverabsorbs = function(frame)
        frame.overAbsorbGlow:SetPoint("BOTTOMLEFT", frame.healthBar, "BOTTOMRIGHT", -7, 0);
        frame.overAbsorbGlow:SetPoint("TOPLEFT", frame.healthBar, "TOPRIGHT", -7, 0);
    end
    RaidFrameSettings:IterateRoster(restoreOverabsorbs)
end