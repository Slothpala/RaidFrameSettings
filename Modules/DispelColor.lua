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
local GetStatusBarColor = GetStatusBarColor
local SetStatusBarColor = SetStatusBarColor
--locals
local Roster = {}
Roster["player"] = {}
Roster["player"].blockColorUpdate = false
Roster["player"].auras = {}
Roster["player"].auras.debuffs = {}
for i=1,4 do 
    Roster["party"..i] = {}
    Roster["party"..i].blockColorUpdate = false
    Roster["party"..i].auras = {}
    Roster["party"..i].auras.debuffs = {}
end
for i=1,40 do 
    Roster["raid"..i] = {}
    Roster["raid"..i].blockColorUpdate = false
    Roster["raid"..i].auras = {}
    Roster["raid"..i].auras.debuffs = {}
end
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
        local r,g,b = debuffTypeColor[debuffType].r,debuffTypeColor[debuffType].g,debuffTypeColor[debuffType].b
        local oldR, oldG, oldB = frame.healthBar:GetStatusBarColor()
        if ( r ~= oldR or g ~= oldG or b ~= oldB ) then
            Roster[unit].blockColorUpdate = true
            frame.healthBar:SetStatusBarColor(r,g,b)
        end
    end
end

local function restoreStatusBarColor(unit)
    local frame = LGF.GetUnitFrame(unit)
    if frame and isValidCompactFrame(frame) then
        Roster[unit].blockColorUpdate = false
        updateColor(frame)
    end
end

local function iterateDebuffs(unit)
    for _,debuffType in pairs(Roster[unit].auras.debuffs) do
        if debuffType then
            setStatusBarToDebuffColor(unit, debuffType)
            return
        end
    end
    restoreStatusBarColor(unit)
end

local function processAurasFull(unit)
    Roster[unit].auras.debuffs = {}
    local function HandleAura(aura)
        Roster[unit].auras.debuffs[aura.auraInstanceID] = aura.dispelName   
    end
    AuraUtil.ForEachAura(unit, "HARMFUL|RAID", nil, HandleAura, true)  
    iterateDebuffs(unit)  
end

local function processAurasIncremental(unit, unitAuraUpdateInfo)
    if unitAuraUpdateInfo.addedAuras ~= nil then
        for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
            if aura.isRaid and aura.isHarmful then
                Roster[unit].auras.debuffs[aura.auraInstanceID] = aura.dispelName        
            end
        end
    end
    if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
            if Roster[unit].auras.debuffs[auraInstanceID] then
                Roster[unit].auras.debuffs[auraInstanceID] = nil
            end
        end
    end
    iterateDebuffs(unit)
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
            if not Roster[frame.unit].blockColorUpdate then
                updateColor(frame)
            else
                iterateDebuffs(frame.unit)
            end
        end
    else
        UpdateHealthColor = function(frame)
            if Roster[frame.unit].blockColorUpdate then
                iterateDebuffs(frame.unit)
            end
        end
    end
    RaidFrameSettings:RegisterOnUpdateHealthColor(UpdateHealthColor)
end

function DispelColor:OnDisable()
    self:UnregisterEvent("UNIT_AURA")
end

