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
--WoW Api
local GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
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
    --blacklist
    local blacklist = {}
    for spellId, value in pairs(addon.db.profile.Buffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end
    --user placed
    local userPlaced = {}
    local userPlacedIdx = 1
    local maxUserPlaced = 0
    for _, auraInfo in pairs(addon.db.profile.Buffs.AuraPosition) do
        userPlaced[auraInfo.spellId] = {
            idx = userPlacedIdx,
            point = addon:ConvertDbNumberToPosition(auraInfo.point),
            relativePoint = addon:ConvertDbNumberToPosition(auraInfo.relativePoint),
            xOffset = auraInfo.xOffset,
            yOffset = auraInfo.yOffset,
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
    local followPoint, followRelativePoint = addon:GetAuraGrowthOrientationPoints(frameOpt.orientation)


    local onSetBuff = function(buffFrame, aura)
        if buffFrame:IsForbidden() or not buffFrame:IsVisible() then --not sure if this is still neede but when i created it at the start if dragonflight it was
            return
        end
        -- If buffFrame.cooldown is not present, the frame has not been modified by the addon.
        local cooldown = buffFrame.cooldown
        if not cooldown.count then
            return
        end
        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)
        if buffFrame.count:IsShown() then
            cooldown.count:SetText(buffFrame.count:GetText())
            cooldown.count:Show()
            buffFrame.count:Hide()
        else
            cooldown.count:Hide()
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", onSetBuff)

    local onHideAllBuffs = function(frame)
        if not frame_registry[frame] or frame:IsForbidden() or not frame:IsVisible() then
            return
        end

        -- set placed aura / other aura
        local frameNum = 1
        frame.buffs:Iterate(function(auraInstanceID, aura)
            if userPlaced[aura.spellId] then
                local idx = frame_registry[frame].placedAuraStart + userPlaced[aura.spellId].idx - 1
                local buffFrame = frame_registry[frame].extraBuffFrames[idx]
                CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                return false
            end

            if blacklist[aura.spellId] then
                return false
            end

            if frameNum <= frame_registry[frame].maxBuffs then
                local buffFrame = frame.buffFrames[frameNum] or frame_registry[frame].extraBuffFrames[frameNum]
                CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                frameNum = frameNum + 1
            end
            return false
        end)

        -- hide left aura frames
        for i = 1, maxUserPlaced do
            local idx = frame_registry[frame].placedAuraStart + i - 1
            local buffFrame = frame_registry[frame].extraBuffFrames[idx]
            if not buffFrame.auraInstanceID or not frame.buffs[buffFrame.auraInstanceID] then
                buffFrame:Hide()
                CooldownFrame_Clear(buffFrame.cooldown)
            end
        end
        for i = frameNum, math.max(frame_registry[frame].maxBuffs, frame.maxBuffs) do
            local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
            buffFrame:Hide()
            CooldownFrame_Clear(buffFrame.cooldown)
        end
    end
    self:HookFunc("CompactUnitFrame_HideAllBuffs", onHideAllBuffs)

    local function onFrameSetup(frame)
        if frame.maxBuffs == 0 or not frame.buffs then
            return
        end

        if not frame_registry[frame] then
            frame_registry[frame] = {
                maxBuffs        = frameOpt.maxbuffsAuto and frame.maxBuffs or frameOpt.maxbuffs,
                placedAuraStart = 0,
                lockdown        = false,
                dirty           = true,
                extraBuffFrames = {},
            }
        end

        if InCombatLockdown() then
            frame_registry[frame].lockdown = true
            return
        end
        frame_registry[frame].lockdown = false

        if frame_registry[frame].dirty then
            frame_registry[frame].maxBuffs = frameOpt.maxbuffsAuto and frame.maxBuffs or frameOpt.maxbuffs
            frame_registry[frame].dirty = false

            local placedAuraStart = frame.maxBuffs + 1
            for i = frame.maxBuffs + 1, frame_registry[frame].maxBuffs do
                local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
                if not buffFrame then
                    buffFrame = CreateFrame("Button", nil, nil, "CompactBuffTemplate")
                    buffFrame:SetParent(frame)
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
                    buffFrame = CreateFrame("Button", nil, nil, "CompactBuffTemplate")
                    buffFrame:SetParent(frame)
                    buffFrame:Hide()
                    buffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraBuffFrames[idx] = buffFrame
                end
                buffFrame.icon:SetTexCoord(0, 1, 0, 1)
            end

            for i = 1, frame_registry[frame].maxBuffs + maxUserPlaced do
                local buffFrame = frame_registry[frame].extraBuffFrames[i] or frame.buffFrames[i]
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
            end
        end

        -- set anchor and resize
        local anchorSet, prevFrame
        for i = 1, frame_registry[frame].maxBuffs do
            local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
            if not anchorSet then
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, 0, 0)
            end
            prevFrame = buffFrame
            resizeBuffFrame(buffFrame)
        end
        for _, place in pairs(userPlaced) do
            local idx = frame_registry[frame].placedAuraStart + place.idx - 1
            local buffFrame = frame_registry[frame].extraBuffFrames[idx]
            buffFrame:ClearAllPoints()
            buffFrame:SetPoint(place.point, frame, place.relativePoint, place.xOffset, place.yOffset)
            resizeBuffFrame(buffFrame)
        end

        onHideAllBuffs(frame)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", onFrameSetup)

    for _, v in pairs(frame_registry) do
        v.dirty = true
    end
    addon:IterateRoster(function(frame)
        onFrameSetup(frame)
        if frame_registry[frame] then
            CompactUnitFrame_UpdateAuras(frame)
        end
    end)

    self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        for frame, v in pairs(frame_registry) do
            if v.lockdown and v.dirty then
                onFrameSetup(frame)
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
        frame_registry[frame].dirty = true
        for _, buffFrame in pairs(frame.buffFrames) do
            buffFrame:Hide()
        end
        for _, extraBuffFrame in pairs(frame_registry[frame].extraBuffFrames) do
            extraBuffFrame:Hide()
        end

        local frameWidth = frame:GetWidth()
        local frameHeight = frame:GetHeight()
        local componentScale = min(frameWidth / NATIVE_UNIT_FRAME_HEIGHT, frameWidth / NATIVE_UNIT_FRAME_WIDTH)
        local Display = math.min(15, 11 * componentScale)
        local powerBarUsedHeight = frame.powerBar:IsShown() and frame.powerBar:GetHeight() or 0
        local buffPos, buffRelativePoint, buffOffset = "BOTTOMRIGHT", "BOTTOMLEFT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
        frame.buffFrames[1]:ClearAllPoints();
        frame.buffFrames[1]:SetPoint(buffPos, frame, "BOTTOMRIGHT", -3, buffOffset);
        for i=1, #frame.buffFrames do
            local buffFrame = frame.buffFrames[i]
            buffFrame:SetFrameStrata(frame:GetFrameStrata())
            buffFrame:SetSize(Display, Display)
            buffFrame.icon:SetTexCoord(0,1,0,1)
            if ( i > 1 ) then
                buffFrame:ClearAllPoints();
                buffFrame:SetPoint(buffPos, frame.buffFrames[i - 1], buffRelativePoint, 0, 0);
            end
            local cooldown = buffFrame.cooldown
            cooldown:SetDrawSwipe(true)
            cooldown:SetReverse(true)
            cooldown:SetDrawEdge(false)
            CDT:DisableCooldownText(cooldown)
            --TODO
            --[[
                find global font for stacks and restore properly
            ]]
            local stackText = buffFrame.count
            stackText:ClearAllPoints()
            stackText:SetPoint("BOTTOMRIGHT", buffFrame, "BOTTOMRIGHT", 0, 0)
            stackText:SetFont("Fonts\\ARIALN.TTF", 12.000000953674, "OUTLINE")
            stackText:SetTextColor(1,1,1,1)
            stackText:SetShadowColor(0,0,0)
            stackText:SetShadowOffset(0,0)
        end
    end
    addon:IterateRoster(restoreBuffFrames)
end