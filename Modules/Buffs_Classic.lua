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
local LCG = LibStub("LibCustomGlow-1.0")
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
local select = select
--They don't exist in classic
local NATIVE_UNIT_FRAME_HEIGHT = 36
local NATIVE_UNIT_FRAME_WIDTH = 72 

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
local glow_frame_register = {}

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
    -- Blacklist 
    local blacklist = {}
    if addon:IsModuleEnabled("Blacklist") then
        for spellId, _ in pairs(addon.db.profile.Blacklist) do
            blacklist[tonumber(spellId)] = true
        end
    end
    -- Watchlist
    local watchlist = {}
    if addon:IsModuleEnabled("Watchlist") then
        for spellId, info in pairs(addon.db.profile.Watchlist) do
            watchlist[tonumber(spellId)] = info
        end
    end
    local glow_list = {}
    for spellId, info in pairs(watchlist) do
        if info.glow then
            glow_list[spellId] = true
        end
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

    local isVanilla = addonTable.isVanilla
    local OnSetBuff = function(buffFrame, unit, index, filter)
        if buffFrame:IsForbidden() then
            return
        end
        local _, _, _, _, duration, expirationTime, _, _, _, spellId = UnitBuff(unit, index, filter)
        local enabled = expirationTime and expirationTime ~= 0
        local cooldown = buffFrame.cooldown
        if enabled then
            CDT:StartCooldownText(cooldown)
            cooldown:SetDrawEdge(frameOpt.edge)
            if isVanilla then
                local startTime = expirationTime - duration
                CooldownFrame_Set(cooldown, startTime, duration, true)
            end
        else
            if isVanilla then
                CooldownFrame_Clear(cooldown)
            end
        end
        if glow_list[spellId] then
            LCG.ButtonGlow_Start(cooldown, nil, nil, 0)
            glow_frame_register[cooldown] = true
        elseif glow_frame_register[cooldown] == true then
            LCG.ButtonGlow_Stop(cooldown)
            glow_frame_register[cooldown] = false
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", OnSetBuff)

    local function ShouldShowWatchlistAura(unit, index)
        local _, _, _, _, _, _, source, _, _, spellId = UnitBuff(unit, index)
        local info = watchlist[spellId]
        if info.hideInCombat then
            return not InCombatLockdown()
        elseif ( info.ownOnly and source ~= "player" ) then
            return false
        else
            return true
        end
    end

    local function OnUpdateBuffs(frame)
        -- Exclude unwanted frames
        if not buffFrameRegister[frame] or not frame:IsVisible() or not frame.buffFrames then
            return 
        end
        -- To not have to constantly reanchor the buff frames we don't use blizzards at all
        for _, buffFrame in next, frame.buffFrames do
            buffFrame:Hide()
        end
        local numBuffFrames = frameOpt.extraBuffFrames and frameOpt.numBuffFrames or frame.maxBuffs 
        if numBuffFrames == 0 and numUserPlaced == 0 then
            return
        end
        local index = 1
        local frameNum = 1
        local filter = nil
        -- Set the auras
        local spellId = true
        while ( spellId ) do
            spellId = select(10, UnitBuff(frame.displayedUnit, index))
            if ( spellId and not blacklist[spellId] ) then
                -- Place user placed auras since we always have buff frames for them
                local place = numUserPlaced > 0 and userPlaced[spellId] 
                if place then
                    local buffFrame = buffFrameRegister[frame].userPlaced[spellId].buffFrame
                    if buffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                        CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter)
                    end
                elseif not ( frameNum > numBuffFrames ) then
                    if ( watchlist[spellId] ) then
                        if ShouldShowWatchlistAura(frame.displayedUnit, index) then
                            local buffFrame = buffFrameRegister[frame].dynamicGroup[frameNum]
                            if buffFrame then
                                CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter)
                            end
                            frameNum = frameNum + 1
                        end
                    elseif ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
                        local buffFrame = buffFrameRegister[frame].dynamicGroup[frameNum]
                        if buffFrame then
                            CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter)
                        end
                        frameNum = frameNum + 1
                    end
                end
            end
            index = index + 1
        end
        
        for i=frameNum, numBuffFrames do
            local buffFrame = buffFrameRegister[frame].dynamicGroup[i]
            if buffFrame then
                buffFrame:Hide()
            end
        end
    end
    self:HookFuncFiltered("CompactUnitFrame_UpdateBuffs", OnUpdateBuffs)

    addon:IterateRoster(function(frame)
        OnFrameSetup(frame)
        OnUpdateBuffs(frame)
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
    -- Hide our frames
    for frame, info in pairs(buffFrameRegister) do
        for _, indicator in pairs(info.userPlaced) do
            CooldownFrame_Clear(indicator.buffFrame.cooldown)
            indicator.buffFrame:Hide()
        end
        for _, buffFrame in pairs(info.dynamicGroup) do
            CooldownFrame_Clear(buffFrame.cooldown)
            buffFrame:Hide()
        end
    end
    -- Hide all glows
    for cooldown, state in pairs(glow_frame_register) do
        if state == true then
            LCG.ButtonGlow_Stop(cooldown)
        end
    end
    addon:IterateRoster(restoreBuffFrames)
end