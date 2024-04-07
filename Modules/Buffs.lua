--[[
    Created by Slothpala
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
local IsVisible = IsVisible
local Hide = Hide
local AuraUtil_ForEachAura = AuraUtil.ForEachAura
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local AuraUtil_ShouldDisplayBuff = AuraUtil.ShouldDisplayBuff
--local CompactUnitFrame_UtilSetBuff = CompactUnitFrame_UtilSetBuff -- don't do this
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
            auraCache = {
                [auraInstanceID] = aura,
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
    local hasPlacedAuras = ( numUserPlaced > 0 ) and true or false
    -- 
    local numBuffFrames = frameOpt.numBuffFrames
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
    local glow_options = {
        startAnim = false,
        frameLevel = 1,
    }
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
        if not UnitIsPlayer(frame.unit) and not UnitInPartyIsAI(frame.unit) then
            return
        end
        -- Create or find assigned buff frames
        if not buffFrameRegister[frame] then
            buffFrameRegister[frame] = {}
            buffFrameRegister[frame].userPlaced = {}
            buffFrameRegister[frame].dynamicGroup = {}
            buffFrameRegister[frame].auraCache = {}
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
        if buffFrame:IsForbidden() then
            return
        end
        local enabled = aura.expirationTime and aura.expirationTime ~= 0
        if enabled then
            local cooldown = buffFrame.cooldown
            CDT:StartCooldownText(cooldown)
            cooldown:SetDrawEdge(frameOpt.edge)
        end
        if glow_list[aura.spellId] then
            LCG.ProcGlow_Start(buffFrame, glow_options)
            glow_frame_register[buffFrame] = true
        elseif glow_frame_register[buffFrame] == true then
            --[[ to future me: As of writing this the function CompactUnitFrame_UtilSetBuff also gets called when the frames are no longer visible 
                i.e. when the unit left the group so it will "clean up" glows by itsleft.
            ]]
            LCG.ProcGlow_Stop(buffFrame)
            glow_frame_register[buffFrame] = false
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", OnSetBuff)

   -- Aura update
    -- FIXME Improve performance by i.e. building a cache during combat
    local function should_show_watchlist_aura(aura)
        local info = watchlist[aura.spellId] or {}
        if ( info.ownOnly and aura.sourceUnit ~= "player" ) then
            return false
        else
            return true
        end
    end

    local function should_show_aura(aura)
        if blacklist[aura.spellId] then
            return false
        end
        if watchlist[aura.spellId] then
            return should_show_watchlist_aura(aura)
        end
        return AuraUtil_ShouldDisplayBuff(aura.sourceUnit, aura.spellId, aura.canApplyAura) 
    end

    -- making use of the unitAuraUpdateInfo provided by UpdateAuras
    local function update_and_get_aura_cache(frame, unitAuraUpdateInfo)
        local auraCache = buffFrameRegister[frame].auraCache or {}
        local buffsChanged = false
        if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
            auraCache = {}
            local function handle_help_aura(aura)
                if should_show_aura(aura) then
                    auraCache[aura.auraInstanceID] = aura
                    buffsChanged = true
                end
            end
            local batchCount = nil
            local usePackedAura = true
            AuraUtil_ForEachAura(frame.unit, "HELPFUL", batchCount, handle_help_aura, usePackedAura)
		else
            if unitAuraUpdateInfo.addedAuras ~= nil then
                for _, aura in next, unitAuraUpdateInfo.addedAuras do
                    if aura.isHelpful and should_show_aura(aura) then
                        auraCache[aura.auraInstanceID] = aura
                        buffsChanged = true
                    end
                end
            end
            if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
                for _, auraInstanceID  in next, unitAuraUpdateInfo.updatedAuraInstanceIDs do
                    if auraCache[auraInstanceID] ~= nil then
                        local newAura = C_UnitAuras_GetAuraDataByAuraInstanceID(frame.displayedUnit, auraInstanceID)
                        auraCache[auraInstanceID] = newAura 
                        buffsChanged = true
                    end
                end
            end
            if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
                for _, auraInstanceID in next, unitAuraUpdateInfo.removedAuraInstanceIDs do
                    if auraCache[auraInstanceID] then
                        auraCache[auraInstanceID] = nil
                        buffsChanged = true
                    end
                end
            end
        end
        buffFrameRegister[frame].auraCache = auraCache
        return buffsChanged, auraCache
    end

    local function on_update_auras(frame, unitAuraUpdateInfo)
        -- Exclude unwanted frames
        if not buffFrameRegister[frame] or not frame:IsVisible() then
            return 
        end
        local buffsChanged, auraCache =  update_and_get_aura_cache(frame, unitAuraUpdateInfo)
        if not buffsChanged then
            return
        end
        local frameNum = 1
        for _, aura in next, auraCache do
            local place = userPlaced[aura.spellId]  
            -- Start with user placed auras as we always have space for them
            if place then
                local buffFrame = buffFrameRegister[frame].userPlaced[aura.spellId].buffFrame
                if buffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                    CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                end
            elseif not ( frameNum > numBuffFrames ) then
                local buffFrame = buffFrameRegister[frame].dynamicGroup[frameNum]
                if buffFrame then
                    CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                end
                frameNum = frameNum + 1
            end
        end
        for i=frameNum, numBuffFrames do
            local buffFrame = buffFrameRegister[frame].dynamicGroup[i]
            if buffFrame then
                buffFrame:Hide()
            end
        end
    end

    -- Check if we actually want to see any auras
    if numBuffFrames > 0 or hasPlacedAuras then
        self:HookFuncFiltered("CompactUnitFrame_UpdateAuras", on_update_auras)
    end

    local function on_hide_all_buffs(frame)
        -- Exclude unwanted frames
        if not buffFrameRegister[frame] or not frame:IsVisible() or not frame.buffFrames then
            return 
        end
        -- To not have to constantly reanchor the buff frames we don't use blizzards at all
        for _, buffFrame in next, frame.buffFrames do
            buffFrame:Hide()
        end
    end
    self:HookFuncFiltered("CompactUnitFrame_HideAllBuffs", on_hide_all_buffs)

    addon:IterateRoster(function(frame)
        OnFrameSetup(frame)
        on_hide_all_buffs(frame)
        on_update_auras(frame)
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
            local duration = cooldown:GetCooldownDuration()
            if duration > 0 then
                buffFrame:Show()
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
    for buffFrame, state in pairs(glow_frame_register) do
        if state == true then
            LCG.ProcGlow_Stop(buffFrame)
        end
    end
    addon:IterateRoster(restoreBuffFrames)
end