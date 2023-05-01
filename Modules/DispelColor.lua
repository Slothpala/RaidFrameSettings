--[[
    Created by Slothpala
--]]
--lua speed reference
local ipairs = ipairs
local pairs = pairs
--wow api speed reference
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsTapDenied = UnitIsTapDenied
local UnitInVehicle = UnitInVehicle
--
local DispelColor = RaidFrameSettings:NewModule("DispelColor")
local Roster = {}
--[[
    Roster = {
        unit = {
            frame = frame,
            debuffs = {
                aura.auraInstanceID = aura.dispelName,
                aura.auraInstanceID_N = aura.dispelName_N,
                ...
            },
        },
    }
--]]
local debuffTypeColor = {}

local restoreStatusBarColor --function defined in OnEnable()

local function setStatusBarToDebuffColor(unit, debuffType)
    if UnitIsTapDenied(unit) or UnitInVehicle(unit) then 
        return
    end
    Roster[unit].frame.healthBar:SetStatusBarColor(debuffTypeColor[debuffType].r,debuffTypeColor[debuffType].g,debuffTypeColor[debuffType].b)
end

local function checkDebuffs(unit)
    for _,debuffType in pairs(Roster[unit].debuffs) do
        if debuffType then
            setStatusBarToDebuffColor(unit, debuffType)
            return
        end
    end
    Roster[unit].debuffs = {}
    restoreStatusBarColor(unit)
end

local function processAurasFull(unit)
    Roster[unit].debuffs = {}
    local function HandleAura(aura)
        Roster[unit].debuffs[aura.auraInstanceID] = aura.dispelName
        setStatusBarToDebuffColor(unit, aura.dispelName)   
    end
    AuraUtil.ForEachAura(unit, "HARMFUL|RAID", nil, HandleAura, true)    
end

local function processAurasIncremental(unit, unitAuraUpdateInfo)
    if unitAuraUpdateInfo.addedAuras ~= nil then
        for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
            if aura.isRaid and aura.isHarmful then
                Roster[unit].debuffs[aura.auraInstanceID] = aura.dispelName          
            end
        end
    end
    if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
            if Roster[unit].debuffs[auraInstanceID] then
                Roster[unit].debuffs[auraInstanceID] = nil
            end
        end
    end
    checkDebuffs(unit)
end

function DispelColor:OnUnitAura(_,unit,unitAuraUpdateInfo)
    if not Roster[unit] then
        return
    end
    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
        processAurasFull(unit)
        return
    else
        processAurasIncremental(unit, unitAuraUpdateInfo)
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
            restoreStatusBarColor = function(unit)
                Roster[unit].frame.healthBar:SetStatusBarColor(statusBarColor.r,statusBarColor.g,statusBarColor.b)
            end
            local function UpdateHealthColor(frame)
                if Roster[frame.unit] then
                    checkDebuffs(frame.unit)
                else
                    frame.healthBar:SetStatusBarColor(statusBarColor.r,statusBarColor.g,statusBarColor.b) 
                end
            end
            RaidFrameSettings:RegisterOnUpdateHealthColor(UpdateHealthColor)
        --green color
        elseif 
            RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 2 then 
                restoreStatusBarColor = function(unit)
                    Roster[unit].frame.healthBar:SetStatusBarColor(0,1,0)
                end
        --class color
        elseif 
            RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 1 then 
                restoreStatusBarColor = function(unit)
                    local _, englishClass = UnitClass(unit)
                    local r,g,b = GetClassColor(englishClass)
                    Roster[unit].frame.healthBar:SetStatusBarColor(r,g,b)
                end
        end
    else
        if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
            restoreStatusBarColor = function(unit)
                Roster[unit].frame.healthBar:SetStatusBarColor(0,1,0)
            end
        else
            restoreStatusBarColor = function(unit)
                local _, englishClass = UnitClass(unit)
                local r,g,b = GetClassColor(englishClass)
                Roster[unit].frame.healthBar:SetStatusBarColor(r,g,b)
            end
        end
    end
    --RaidFrameSettings:RegisterOnUpdateHealthColor(UpdateHealthColorCallback)
    --LGF Callbacks
    --added
    local function OnFrameUnitAdded(frame, unit)
        Roster[unit] = {}
        Roster[unit].frame = frame
        Roster[unit].debuffs = {}
        processAurasFull(unit)
        checkDebuffs(unit)
    end
    RaidFrameSettings:RegisterOnFrameUnitAdded(OnFrameUnitAdded)
    --update
    local function OnFrameUnitUpdate(frame, unit)
        Roster[unit] = {}
        Roster[unit].frame = frame
        Roster[unit].debuffs = {}
        processAurasFull(unit)
        checkDebuffs(unit)
    end
    RaidFrameSettings:RegisterOnFrameUnitUpdate(OnFrameUnitUpdate)
    --removed
    local function OnFrameUnitRemoved(unit)
        Roster[unit] = nil
    end
    RaidFrameSettings:RegisterOnFrameUnitRemoved(OnFrameUnitRemoved)
end

function DispelColor:OnDisable()
    self:UnregisterEvent("UNIT_AURA")
end

