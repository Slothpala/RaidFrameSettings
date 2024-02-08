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




function Buffs:OnEnable()
    local frameOpt = addon.db.profile.Buffs.BuffFramesDisplay
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
    for _, auraInfo in pairs(addon.db.profile.Buffs.AuraPosition) do 
        userPlaced[auraInfo.spellId] = {
            point = addon:ConvertDbNumberToPosition(auraInfo.point),
            relativePoint = addon:ConvertDbNumberToPosition(auraInfo.relativePoint),
            xOffset = auraInfo.xOffset,
            yOffset = auraInfo.yOffset,
        }
    end
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

    local function updateAnchors(frame)
        local anchorSet, prevFrame
        for i=1, #frame.buffFrames do
            local buffFrame = frame.buffFrames[i]
            local aura = buffFrame.auraInstanceID and frame.unit and GetAuraDataByAuraInstanceID(frame.unit, buffFrame.auraInstanceID) or nil
            local hide = aura and blacklist[aura.spellId] or false
            local place = aura and userPlaced[aura.spellId] or false
            if not anchorSet and not hide and not place then 
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, 0, 0)
            end
            if hide then
                buffFrame:Hide()
            end
            if place and not hide then   
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(place.point, frame, place.relativePoint, place.xOffset, place.yOffset)
            end
            if not hide and not place then
                prevFrame = buffFrame
            end
        end
    end

    local function onFrameSetup(frame)
        updateAnchors(frame)
        for i=1, #frame.buffFrames do
            local buffFrame = frame.buffFrames[i]
            resizeBuffFrame(buffFrame)
            --Timer Settings
            local cooldown = buffFrame.cooldown
            if frameOpt.timerText then
                local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
                cooldownText:ClearAllPoints()
                cooldownText:SetPoint(durationOpt.point, buffFrame, durationOpt.relativePoint, durationOpt.xOffsetFont, durationOpt.yOffsetFont)
                cooldownText:SetFont(durationOpt.font, durationOpt.fontSize, durationOpt.outlinemode)
                cooldownText:SetTextColor(durationOpt.fontColor.r, durationOpt.fontColor.g, durationOpt.fontColor.b)
                cooldownText:SetShadowColor(durationOpt.shadowColor.r, durationOpt.shadowColor.g, durationOpt.shadowColor.b,durationOpt.shadowColor.a)
                cooldownText:SetShadowOffset(durationOpt.xOffsetShadow, durationOpt.yOffsetShadow)
            end
            --Stack Settings
            if not cooldown.count then
                cooldown.count = cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
            end
            local stackText = cooldown.count
            stackText:ClearAllPoints()
            stackText:SetPoint(stackOpt.point, buffFrame, stackOpt.relativePoint, stackOpt.xOffsetFont, stackOpt.yOffsetFont)
            stackText:SetFont(stackOpt.font, stackOpt.fontSize, stackOpt.outlinemode)
            stackText:SetTextColor(stackOpt.fontColor.r, stackOpt.fontColor.g, stackOpt.fontColor.b)
            stackText:SetShadowColor(stackOpt.shadowColor.r, stackOpt.shadowColor.g, stackOpt.shadowColor.b,stackOpt.shadowColor.a)
            stackText:SetShadowOffset(stackOpt.xOffsetShadow, stackOpt.yOffsetShadow)
            --Swipe Settings
            cooldown:SetDrawSwipe(frameOpt.swipe)
            cooldown:SetReverse(frameOpt.inverse)
            cooldown:SetDrawEdge(frameOpt.edge)
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", onFrameSetup)

    local onSetBuff = function(buffFrame, aura)
        local cooldown = buffFrame.cooldown
        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)
        local parentFrame = buffFrame:GetParent()
        updateAnchors(parentFrame)
        if not cooldown.count then
            return
        end
        if buffFrame.count:IsShown() then
            cooldown.count:SetText(buffFrame.count:GetText())
            cooldown.count:Show()
            buffFrame.count:Hide()
        else
            cooldown.count:Hide()
        end
     end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", onSetBuff)

    addon:IterateRoster(function(frame)
        onFrameSetup(frame)
        if frame.buffFrames then
            for i=1, #frame.buffFrames do
                local buffFrame = frame.buffFrames[i]
                if buffFrame.auraInstanceID then
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, buffFrame.auraInstanceID)
                    if aura then
                        if blacklist[aura.spellId] then
                            buffFrame:Hide()
                        else
                            buffFrame:Show()
                        end
                    end
                end
            end
            updateAnchors(frame)
        end
    end)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Buffs:OnDisable()
    self:DisableHooks()
    local restoreBuffFrames = function(frame)
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
            if cooldown.count then
                cooldown.count:Hide()
            end
        end
    end
    addon:IterateRoster(restoreBuffFrames)
end