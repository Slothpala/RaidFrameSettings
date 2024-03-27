--[[
    Created by Slothpala
--]]

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
local Buffs = addon:NewModule("Buffs")
Mixin(Buffs, addonTable.hooks)
local CDT = addonTable.cooldownText
local Media = LibStub("LibSharedMedia-3.0")

-- WoW Api
local SetSize = SetSize
local SetTexCoord = SetTexCoord
local ClearAllPoints = ClearAllPoints
local SetPoint = SetPoint
local SetFont = SetFont
local SetTextColor = SetTextColor
local SetShadowColor = SetShadowColor
local SetShadowOffset = SetShadowOffset
local SetDrawSwipe = SetDrawSwipe
local SetReverse = SetReverse
local SetDrawEdge = SetDrawEdge
local SetScale = SetScale
-- Lua
local next = next
local pairs = pairs

local buffFrameRegister = {
    --[[
        frame = {
            userPlaced = {
                spellId = {
                    buffFrame = buffFrame,
                    place = {
                        point = ,
                        relativePoint = ,
                        xOffset = ,
                        yOffset = ,
                        scale = , 
                    } 
                }
            }
            dynamicGroup = {
                [1] = frame,
                [2] = frame,
                ...
            }
        }
    ]]
}

function Buffs:OnEnable()
    local frameOpt = addon.db.profile.Buffs.BuffFramesDisplay
    -- Timer display options
    local durationOpt = CopyTable(addon.db.profile.Buffs.DurationDisplay) --copy is important so that we dont overwrite the db value when fetching the real values
    durationOpt.font = Media:Fetch("font", durationOpt.font)
    durationOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(durationOpt.outlinemode)
    durationOpt.point = addon:ConvertDbNumberToPosition(durationOpt.point)
    durationOpt.relativePoint = addon:ConvertDbNumberToPosition(durationOpt.relativePoint)
    -- Stack display options
    local stackOpt = CopyTable(addon.db.profile.Buffs.StacksDisplay)
    stackOpt.font = Media:Fetch("font", stackOpt.font)
    stackOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(stackOpt.outlinemode)
    stackOpt.point = addon:ConvertDbNumberToPosition(stackOpt.point)
    stackOpt.relativePoint = addon:ConvertDbNumberToPosition(stackOpt.relativePoint)
    -- Aura Position
    local numUserPlaced = 0 
    local userPlaced = {}
    for i, auraInfo in pairs(addon.db.profile.Buffs.AuraPosition) do 
        userPlaced[auraInfo.spellId] = {
            point = addon:ConvertDbNumberToPosition(auraInfo.point),
            relativePoint = addon:ConvertDbNumberToPosition(auraInfo.relativePoint),
            xOffset = auraInfo.xOffset,
            yOffset = auraInfo.yOffset,
            scale = auraInfo.scale or 1,
        }
        numUserPlaced = numUserPlaced + 1
    end
    -- Buff size
    local width  = frameOpt.width
    local height = frameOpt.height
    local ResizeBuffFrame
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
        ResizeBuffFrame = function(buffFrame)
            buffFrame:SetSize(width, height)
            buffFrame.icon:SetTexCoord(left,right,top,bottom)
        end
    else
        ResizeBuffFrame = function(buffFrame)
            buffFrame:SetSize(width, height)
        end
    end

    local function SetUpBuffDisplay(buffFrame)
        -- Timer Settings
        local cooldown = buffFrame.cooldown
        if frameOpt.timerText then
            local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
            cooldownText:ClearAllPoints()
            cooldownText:SetPoint(durationOpt.point, buffFrame, durationOpt.relativePoint, durationOpt.xOffsetFont, durationOpt.yOffsetFont)
            cooldownText:SetFont(durationOpt.font, durationOpt.fontSize, durationOpt.outlinemode)
            cooldownText:SetTextColor(durationOpt.fontColor.r, durationOpt.fontColor.g, durationOpt.fontColor.b)
            cooldownText:SetShadowColor(durationOpt.shadowColor.r, durationOpt.shadowColor.g, durationOpt.shadowColor.b,durationOpt.shadowColor.a)
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
        -- Stack Settings
        local stackText = buffFrame.count
        stackText:ClearAllPoints()
        stackText:SetPoint(stackOpt.point, buffFrame, stackOpt.relativePoint, stackOpt.xOffsetFont, stackOpt.yOffsetFont)
        stackText:SetFont(stackOpt.font, stackOpt.fontSize, stackOpt.outlinemode)
        stackText:SetTextColor(stackOpt.fontColor.r, stackOpt.fontColor.g, stackOpt.fontColor.b)
        stackText:SetShadowColor(stackOpt.shadowColor.r, stackOpt.shadowColor.g, stackOpt.shadowColor.b,stackOpt.shadowColor.a)
        stackText:SetShadowOffset(stackOpt.xOffsetShadow, stackOpt.yOffsetShadow)
        -- Swipe Settings
        cooldown:SetDrawSwipe(frameOpt.swipe)
        cooldown:SetReverse(frameOpt.inverse)
        cooldown:SetDrawEdge(frameOpt.edge)
        stackText:SetParent(cooldown)
    end

    -- Anchor the buffFrames
    local point = addon:ConvertDbNumberToPosition(frameOpt.point)
    local relativePoint = addon:ConvertDbNumberToPosition(frameOpt.relativePoint)
    local followPoint, followRelativePoint, followOffsetX, followOffsetY = addon:GetAuraGrowthOrientationPoints(frameOpt.orientation, frameOpt.gap)

    local function AnchorBuffFrames(frame)
        -- Setup user placed indicators
        for spellId, auraInfo in pairs(userPlaced) do
            local buffFrame = buffFrameRegister[frame].userPlaced[spellId].buffFrame
            buffFrame:ClearAllPoints()
            buffFrame:SetPoint(auraInfo.point, frame, auraInfo.relativePoint, auraInfo.xOffset, auraInfo.yOffset)
            buffFrame:SetScale(auraInfo.scale)
        end
        -- Setup dynamic group
        local numBuffFrames = frameOpt.extraBuffFrames and frameOpt.numBuffFrames or frame.maxBuffs
        local anchorSet, prevFrame
        for i=1, numBuffFrames do
            local buffFrame = buffFrameRegister[frame].dynamicGroup[i]
            if not anchorSet then 
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, followOffsetX, followOffsetY)
            end
            prevFrame = buffFrame
        end
    end

    -- Setup the buff frame visuals
    local function OnFrameSetup(frame)
        -- Create or find assigned buff frames
        if not buffFrameRegister[frame] then
            buffFrameRegister[frame] = {}
            buffFrameRegister[frame].userPlaced = {}
            buffFrameRegister[frame].dynamicGroup = {}
        end
        -- Create user placed buff frames
        for spellId, info in pairs(userPlaced) do
            if not buffFrameRegister[frame].userPlaced[spellId] then
                buffFrameRegister[frame].userPlaced[spellId] = {}
            end
            local buffFrame = buffFrameRegister[frame].userPlaced[spellId].buffFrame
            if not buffFrame then
                buffFrame = CreateFrame("Button", nil, frame, "CompactBuffTemplate")
                buffFrameRegister[frame].userPlaced[spellId].buffFrame = buffFrame
            end
            ResizeBuffFrame(buffFrame)
            SetUpBuffDisplay(buffFrame)
        end
        -- Create dynamic buff frames
        local numBuffFrames = frameOpt.extraBuffFrames and frameOpt.numBuffFrames or frame.maxBuffs 
        for i=1, numBuffFrames do
            local buffFrame = buffFrameRegister[frame].dynamicGroup[i] --currently there are always 10 buffFrames but i am not sure if it wise to use more than maxBuffs will test it but for now i prefer creating new ones
            if not buffFrame then
                buffFrame = CreateFrame("Button", nil, frame, "CompactBuffTemplate")
            end
            buffFrameRegister[frame].dynamicGroup[i] = buffFrame
            ResizeBuffFrame(buffFrame)
            SetUpBuffDisplay(buffFrame)
        end
        AnchorBuffFrames(frame)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", OnFrameSetup)

    local OnSetBuff = function(buffFrame, aura)
        local cooldown = buffFrame.cooldown
        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", OnSetBuff)

    local function OnUpdateAuras(frame)
        -- To not have to constantly reanchor the buff frames we don't use blizzards at all
        if frame.buffFrames then
            for _, buffFrame in next, frame.buffFrames do
                buffFrame:Hide()
            end
        end
        local numBuffFrames = frameOpt.extraBuffFrames and frameOpt.numBuffFrames or frame.maxBuffs 
        local frameNum = 1
        -- Set the auras
        frame.buffs:Iterate(function(auraInstanceID, aura)
            -- Exclude unwanted frames
            if not buffFrameRegister[frame] or frame:IsForbidden() or not frame:IsVisible() then
                return true
            end
            -- Place user placed auras since we always have buff frames for them
            local place = numUserPlaced > 0 and userPlaced[aura.spellId] 
            if place then
                local buffFrame = buffFrameRegister[frame].userPlaced[aura.spellId].buffFrame
                CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                return false
            end
            local exceedingLimit = frameNum > numBuffFrames
            if exceedingLimit and numUserPlaced == 0 then
                -- Only return true if we have no placed auras otherwise we have to iterate over all buffs
                return true
            end
            -- Make sure we don't set more buffs than we have frames for
            if not exceedingLimit then
                -- Set the buff 
                local buffFrame = buffFrameRegister[frame].dynamicGroup[frameNum]
                CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                -- Increase counter only for non placed
                frameNum = frameNum + 1
            end
            return false
        end)
    end
    self:HookFunc("CompactUnitFrame_UpdateAuras", OnUpdateAuras)

    addon:IterateRoster(function(frame)
        OnFrameSetup(frame)
        OnUpdateAuras(frame)
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
            if cooldown.OmniCC then
                OmniCC.Cooldown.SetNoCooldownCount(cooldown, cooldown.OmniCC.noCooldownCount)
                cooldown.OmniCC = nil
            end
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