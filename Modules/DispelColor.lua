--[[
    Created by Slothpala
--]]
local DispelColor = RaidFrameSettings:NewModule("DispelColor")
local LGF = LibStub("LibGetFrame-1.0")
--lua speed reference
local ipairs = ipairs
local pairs = pairs
--wow api speed reference
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsTapDenied = UnitIsTapDenied
local UnitInVehicle = UnitInVehicle
local UnitDebuff = UnitDebuff
--locals
local eligibleUnit = {}
eligibleUnit["player"] = true
for i=1,4 do eligibleUnit["party"..i] = true end
for i=1,40 do eligibleUnit["raid"..i] = true end
local DebuffState = {}
local debuffTypeColor = {}
local updateColor --function defined in OnEnable()

local function isValidCompactFrame(frame) 
    if frame:IsForbidden() then return end
    local frameName = frame:GetName()
    if frameName and frameName:match("Compact") and UnitIsPlayer(frame.unit) then 
        return true
    end
    return false
end

local function setStatusBarToDebuffColor(unit, debuffType)
    local frame = LGF.GetUnitFrame(unit)
    if frame and isValidCompactFrame(frame) then
        frame.healthBar:SetStatusBarColor(debuffTypeColor[debuffType].r,debuffTypeColor[debuffType].g,debuffTypeColor[debuffType].b)
    end
end

local function restoreStatusBarColor(unit)
    local frame = LGF.GetUnitFrame(unit)
    if frame and isValidCompactFrame(frame) then
        updateColor(frame)
    end
end

local function checkDebuffs(unit)
    local index = 0
    local debuff = nil
    while(true) do
        index = index +1
        local _, _, _, debuffType = UnitDebuff(unit, index, "HARMFUL|RAID")
        if not debuffType then 
            break 
        end
        debuff = debuffType
        break
    end
    if debuff then 
        DebuffState[unit] = true
        setStatusBarToDebuffColor(unit, debuff)
    else
        DebuffState[unit] = false
        restoreStatusBarColor(unit)
    end
end

function DispelColor:OnUnitAura(_,unit)
    if eligibleUnit[unit] then
        checkDebuffs(unit)
    end
end

function DispelColor:OnEnable()
    self:RegisterEvent("UNIT_AURA","OnUnitAura")
    --custom debuff color settings
    debuffTypeColor.Curse   = RaidFrameSettings.db.profile.MinorModules.DispelColor.curse
    debuffTypeColor.Disease = RaidFrameSettings.db.profile.MinorModules.DispelColor.disease
    debuffTypeColor.Magic   = RaidFrameSettings.db.profile.MinorModules.DispelColor.magic
    debuffTypeColor.Poison  = RaidFrameSettings.db.profile.MinorModules.DispelColor.poison
    if RaidFrameSettings.db.profile.Module.HealthBars then
        --static color
        if RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 3 then 
            local statusBarColor = RaidFrameSettings.db.profile.HealthBars.Colors.statusbar
            updateColor = function(frame)
                frame.healthBar:SetStatusBarColor(statusBarColor.r,statusBarColor.g,statusBarColor.b)
            end
        --green color
        elseif RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 2 then 
            updateColor = function(frame)
                frame.healthBar:SetStatusBarColor(0,1,0)
            end
        --class color
        elseif RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 1 then 
            updateColor = function(frame)
                local _, englishClass = UnitClass(frame.unit) 
                local r,g,b = GetClassColor(englishClass)
                frame.healthBar:SetStatusBarColor(r,g,b)
            end
        end
    else
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            updateColor = function(frame)
                frame.healthBar:SetStatusBarColor(0,1,0)
            end
        else
            updateColor = function(frame)
                local _, englishClass = UnitClass(frame.unit)
                local r,g,b = GetClassColor(englishClass)
                frame.healthBar:SetStatusBarColor(r,g,b)
            end
        end
    end
    local UpdateHealthColor
    if RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 3 then 
        UpdateHealthColor = function(frame)
            updateColor(frame)
            if DebuffState[frame.unit] then
                checkDebuffs(frame.unit)
            end
        end
    else
        UpdateHealthColor = function(frame)
            if DebuffState[frame.unit] then
                checkDebuffs(frame.unit)
            end
        end
    end
    RaidFrameSettings:RegisterOnUpdateHealthColor(UpdateHealthColor)
end

function DispelColor:OnDisable()
    self:UnregisterEvent("UNIT_AURA")
end

