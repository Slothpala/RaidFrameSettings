--[[
    Created by Slothpala
    The aura indicator position and the aura timers are greatly inspired by a pull request from: https://github.com/excorp
--]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
local Buffs = addon:NewModule("Buffs")
Mixin(Buffs, addonTable.hooks)
local CDT = addonTable.cooldownText
local Media = LibStub("LibSharedMedia-3.0")

--[[
    --TODO local references here
]]
--They don't exist in classic
local NATIVE_UNIT_FRAME_HEIGHT = 36
local NATIVE_UNIT_FRAME_WIDTH = 72 
--WoW Api
local UnitBuff = UnitBuff
local SetSize = SetSize
local SetTexCoord = SetTexCoord
local ClearAllPoints = ClearAllPoints
local SetPoint = SetPoint
local Hide = Hide
local SetFont = SetFont
local SetTextColor = SetTextColor
local SetShadowColor = SetShadowColor
local SetShadowOffset = SetShadowOffset
local SetDrawSwipe = SetDrawSwipe
local SetReverse = SetReverse
local SetDrawEdge = SetDrawEdge
--Lua
local next = next
local select = select

local frame_registry = {}


function Buffs:OnEnable()
    local frameOpt = CopyTable(addon.db.profile.Buffs.BuffFramesDisplay)
    frameOpt.framestrata = addon:ConvertDbNumberToFrameStrata(frameOpt.framestrata)
    --Timer
    local durationOpt = CopyTable(addon.db.profile.Buffs.DurationDisplay) --copy is important so that we dont overwrite the db value when fetching the real values
    durationOpt.font = Media:Fetch("font", durationOpt.font)
    durationOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(durationOpt.outlinemode)
    durationOpt.point = addon:ConvertDbNumberToPosition(durationOpt.point)
    durationOpt.relativePoint = addon:ConvertDbNumberToPosition(durationOpt.relativePoint)
    --Stack
    local stackOpt = CopyTable(addon.db.profile.Buffs.StacksDisplay)
    stackOpt.font = Media:Fetch("font", stackOpt.font)
    stackOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(stackOpt.outlinemode)
    stackOpt.point = addon:ConvertDbNumberToPosition(stackOpt.point)
    stackOpt.relativePoint = addon:ConvertDbNumberToPosition(stackOpt.relativePoint)
    --user placed
    local userPlaced = {}
    local userPlacedIdx = 1
    local maxUserPlaced = 0
    for _, auraInfo in pairs(addon.db.profile.Buffs.AuraPosition) do
        userPlaced[auraInfo.spellId] = {
            idx = userPlacedIdx,
            point = addon:ConvertDbNumberToPosition(auraInfo.point),
            relativePoint = addon:ConvertDbNumberToPosition(auraInfo.relativePoint),
            toSpellId = auraInfo.toSpellId,
            xOffset = auraInfo.xOffset,
            yOffset = auraInfo.yOffset,
            setSize = auraInfo.setSize,
            width = auraInfo.width,
            height = auraInfo.height,
        }
        userPlacedIdx = userPlacedIdx + 1
    end
    maxUserPlaced = userPlacedIdx - 1
    --Buff size
    local width  = frameOpt.width
    local height = frameOpt.height
    local resizeBuffFrame
    if frameOpt.cleanIcons then
        local left, right, top, bottom = 0.1, 0.9, 0.1, 0.9
        if height ~= width then
            if height < width then
                local delta = width - height
                local scale_factor = ((( 100 / width )  * delta) / 100) / 2
                top = top + scale_factor
                bottom = bottom - scale_factor
            else
                local delta = height - width 
                local scale_factor = ((( 100 / height )  * delta) / 100) / 2
                left = left + scale_factor
                right = right - scale_factor
            end
        end
        resizeBuffFrame = function(buffFrame)
            buffFrame:SetSize(width, height)
            buffFrame.icon:SetTexCoord(left,right,top,bottom)
        end
    else
        resizeBuffFrame = function(buffFrame)
            buffFrame:SetSize(width, height)
        end
    end
    --Buffframe position
    local point = addon:ConvertDbNumberToPosition(frameOpt.point)
    local relativePoint = addon:ConvertDbNumberToPosition(frameOpt.relativePoint)
    local followPoint, followRelativePoint, followOffsetX, followOffsetY = addon:GetAuraGrowthOrientationPoints(frameOpt.orientation, frameOpt.gap)

    --[[
    local function updateAnchors(frame)
        local anchorSet, prevFrame
        for i=1, #frame.buffFrames do
            local buffFrame = frame.buffFrames[i]
            local id = buffFrame:GetID()
            local spellId = id and select(10, UnitBuff(frame.unit, id)) or nil
            local place = spellId and userPlaced[spellId] or false
            if not anchorSet and not place then
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, followOffsetX, followOffsetY)
            end
            if place then
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(place.point, frame, place.relativePoint, place.xOffset, place.yOffset)
            end
            if not place then
                prevFrame = buffFrame
            end
        end
    end
    ]]

    local function onFrameSetup(frame)
        if frame.maxBuffs == 0 then
            return
        end

        if not frame_registry[frame] then
            frame_registry[frame] = {
                maxBuffs        = frameOpt.maxbuffsAuto and frame.maxBuffs or frameOpt.maxbuffs,
                placedAuraStart = 0,
                dirty           = true,
                extraBuffFrames = {},
            }
        end

        if frame_registry[frame].dirty then
            frame_registry[frame].maxBuffs = frameOpt.maxbuffsAuto and frame.maxBuffs or frameOpt.maxbuffs
            frame_registry[frame].dirty = false

            local placedAuraStart = frame.maxBuffs + 1
            for i = frame.maxBuffs + 1, frame_registry[frame].maxBuffs do
                local buffFrame = frame_registry[frame].extraBuffFrames[i]
                if not buffFrame then
                    buffFrame = CreateFrame("Button", nil, frame, "CompactBuffTemplate")
                    buffFrame:Hide()
                    buffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraBuffFrames[i] = buffFrame
                end
                buffFrame.icon:SetTexCoord(0, 1, 0, 1)
                placedAuraStart = i + 1
            end
            frame_registry[frame].placedAuraStart = placedAuraStart

            for _, place in pairs(userPlaced) do
                local idx = placedAuraStart + place.idx - 1
                local buffFrame = frame_registry[frame].extraBuffFrames[idx]
                if not buffFrame then
                    buffFrame = CreateFrame("Button", nil, frame, "CompactBuffTemplate")
                    buffFrame:Hide()
                    buffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraBuffFrames[idx] = buffFrame
                end
                buffFrame.icon:SetTexCoord(0, 1, 0, 1)
            end

            for i = 1, frame_registry[frame].maxBuffs + maxUserPlaced do
                local buffFrame = frame_registry[frame].extraBuffFrames[i]
                if frameOpt.framestrata ~= "Inherited" then
                    buffFrame:SetFrameStrata(frameOpt.framestrata)
                end
                --Timer Settings
                local cooldown = buffFrame.cooldown
                if frameOpt.timerText then
                    local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
                    cooldownText:ClearAllPoints()
                    cooldownText:SetPoint(durationOpt.point, buffFrame, durationOpt.relativePoint, durationOpt.xOffsetFont, durationOpt.yOffsetFont)
                    cooldownText:SetFont(durationOpt.font, durationOpt.fontSize, durationOpt.outlinemode)
                    cooldownText:SetTextColor(durationOpt.fontColor.r, durationOpt.fontColor.g, durationOpt.fontColor.b)
                    cooldownText:SetShadowColor(durationOpt.shadowColor.r, durationOpt.shadowColor.g, durationOpt.shadowColor.b, durationOpt.shadowColor.a)
                    cooldownText:SetShadowOffset(durationOpt.xOffsetShadow, durationOpt.yOffsetShadow)
                    if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
                        if not cooldown.OmniCC then
                            cooldown.OmniCC = {
                                noCooldownCount = cooldown.noCooldownCount,
                            }
                        end
                        OmniCC.Cooldown.SetNoCooldownCount(cooldown, true)
                    end
                end
                --Stack Settings
                local stackText = buffFrame.count
                stackText:ClearAllPoints()
                stackText:SetPoint(stackOpt.point, buffFrame, stackOpt.relativePoint, stackOpt.xOffsetFont, stackOpt.yOffsetFont)
                stackText:SetFont(stackOpt.font, stackOpt.fontSize, stackOpt.outlinemode)
                stackText:SetTextColor(stackOpt.fontColor.r, stackOpt.fontColor.g, stackOpt.fontColor.b)
                stackText:SetShadowColor(stackOpt.shadowColor.r, stackOpt.shadowColor.g, stackOpt.shadowColor.b, stackOpt.shadowColor.a)
                stackText:SetShadowOffset(stackOpt.xOffsetShadow, stackOpt.yOffsetShadow)
                --Swipe Settings
                cooldown:SetDrawSwipe(frameOpt.swipe)
                cooldown:SetReverse(frameOpt.inverse)
                cooldown:SetDrawEdge(frameOpt.edge)
                stackText:SetParent(cooldown)
            end
        end

        -- set anchor and resize
        local anchorSet, prevFrame
        for i = 1, frame_registry[frame].maxBuffs do
            local buffFrame = frame_registry[frame].extraBuffFrames[i]
            if not anchorSet then
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, followOffsetX, followOffsetY)
            end
            prevFrame = buffFrame
            resizeBuffFrame(buffFrame)
        end
        for _, place in pairs(userPlaced) do
            local idx = frame_registry[frame].placedAuraStart + place.idx - 1
            local buffFrame = frame_registry[frame].extraBuffFrames[idx]
            local parentIdx = place.toSpellId and userPlaced[place.toSpellId] and (frame_registry[frame].placedAuraStart + userPlaced[place.toSpellId].idx - 1)
            local parent = parentIdx and frame_registry[frame].extraBuffFrames[parentIdx] or frame
            buffFrame:ClearAllPoints()
            buffFrame:SetPoint(place.point, parent, place.relativePoint, place.xOffset, place.yOffset)
            resizeBuffFrame(buffFrame)
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", onFrameSetup)

    
    local onSetBuff = function(buffFrame, unit, index, filter)
        if buffFrame:IsForbidden() or not buffFrame:IsVisible() then --not sure if this is still neede but when i created it at the start if dragonflight it was
            return
        end
        local cooldown = buffFrame.cooldown
        if not cooldown._rfs_cd_text then
            return
        end
        CompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter)
        if GetClassicExpansionLevel() < LE_EXPANSION_BURNING_CRUSADE then
            CompactUnitFrame_UpdateCooldownFrame(buffFrame, expirationTime, duration, false)
        end
        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)

        if userPlaced[spellId] and userPlaced[spellId].setSize then
            local placed = userPlaced[spellId]
            buffFrame:SetSize(placed.width, placed.height)
        else
            buffFrame:SetSize(width, height)
        end
    end
    -- self:HookFunc("CompactUnitFrame_UtilSetBuff", onSetBuff)

    local onUpdateBuffs = function(frame)
        if not frame_registry[frame] or frame:IsForbidden() or not frame:IsVisible() then
            return
        end
        for _, v in pairs(frame.buffFrames) do
            v:Hide()
        end

        -- set placed aura / other aura
        local index = 1
        local frameNum = 1
        local filter = nil
        while true do
            local buffName, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(frame.displayedUnit, index, filter)
            if not buffName then
                break
            end
            if CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) then
                if userPlaced[spellId] then
                    local idx = frame_registry[frame].placedAuraStart + userPlaced[spellId].idx - 1
                    local buffFrame = frame_registry[frame].extraBuffFrames[idx]
                    onSetBuff(buffFrame, frame.displayedUnit, index, filter)
                elseif frameNum <= frame_registry[frame].maxBuffs then
                    local buffFrame = frame_registry[frame].extraBuffFrames[frameNum]
                    onSetBuff(buffFrame, frame.displayedUnit, index, filter)
                    frameNum = frameNum + 1
                end
            end
            index = index + 1
        end

        -- hide left aura frames
        for i = 1, maxUserPlaced do
            local idx = frame_registry[frame].placedAuraStart + i - 1
            local buffFrame = frame_registry[frame].extraBuffFrames[idx]
            index = buffFrame:GetID()
            local buffName = UnitBuff(frame.displayedUnit, index, filter)
            if not buffName then
                buffFrame:Hide()
                CooldownFrame_Clear(buffFrame.cooldown)
            end
        end
        for i = frameNum, math.max(frame_registry[frame].maxBuffs, frame.maxBuffs) do
            local buffFrame = frame_registry[frame].extraBuffFrames[i]
            buffFrame:Hide()
            CooldownFrame_Clear(buffFrame.cooldown)
        end
    end
    self:HookFunc("CompactUnitFrame_UpdateBuffs", onUpdateBuffs)

    for _, v in pairs(frame_registry) do
        v.dirty = true
    end
    addon:IterateRoster(function(frame)
        onFrameSetup(frame)
        if frame.unit then
            if frame.unitExists and frame:IsShown() and not frame:IsForbidden() then
                CompactUnitFrame_UpdateAuras(frame)
            end
        end
    end)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Buffs:OnDisable()
    self:DisableHooks()
    local restoreBuffFrames = function(frame)
        -- The add-on will only restore frames that it has modified.
        if not frame_registry[frame] then
            return
        end
        for _, extraBuffFrame in pairs(frame_registry[frame].extraBuffFrames) do
            extraBuffFrame:Hide()
        end
        if frame.unit and frame.unitExists and frame:IsShown() and not frame:IsForbidden() then
            CompactUnitFrame_UpdateAuras(frame)
        end
    end
    addon:IterateRoster(restoreBuffFrames)
end