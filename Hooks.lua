--[[
    Created by Slothpala 
    Modules will register callback functions(frame) for a given hook. The first time that a module registers a callback will start the hook.
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
--lua speed reference
local _G = _G
local pairs = pairs
local select = select
--wow api speed reference
local match = match
local IsForbidden = IsForbidden
local UnitIsPlayer = UnitIsPlayer
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsTapDenied = UnitIsTapDenied
local GetName = GetName
local IsInRaid = IsInRaid
local GetParent = GetParent

local function isValidCompactFrame(frame) 
    if frame:IsForbidden() then return end
    local frameName = frame:GetName()
    if frameName and frameName:match("Compact") then 
        return true
    end
    return false
end
---------
--Hooks--
---------
local hooked = {}

--DefaultCompactUnitFrameSetup 
local OnFrameSetup_Callbacks = {}
function RaidFrameSettings:RegisterOnFrameSetup(callback)
    OnFrameSetup_Callbacks[#OnFrameSetup_Callbacks+1] = callback
    if not hooked["DefaultCompactUnitFrameSetup"] then
        hooksecurefunc("DefaultCompactUnitFrameSetup", function(frame) 
            if isValidCompactFrame(frame) then 
                for i = 1,#OnFrameSetup_Callbacks do 
                    OnFrameSetup_Callbacks[i](frame)
                end
            end
        end)
        hooked["DefaultCompactUnitFrameSetup"] = true
    end
end

--DefaultCompactMiniFrameSetup 
local OnMiniFrameSetup_Callbacks = {}
function RaidFrameSettings:RegisterOnMiniFrameSetup(callback)
    OnMiniFrameSetup_Callbacks[#OnMiniFrameSetup_Callbacks+1] = callback
    if not hooked["DefaultCompactMiniFrameSetup"] then
        hooksecurefunc("DefaultCompactMiniFrameSetup", function(frame)
            local name = frame.unit
            if not name or not name:match("pet") then 
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
            for i = 1,#OnMiniFrameSetup_Callbacks do 
                OnMiniFrameSetup_Callbacks[i](frame)
            end

        end)
        hooked["DefaultCompactMiniFrameSetup"] = true
    end
end

--CompactUnitFrame_UpdateAll 
local OnUpdateAll_Callbacks = {}
function RaidFrameSettings:RegisterOnUpdateAll(callback)
    OnUpdateAll_Callbacks[#OnUpdateAll_Callbacks+1] = callback
    if not hooked["CompactUnitFrame_UpdateAll"] then
        hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame) 
            if isValidCompactFrame(frame) then 
                for i = 1,#OnUpdateAll_Callbacks do 
                    OnUpdateAll_Callbacks[i](frame)
                end
            end
        end)
        hooked["CompactUnitFrame_UpdateAll"] = true
    end
end

--CompactUnitFrame_UpdateHealthColor 
local OnUpdateHealthColor_Callback = function() end
function RaidFrameSettings:RegisterOnUpdateHealthColor(callback)
    OnUpdateHealthColor_Callback = callback
    if not hooked["CompactUnitFrame_UpdateHealthColor"] then
        hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame) 
            if isValidCompactFrame(frame) then
                local unitIsConnected = UnitIsConnected(frame.unit)
                local unitIsDead = unitIsConnected and UnitIsDead(frame.unit)
                if not unitIsConnected or unitIsDead then return end
                OnUpdateHealthColor_Callback(frame)
            end 
        end)
        hooked["CompactUnitFrame_UpdateHealthColor"] = true
    end
end

--CompactUnitFrame_UpdateName 
local OnUpdateName_Callback = function() end
function RaidFrameSettings:RegisterOnUpdateName(callback)
    OnUpdateName_Callback = callback
    if not hooked["CompactUnitFrame_UpdateName"] then
        hooksecurefunc("CompactUnitFrame_UpdateName", function(frame) 
            if isValidCompactFrame(frame) then 
                OnUpdateName_Callback(frame)
            end
        end)
        hooked["CompactUnitFrame_UpdateName"] = true
    end
end

--CompactUnitFrame_UpdateHealPrediction 
local UpdateHealPrediction_Callback = function() end
function RaidFrameSettings:RegisterUpdateHealPrediction(callback)
    UpdateHealPrediction_Callback = callback
    if not hooked["CompactUnitFrame_UpdateHealPrediction"] then
        hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", function(frame) 
            if isValidCompactFrame(frame) then 
                UpdateHealPrediction_Callback(frame)
            end
        end)
        hooked["CompactUnitFrame_UpdateHealPrediction"] = true
    end
end

--CompactUnitFrame_UpdateInRange 
local UpdateInRange_Callback = function() end
function RaidFrameSettings:RegisterUpdateInRange(callback)
    UpdateInRange_Callback = callback
    if not hooked["CompactUnitFrame_UpdateInRange"] then
        hooksecurefunc("CompactUnitFrame_UpdateInRange", function(frame) 
            if isValidCompactFrame(frame) then 
                UpdateInRange_Callback(frame)
            end
        end)
        hooked["CompactUnitFrame_UpdateInRange"] = true
    end
end

--role icon and debuff frame are only used for update all, hooks are done in the module files
local UpdateRoleIcon_Callback = function() end
function RaidFrameSettings:RegisterUpdateRoleIcon(callback)
    UpdateRoleIcon_Callback = callback
end

local UpdateDebuffFrame_Callback = function() end
function RaidFrameSettings:RegisterUpdateDebuffFrame(callback)
    UpdateDebuffFrame_Callback = callback
end

function RaidFrameSettings:WipeAllCallbacks()
    OnFrameSetup_Callbacks = {}
    OnMiniFrameSetup_Callbacks = {}
    OnUpdateAll_Callbacks = {}
    OnUpdateHealthColor_Callback = function() end
    OnUpdateName_Callback = function() end
    UpdateInRange_Callback = function() end
    UpdateHealPrediction_Callback = function() end
    UpdateRoleIcon_Callback = function() end
    UpdateDebuffFrame_Callback = function() end
end

function RaidFrameSettings:IterateRoster(callback)
    local showSeparateGroups = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups()
    if IsInRaid() and not select(1,IsActiveBattlefieldArena()) then --IsInRaid() returns true in arena even though we need party frame names
        if showSeparateGroups then
            for i=1, 8 do
                for j=1, 5 do
                    local frame = _G["CompactRaidGroup" ..i.. "Member" .. j .. "HealthBar"]
                    if frame then
                        frame = frame:GetParent()
                        callback(frame)
                    end
                end
            end
        else
            for i=1, 40 do
                local frame = _G["CompactRaidFrame" ..i .. "HealthBar"]
                if frame then
                    frame = frame:GetParent()
                    callback(frame)
                end
            end
        end
    else
        for i=1, 5 do
            local frame = _G["CompactPartyFrameMember" ..i .. "HealthBar"]
            if frame then
                frame = frame:GetParent()
                callback(frame)
            end
            frame = _G["CompactArenaFrameMember" ..i .. "HealthBar"]
            if frame then
                frame = frame:GetParent()
                callback(frame)
            end
        end
    end
end

function RaidFrameSettings:UpdateAllFrames()
    local function CallbackPool(frame)
        if not frame or not frame.unit then return end
        for i=1,#OnFrameSetup_Callbacks do 
            OnFrameSetup_Callbacks[i](frame)
        end
        for i=1,#OnMiniFrameSetup_Callbacks do 
            OnMiniFrameSetup_Callbacks[i](frame)
        end
        for i=1,#OnUpdateAll_Callbacks do 
            OnUpdateAll_Callbacks[i](frame)
        end
        OnUpdateHealthColor_Callback(frame)
        OnUpdateName_Callback(frame)
        UpdateHealPrediction_Callback(frame)
        UpdateInRange_Callback(frame)
        UpdateRoleIcon_Callback(frame)
        --debuffs
        if frame.debuffFrames then
            for i=1, #frame.debuffFrames do
                local debuffFrame = frame.debuffFrames[i]
                UpdateDebuffFrame_Callback(debuffFrame) 
                if debuffFrame.auraInstanceID then
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, debuffFrame.auraInstanceID)
                    if aura and self.db.profile.Debuffs.Blacklist[tostring(aura.spellId)] then
                        debuffFrame:SetSize(0.1,0.1)
                    end
                end
            end
        end
        --buffs
        if frame.buffFrames then
            for i=1, #frame.buffFrames do
                local buffFrame = frame.buffFrames[i]
                if buffFrame.auraInstanceID then
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, buffFrame.auraInstanceID)
                    if aura and self.db.profile.Buffs.Blacklist[tostring(aura.spellId)] then
                        buffFrame:SetSize(0.1,0.1)
                    end
                end
            end
        end
    end
    self:IterateRoster(CallbackPool)
end