--[[
    Created by Slothpala 
--]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
local Debuffs = addon:NewModule("Debuffs")
Mixin(Debuffs, addonTable.hooks)
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
local IsVisible = IsVisible
local Hide = Hide
local AuraUtil_ForEachAura = AuraUtil.ForEachAura
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local AuraUtil_ShouldDisplayDebuff = AuraUtil.ShouldDisplayDebuff
--local CompactUnitFrame_UtilSetDebuff = CompactUnitFrame_UtilSetDebuff -- don't do this
-- Lua
local next = next
local pairs = pairs
-- Colors
-- TODO add addon wide settings for color management
local debuffColors = {
    Curse   = {r=0.6,g=0.0,b=1.0},
    Disease = {r=0.6,g=0.4,b=0.0},
    Magic   = {r=0.2,g=0.6,b=1.0},
    Poison  = {r=0.0,g=0.6,b=0.0},
    Bleed   = {r=0.8,g=0.0,b=0.0},
}

local debuffFrameRegister = {
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
                [aura] = aura,
            }
        }
    ]]
}

function Debuffs:OnEnable()
    local frameOpt = addon.db.profile.Debuffs.DebuffFramesDisplay
    -- Timer display options
    local durationOpt = CopyTable(addon.db.profile.Debuffs.DurationDisplay) --copy is important so that we dont overwrite the db value when fetching the real values
    durationOpt.font = Media:Fetch("font", durationOpt.font)
    durationOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(durationOpt.outlinemode)
    durationOpt.point = addon:ConvertDbNumberToPosition(durationOpt.point)
    durationOpt.relativePoint = addon:ConvertDbNumberToPosition(durationOpt.relativePoint)
    -- Stack display options
    local stackOpt = CopyTable(addon.db.profile.Debuffs.StacksDisplay)
    stackOpt.font = Media:Fetch("font", stackOpt.font)
    stackOpt.outlinemode = addon:ConvertDbNumberToOutlinemode(stackOpt.outlinemode)
    stackOpt.point = addon:ConvertDbNumberToPosition(stackOpt.point)
    stackOpt.relativePoint = addon:ConvertDbNumberToPosition(stackOpt.relativePoint)
    -- Aura Position
    local numUserPlaced = 0 
    local userPlaced = {}
    for i, auraInfo in pairs(addon.db.profile.Debuffs.AuraPosition) do 
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
	-- Increased Auras
    local increase = {}
    for spellId, value in pairs(addon.db.profile.Debuffs.Increase) do
        increase[tonumber(spellId)] = true
    end
    -- 
    local numDebuffFrames = frameOpt.numFrames
    -- Blacklist 
    local blacklist = {}
    if addon:IsModuleEnabled("Blacklist") then
        blacklist = addon:GetBlacklist()
    end
    -- Watchlist
    local watchlist = {}
    if addon:IsModuleEnabled("Watchlist") then
        watchlist = addon:GetWatchlist()
    end
    -- Debuff size
    local width  = frameOpt.width
    local height = frameOpt.height
    local boss_width  = width * frameOpt.increase
    local boss_height = height * frameOpt.increase
    local ResizeDebuffFrame
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
        ResizeDebuffFrame = function(debuffFrame)
            debuffFrame:SetSize(width, height)
            debuffFrame.icon:SetTexCoord(left,right,top,bottom)
            debuffFrame.border:SetTexture("Interface/AddOns/RaidFrameSettings/Textures/DebuffOverlay_clean_icons.tga")
            debuffFrame.border:SetTexCoord(0,1,0,1)
            debuffFrame.border:SetTextureSliceMargins(5.01, 26.09, 5.01, 26.09) 
            debuffFrame.border:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
        end
    else
        ResizeDebuffFrame = function(debuffFrame)
            debuffFrame:SetSize(width, height)
        end
    end

    -- Setup timer + stack fonts and cooldown settings
    local function SetUpDebuffDisplay(debuffFrame)
        -- Timer Settings
        local cooldown = debuffFrame.cooldown
        if frameOpt.timerText then
            local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
            cooldownText:ClearAllPoints()
            cooldownText:SetPoint(durationOpt.point, debuffFrame, durationOpt.relativePoint, durationOpt.xOffsetFont, durationOpt.yOffsetFont)
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
        local stackText = debuffFrame.count
        stackText:ClearAllPoints()
        stackText:SetPoint(stackOpt.point, debuffFrame, stackOpt.relativePoint, stackOpt.xOffsetFont, stackOpt.yOffsetFont)
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

    -- Anchor the debuffFrames
    local point = addon:ConvertDbNumberToPosition(frameOpt.point)
    local relativePoint = addon:ConvertDbNumberToPosition(frameOpt.relativePoint)
    local followPoint, followRelativePoint, followOffsetX, followOffsetY = addon:GetAuraGrowthOrientationPoints(frameOpt.orientation, frameOpt.gap)
    
    local function AnchorDebuffFrames(frame)
        -- Setup user placed indicators
        for spellId, auraInfo in pairs(userPlaced) do
            local debuffFrame = debuffFrameRegister[frame].userPlaced[spellId].debuffFrame
            debuffFrame:ClearAllPoints()
            debuffFrame:SetPoint(auraInfo.point, frame, auraInfo.relativePoint, auraInfo.xOffset, auraInfo.yOffset)
            debuffFrame:SetScale(auraInfo.scale)
        end
        -- Setup dynamic group
        local numDebuffFrames = frameOpt.customCount and frameOpt.numFrames or frame.maxDebuffs 
        local anchorSet, prevFrame
        for i=1, numDebuffFrames do
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[i]
            if not anchorSet then 
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, followOffsetX, followOffsetY)
            end
            prevFrame = debuffFrame
        end
    end

    -- Setup the debuff frame visuals
    local function OnFrameSetup(frame)
        if not UnitIsPlayer(frame.unit) then
            return
        end
        -- Create or find assigned debuff frames
        if not debuffFrameRegister[frame] then
            debuffFrameRegister[frame] = {}
            debuffFrameRegister[frame].userPlaced = {}
            debuffFrameRegister[frame].dynamicGroup = {}
            debuffFrameRegister[frame].auraCache = {}
        end
        -- Create user placed debuff frames
        for spellId, info in pairs(userPlaced) do
            if not debuffFrameRegister[frame].userPlaced[spellId] then
                debuffFrameRegister[frame].userPlaced[spellId] = {}
            end
            local debuffFrame = debuffFrameRegister[frame].userPlaced[spellId].debuffFrame
            if not debuffFrame then
                debuffFrame = CreateFrame("Button", nil, frame, "CompactDebuffTemplate")
                debuffFrame.baseSize = 1
                debuffFrame.maxHeight = 1
                debuffFrameRegister[frame].userPlaced[spellId].debuffFrame = debuffFrame
            end
            ResizeDebuffFrame(debuffFrame)
            SetUpDebuffDisplay(debuffFrame)
        end
        -- Create dynamic debuff frames
        local numDebuffFrames = frameOpt.customCount and frameOpt.numFrames or frame.maxDebuffs 
        for i=1, numDebuffFrames do
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[i] --currently there are always 10 buffFrames but i am not sure if it wise to use more than maxBuffs will test it but for now i prefer creating new ones
            if not debuffFrame then
                debuffFrame = CreateFrame("Button", nil, frame, "CompactDebuffTemplate")
                debuffFrame.baseSize = 1
                debuffFrame.maxHeight = 1
            end
            debuffFrameRegister[frame].dynamicGroup[i] = debuffFrame
            ResizeDebuffFrame(debuffFrame)
            SetUpDebuffDisplay(debuffFrame)
        end
        AnchorDebuffFrames(frame)
        -- Setup private aura size
        if frame.PrivateAuraAnchors then
            for _, privateAuraAnchor in ipairs(frame.PrivateAuraAnchors) do
                privateAuraAnchor:SetSize(width, height)
            end
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", OnFrameSetup)

    -- Start cooldown timers and resize the debuff frame
    local function OnSetDebuff(debuffFrame, aura)
        if debuffFrame:IsForbidden() then
            return
        end
        local enabled = aura.expirationTime and aura.expirationTime ~= 0
        if enabled then
            local cooldown = debuffFrame.cooldown
            CDT:StartCooldownText(cooldown)
            cooldown:SetDrawEdge(frameOpt.edge)
            if durationOpt.durationByDebuffColor then
                local color = debuffColors[aura.dispelName] or durationOpt.fontColor
                local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
                cooldownText:SetTextColor(color.r, color.g, color.b)
            end
        end
        if aura and (aura.isBossAura or increase[aura.spellId]) then
            debuffFrame:SetSize(boss_width, boss_height)
        else
            debuffFrame:SetSize(width, height)
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetDebuff", OnSetDebuff)

    -- Setup private aura anchor
    local function OnUpdatePrivateAuras(frame)
        if not frame.PrivateAuraAnchors or not debuffFrameRegister[frame] or not frame:IsVisible() then
            return
        end

        local lastShownDebuffFrame
        local numDebuffFrames = frameOpt.customCount and frameOpt.numFrames or frame.maxDebuffs 
        for i = numDebuffFrames, 1, -1 do
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[i]
            if debuffFrame and debuffFrame:IsShown() then
                lastShownDebuffFrame = debuffFrame
                break
            end
        end

        frame.PrivateAuraAnchor1:ClearAllPoints()
        if lastShownDebuffFrame then
            frame.PrivateAuraAnchor1:SetPoint(followPoint, lastShownDebuffFrame, followRelativePoint, followOffsetX, followOffsetY)
        else
            frame.PrivateAuraAnchor1:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
        end
    end
    self:HookFuncFiltered("CompactUnitFrame_UpdatePrivateAuras", OnUpdatePrivateAuras)

   -- Aura update
    -- FIXME Improve performance by i.e. building a cache during combat
    local function should_show_watchlist_aura(aura)
        local info = watchlist[aura.spellId] or {}
        if info.hideInCombat then
            -- TODO combat util
            return not addonTable.inCombat 
        elseif ( info.ownOnly and aura.sourceUnit ~= "player" ) then
            return false
        else
            return true
        end
    end

    local function should_show_aura(aura)
        if blacklist[aura.spellId] then
            return false
        end
        return AuraUtil_ShouldDisplayDebuff(aura.sourceUnit, aura.spellId) or ( watchlist[aura.spellId] and should_show_watchlist_aura(aura) ) 
    end

    -- making use of the unitAuraUpdateInfo provided by UpdateAuras
    local function update_and_get_aura_cache(frame, unitAuraUpdateInfo)
        local auraCache = debuffFrameRegister[frame].auraCache or {}
        local debuffsChanged = false
        if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
            auraCache = {}
            local function handle_harm_aura(aura)
                if should_show_aura(aura) then
                    auraCache[aura.auraInstanceID] = aura
                    debuffsChanged = true
                end
            end
            local batchCount = nil
            local usePackedAura = true
            AuraUtil_ForEachAura(frame.unit, "HARMFUL", batchCount, handle_harm_aura, usePackedAura)
		else
            if unitAuraUpdateInfo.addedAuras ~= nil then
                for _, aura in next, unitAuraUpdateInfo.addedAuras do
                    if aura.isHarmful and should_show_aura(aura) then
                        auraCache[aura.auraInstanceID] = aura
                        debuffsChanged = true
                    end
                end
            end
            if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
                for _, auraInstanceID  in next, unitAuraUpdateInfo.updatedAuraInstanceIDs do
                    if auraCache[auraInstanceID] ~= nil then
                        local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.displayedUnit, auraInstanceID)
                        auraCache[auraInstanceID] = newAura
                        debuffsChanged = true
                    end
                end
            end
            if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
                for _, auraInstanceID in next, unitAuraUpdateInfo.removedAuraInstanceIDs do
                    if auraCache[auraInstanceID] then
                        auraCache[auraInstanceID] = nil
                        debuffsChanged = true
                    end
                end
            end
        end
        debuffFrameRegister[frame].auraCache = auraCache
        return debuffsChanged, auraCache
    end

    local function on_update_auras(frame, unitAuraUpdateInfo)
        -- Exclude unwanted frames
        if not debuffFrameRegister[frame] or not frame:IsVisible() then
            return true
        end
        local debuffsChanged, auraCache = update_and_get_aura_cache(frame, unitAuraUpdateInfo)
        if not debuffsChanged then
            return
        end
        local frameNum = 1 
        -- Set the auras
        for _, aura in next, auraCache do
            local place = userPlaced[aura.spellId]  
            -- Start with user placed auras as we always have space for them
            if place then
                local debuffFrame = debuffFrameRegister[frame].userPlaced[aura.spellId].buffFrame
                if debuffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, aura)
                end
            elseif not ( frameNum > numDebuffFrames ) then
                local debuffFrame = debuffFrameRegister[frame].dynamicGroup[frameNum]
                if debuffFrame then
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, aura)
                end
                frameNum = frameNum + 1
            end
        end
        for i=frameNum, numDebuffFrames do
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[i]
            if debuffFrame then
                debuffFrame:Hide()
            end
        end
        OnUpdatePrivateAuras(frame)
    end

    -- Check if we actually want to see any auras
    if numDebuffFrames > 0 or hasPlacedAuras then
        self:HookFuncFiltered("CompactUnitFrame_UpdateAuras", on_update_auras)
    end

    local function on_hide_all_debuffs(frame)
        -- Exclude unwanted frames
        if not debuffFrameRegister[frame] or not frame:IsVisible() or not frame.debuffFrames then
            return 
        end
        -- To not have to constantly reanchor the buff frames we don't use blizzards at all
        for _, debuffFrame in next, frame.debuffFrames do
            debuffFrame:Hide()
        end
    end
    self:HookFuncFiltered("CompactUnitFrame_HideAllDebuffs", on_hide_all_debuffs)

    addon:IterateRoster(function(frame)
        OnFrameSetup(frame)
        on_update_auras(frame)
    end)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Debuffs:OnDisable()
    self:DisableHooks()
    local restoreDebuffFrames = function(frame)
        local frameWidth = frame:GetWidth()
        local frameHeight = frame:GetHeight()
        local componentScale = min(frameWidth / NATIVE_UNIT_FRAME_HEIGHT, frameWidth / NATIVE_UNIT_FRAME_WIDTH)
        local buffSize = math.min(15, 11 * componentScale)
        for i=1,#frame.debuffFrames do  
            frame.debuffFrames[i]:SetSize(buffSize, buffSize)
        end
        local powerBarUsedHeight = frame.powerBar:IsShown() and frame.powerBar:GetHeight() or 0
        local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight
        frame.debuffFrames[1]:ClearAllPoints()
        frame.debuffFrames[1]:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset)
        for i=1, #frame.debuffFrames do
            local debuffFrame = frame.debuffFrames[i]
            debuffFrame.border:SetTexture("Interface\\BUTTONS\\UI-Debuff-Overlays")
            debuffFrame.border:SetTexCoord(0.296875, 0, 0.296875, 0.515625, 0.5703125, 0, 0.5703125, 0.515625)
            debuffFrame.border:SetTextureSliceMargins(0,0,0,0)
            debuffFrame.icon:SetTexCoord(0,1,0,1)
            if ( i > 1 ) then
                debuffFrame:ClearAllPoints();
                debuffFrame:SetPoint(debuffPos, frame.debuffFrames[i - 1], debuffRelativePoint, 0, 0);
            end
            local cooldown = debuffFrame.cooldown
            cooldown:SetDrawSwipe(true)
            cooldown:SetReverse(false)
            cooldown:SetDrawEdge(false)
            CDT:DisableCooldownText(cooldown)
            if cooldown.OmniCC then
                OmniCC.Cooldown.SetNoCooldownCount(cooldown, cooldown.OmniCC.noCooldownCount)
                cooldown.OmniCC = nil
            end
            local duration = cooldown:GetCooldownDuration()
            if duration > 0 then
                debuffFrame:Show()
            end
            --TODO
            --[[
                find global font for stacks and restore properly
            ]]
            local stackText = debuffFrame.count
            stackText:ClearAllPoints()
            stackText:SetPoint("BOTTOMRIGHT", debuffFrame, "BOTTOMRIGHT", 0, 0)
            stackText:SetFont("Fonts\\ARIALN.TTF", 12.000000953674, "OUTLINE")
            stackText:SetTextColor(1,1,1,1)
            stackText:SetShadowColor(0,0,0)
            stackText:SetShadowOffset(0,0)
        end
    end
    -- Hide our frames
    for frame, info in pairs(debuffFrameRegister) do
        for _, indicator in pairs(info.userPlaced) do
            CooldownFrame_Clear(indicator.debuffFrame.cooldown)
            indicator.debuffFrame:Hide()
        end
        for _, debuffFrame in pairs(info.dynamicGroup) do
            CooldownFrame_Clear(debuffFrame.cooldown)
            debuffFrame:Hide()
        end
    end
    addon:IterateRoster(restoreDebuffFrames)
end
