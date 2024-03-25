--[[
    Created by Slothpala 
    The aura indicator position and the aura timers are greatly inspired by a pull request from: https://github.com/excorp
--]]
local _, addonTable = ...
local isVanilla, isWrath, isClassic, isRetail = addonTable.isVanilla, addonTable.isWrath, addonTable.isClassic, addonTable.isRetail
local addon = addonTable.RaidFrameSettings
local Debuffs = addon:NewModule("Debuffs")
Mixin(Debuffs, addonTable.hooks)
local CDT = addonTable.cooldownText
local Media = LibStub("LibSharedMedia-3.0")

--Debuffframe size
--They don't exist in classic
local NATIVE_UNIT_FRAME_HEIGHT = 36
local NATIVE_UNIT_FRAME_WIDTH = 72 
--WoW Api
local UnitDebuff = UnitDebuff
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
local IsForbidden = IsForbidden
--Lua
local next = next
local select = select

local frame_registry = {}

function Debuffs:OnEnable()
    local frameOpt = CopyTable(addon.db.profile.Debuffs.DebuffFramesDisplay)
    frameOpt.framestrata = addon:ConvertDbNumberToFrameStrata(frameOpt.framestrata)
    --Timer
    local durationOpt = CopyTable(addon.db.profile.Debuffs.DurationDisplay) --copy is important so that we dont overwrite the db value when fetching the real values
    durationOpt.font = Media:Fetch("font", durationOpt.font)
    durationOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(durationOpt.outlinemode)
    durationOpt.point = addon:ConvertDbNumberToPosition(durationOpt.point)
    durationOpt.relativePoint = addon:ConvertDbNumberToPosition(durationOpt.relativePoint)
    --Stack
    local stackOpt = CopyTable(addon.db.profile.Debuffs.StacksDisplay)
    stackOpt.font = Media:Fetch("font", stackOpt.font)
    stackOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(stackOpt.outlinemode)
    stackOpt.point = addon:ConvertDbNumberToPosition(stackOpt.point)
    stackOpt.relativePoint = addon:ConvertDbNumberToPosition(stackOpt.relativePoint)
    --user placed 
    local userPlaced = {} --i will bring this at a later date for Debuffs including position and size
    local userPlacedIdx = 1
    local maxUserPlaced = 0
    --Debuffframe size
    local width  = frameOpt.width
    local height = frameOpt.height
    local boss_width  = width * frameOpt.increase
    local boss_height = height * frameOpt.increase
    local resizeDebuffFrame
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
        resizeDebuffFrame = function(debuffFrame)
            debuffFrame:SetSize(width, height)
            debuffFrame.icon:SetTexCoord(left,right,top,bottom)
        end
    else
        resizeDebuffFrame = function(debuffFrame)
            debuffFrame:SetSize(width, height)
        end
    end
    --Debuffframe position
    local point = addon:ConvertDbNumberToPosition(frameOpt.point)
    local relativePoint = addon:ConvertDbNumberToPosition(frameOpt.relativePoint)
    local followPoint, followRelativePoint, followOffsetX, followOffsetY = addon:GetAuraGrowthOrientationPoints(frameOpt.orientation, frameOpt.gap)

    --[[
    local function updateAnchors(frame)
        local anchorSet, prevFrame
        for i=1, #frame.debuffFrames do
            local debuffFrame = frame.debuffFrames[i]
            local id = debuffFrame:GetID()
            local spellId = id and not debuffFrame.isBossBuff and select(10, UnitDebuff(frame.unit, id)) or id and debuffFrame.isBossBuff and select(10, UnitBuff(frame.unit, id)) or nil
            local place = spellId and userPlaced[spellId] or false
            if not anchorSet and not place then
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, followOffsetX, followOffsetY)
            end
            if place then
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(place.point, frame, place.relativePoint, place.xOffset, place.yOffset)
            end
            if not hide and not place then
                prevFrame = debuffFrame
            end
        end
    end
    ]]

    local function onFrameSetup(frame)
        if frame.maxDebuffs == 0 then
            return
        end

        if not frame_registry[frame] then
            frame_registry[frame] = {
                maxDebuffs        = frameOpt.maxdebuffs,
                placedAuraStart   = 0,
                dirty             = true,
                extraDebuffFrames = {},
            }
        end

        if frame_registry[frame].dirty then
            frame_registry[frame].dirty = false
            local placedAuraStart = frame.maxDebuffs + 1
            for i = frame.maxDebuffs + 1, frame_registry[frame].maxDebuffs do
                local debuffFrame = frame_registry[frame].extraDebuffFrames[i]
                if not debuffFrame then
                    debuffFrame = CreateFrame("Button", nil, frame, "CompactDebuffTemplate")
                    debuffFrame:Hide()
                    debuffFrame.baseSize = width
                    debuffFrame.maxHeight = width
                    debuffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraDebuffFrames[i] = debuffFrame
                end
                debuffFrame.icon:SetTexCoord(0, 1, 0, 1)
                debuffFrame.border:SetTexture("Interface/Buttons/UI-Debuff-Overlays")
                debuffFrame.border:SetTexCoord(0.296875,0.5703125,0,0.515625)
                if not isWrath then
                    debuffFrame.border:SetTextureSliceMargins(0,0,0,0)
                end
                placedAuraStart = i + 1
            end
            frame_registry[frame].placedAuraStart = placedAuraStart

            for _, place in pairs(userPlaced) do
                local idx = placedAuraStart + place.idx - 1
                local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
                if not debuffFrame then
                    debuffFrame = CreateFrame("Button", nil, frame, "CompactDebuffTemplate")
                    debuffFrame:Hide()
                    debuffFrame.baseSize = width
                    debuffFrame.maxHeight = width
                    debuffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraDebuffFrames[idx] = debuffFrame
                end
                debuffFrame.icon:SetTexCoord(0, 1, 0, 1)
                debuffFrame.border:SetTexture("Interface/Buttons/UI-Debuff-Overlays")
                debuffFrame.border:SetTexCoord(0.296875,0.5703125,0,0.515625)
                if not isWrath then
                    debuffFrame.border:SetTextureSliceMargins(0,0,0,0)
                end
            end

            for i = 1, frame_registry[frame].maxDebuffs + maxUserPlaced do
                local debuffFrame = frame_registry[frame].extraDebuffFrames[i]
                if frameOpt.framestrata ~= "Inherited" then
                    debuffFrame:SetFrameStrata(frameOpt.framestrata)
                end
                --Timer Settings
                local cooldown = debuffFrame.cooldown
                if frameOpt.timerText then
                    local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
                    cooldownText:ClearAllPoints()
                    cooldownText:SetPoint(durationOpt.point, debuffFrame, durationOpt.relativePoint, durationOpt.xOffsetFont, durationOpt.yOffsetFont)
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
                local stackText = debuffFrame.count
                stackText:ClearAllPoints()
                stackText:SetPoint(stackOpt.point, debuffFrame, stackOpt.relativePoint, stackOpt.xOffsetFont, stackOpt.yOffsetFont)
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
        for i = 1, frame_registry[frame].maxDebuffs do
            local debuffFrame = frame_registry[frame].extraDebuffFrames[i]
            if not anchorSet then
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, followOffsetX, followOffsetY)
            end
            prevFrame = debuffFrame
            resizeDebuffFrame(debuffFrame)
        end
        for _, place in pairs(userPlaced) do
            local idx = frame_registry[frame].placedAuraStart + place.idx - 1
            local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
            local parentIdx = place.toSpellId and userPlaced[place.toSpellId] and (frame_registry[frame].placedAuraStart + userPlaced[place.toSpellId].idx - 1)
            local parent = parentIdx and frame_registry[frame].extraDebuffFrames[parentIdx] or frame
            debuffFrame:ClearAllPoints()
            debuffFrame:SetPoint(place.point, parent, place.relativePoint, place.xOffset, place.yOffset)
            resizeDebuffFrame(debuffFrame)
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", onFrameSetup)

    local onSetDebuff = function(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
        if debuffFrame:IsForbidden() or not debuffFrame:IsVisible() then --not sure if this is still neede but when i created it at the start if dragonflight it was
            return
        end
        local cooldown = debuffFrame.cooldown
        if not cooldown._rfs_cd_text then
            return
        end
        CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId
        if isBossBuff then
            name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitBuff(unit, index, filter)
        else
            name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(unit, index, filter)
        end

        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)
        if isBossAura then
            debuffFrame:SetSize(boss_width, boss_height)
        else
            debuffFrame:SetSize(width, height)
        end
    end
    -- self:HookFunc("CompactUnitFrame_UtilSetDebuff", onSetDebuff)

    local onUpdateDebuffs = function(frame)
        if not frame_registry[frame] or frame:IsForbidden() or not frame:IsVisible() then
            return
        end
        for _, v in pairs(frame.debuffFrames) do
            v:Hide()
        end

        -- set placed aura / other aura
        local index = 1
        local frameNum = 1
        local filter = nil
        while true do
            local debuffName, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(frame.displayedUnit, index, filter)
            if not debuffName then
                break
            end
            local isBossAura = CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false)
            local isBossBuff = CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true)
            if CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) then
                if userPlaced[spellId] then
                    local idx = frame_registry[frame].placedAuraStart + userPlaced[spellId].idx - 1
                    local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
                    onSetDebuff(debuffFrame, frame.displayedUnit, index, filter, isBossAura, isBossBuff)
                elseif frameNum <= frame_registry[frame].maxDebuffs then
                    local debuffFrame = frame_registry[frame].extraDebuffFrames[frameNum]
                    onSetDebuff(debuffFrame, frame.displayedUnit, index, filter, isBossAura, isBossBuff)
                    frameNum = frameNum + 1
                end
            end
            index = index + 1
        end

        -- hide left aura frames
        for i = 1, maxUserPlaced do
            local idx = frame_registry[frame].placedAuraStart + i - 1
            local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
            index = debuffFrame:GetID()
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter)
            if not debuffName then
                debuffFrame:Hide()
                CooldownFrame_Clear(debuffFrame.cooldown)
            end
        end
        for i = frameNum, frame_registry[frame].maxDebuffs do
            local debuffFrame = frame_registry[frame].extraDebuffFrames[i]
            debuffFrame:Hide()
            CooldownFrame_Clear(debuffFrame.cooldown)
        end
    end
    self:HookFunc("CompactUnitFrame_UpdateDebuffs", onUpdateDebuffs)

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
function Debuffs:OnDisable()
    self:DisableHooks()
    local restoreDebuffFrames = function(frame)
        -- The add-on will only restore frames that it has modified.
        if not frame_registry[frame] then
            return
        end
        for _, extraDebuffFrame in pairs(frame_registry[frame].extraDebuffFrames) do
            extraDebuffFrame:Hide()
        end
        if frame.unit and frame.unitExists and frame:IsShown() and not frame:IsForbidden() then
            CompactUnitFrame_UpdateAuras(frame)
        end
    end
    addon:IterateRoster(restoreDebuffFrames)
end
