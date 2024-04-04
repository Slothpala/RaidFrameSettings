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
--They don't exist in classic
local NATIVE_UNIT_FRAME_HEIGHT = 36
local NATIVE_UNIT_FRAME_WIDTH = 72 

local fontObj = CreateFont("RaidFrameSettingsFont")

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
	-- Increased Auras
    local increase = {}
    for spellId, value in pairs(addon.db.profile.Debuffs.Increase) do
        increase[tonumber(spellId)] = true
    end
    -- Blacklist 
    local blacklist = {}
    if addon:IsModuleEnabled("Blacklist") then
        blacklist = addon:GetBlacklist()
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
            --[[ --FIXME add backdrop settings for classic border
            debuffFrame.border:SetTexture("Interface/AddOns/RaidFrameSettings/Textures/DebuffOverlay_clean_icons.tga")
            debuffFrame.border:SetTexCoord(0,1,0,1)
            debuffFrame.border:SetTextureSliceMargins(5.01, 26.09, 5.01, 26.09) 
            debuffFrame.border:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
            ]]
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
        -- Create or find assigned debuff frames
        if not debuffFrameRegister[frame] then
            debuffFrameRegister[frame] = {}
            debuffFrameRegister[frame].userPlaced = {}
            debuffFrameRegister[frame].dynamicGroup = {}
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
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", OnFrameSetup)

    -- Start cooldown timers and resize the debuff frame
    local function OnSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
        if debuffFrame:IsForbidden() then
            return
        end
        local cooldown = debuffFrame.cooldown
        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)
        local _, _, _, dispelType, _, _, _, _, _, spellId = UnitDebuff(unit, index)
        if durationOpt.durationByDebuffColor then
            local color = debuffColors[dispelType] or durationOpt.fontColor
            local cooldownText = CDT:CreateOrGetCooldownFontString(cooldown)
            cooldownText:SetTextColor(color.r, color.g, color.b)
        end
        if isBossAura or isBossBuff or ( increase[spellId] and not userPlaced[spellId] ) then
            debuffFrame:SetSize(boss_width, boss_height)
        else
            debuffFrame:SetSize(width, height)
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetDebuff", OnSetDebuff)

    local function OnUpdateDebuffs(frame)
        -- Exclude unwanted frames
        if not debuffFrameRegister[frame] or not frame:IsVisible() or not frame.debuffFrames then
            return true
        end
        -- To not have to constantly reanchor the buff frames we don't use blizzards at all
        for _, debuffFrame in next, frame.debuffFrames do
            debuffFrame:Hide()
        end
        local numDebuffFrames = frameOpt.customCount and frameOpt.numFrames or frame.maxDebuffs  
        if numDebuffFrames == 0 and numUserPlaced == 0 then
            return
        end
        local index = 1
        local filter = nil
        -- Scan all auras 
        local boss_debuffs = {}
        local boss_buffs = {}
        local prio_debuffs = {}
        local debuffs = {}
        local user_placed_auras = {}
        local spellId = true
        -- Scan debuffs
        while ( spellId ) do 
            spellId = select(10, UnitDebuff(frame.displayedUnit, index))
            local is_placed = numUserPlaced > 0 and userPlaced[spellId] -- FIXME optimize
            if is_placed then
                user_placed_auras[spellId] = index
            end
            if ( spellId and not blacklist[spellId] and not is_placed ) then
                if CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) then
                    boss_debuffs[spellId] = index
                elseif CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) then
                    prio_debuffs[spellId] = index
                else
                    debuffs[spellId] = index
                end
            end
            index = index + 1
        end
        -- Scan buffs for boss auras
        spellId = true
        index = 1
        while ( spellId ) do
            spellId = select(10, UnitBuff(frame.displayedUnit, index))
            local is_placed = numUserPlaced > 0 and userPlaced[spellId] -- FIXME optimize
            if is_placed then
                user_placed_auras[spellId] = index
            end
            if ( spellId and not blacklist[spellId] and not is_placed ) then
                if CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) then
                    boss_buffs[spellId] = index
                end
            end
            index = index + 1
        end
        -- Place auras by priority
        -- Place user placed auras since we always have buff frames for them
        for spellId, index in next, user_placed_auras do
            local debuffFrame = debuffFrameRegister[frame].userPlaced[spellId].debuffFrame
            if debuffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, nil, false, false)
            end
        end
        -- Return early if not frames are set
        if numDebuffFrames == 0 then
            return
        end
        local frameNum = 1
        -- Set boss debuffs
        for spellId, index in next, boss_debuffs do
            if frameNum > numDebuffFrames then
                return
            end
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[frameNum]
            if debuffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, nil, true, false)
            end
            frameNum = frameNum + 1
        end
        -- Set boss buffs
        for spellId, index in next, boss_buffs do
            if frameNum > numDebuffFrames then
                return
            end
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[frameNum]
            if debuffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, nil, true, true)
            end
            frameNum = frameNum + 1
        end
        -- Set prio debuffs 
        for spellId, index in next, prio_debuffs do
            if frameNum > numDebuffFrames then
                return
            end
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[frameNum]
            if debuffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, nil, false, false)
            end
            frameNum = frameNum + 1
        end
        -- Set normal debuffs
        for spellId, index in next, debuffs do
            if frameNum > numDebuffFrames then
                return
            end
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[frameNum]
            if debuffFrame then -- When swapping from a profile with 0 auras this function can get called before the frames are created
                CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, nil, false, false)
            end
            frameNum = frameNum + 1
        end
        -- Hide left frames
        for i=frameNum, numDebuffFrames do
            local debuffFrame = debuffFrameRegister[frame].dynamicGroup[i]
            if debuffFrame then
                debuffFrame:Hide()
            end
        end
    end
    self:HookFuncFiltered("CompactUnitFrame_UpdateDebuffs", OnUpdateDebuffs)

    addon:IterateRoster(function(frame)
        OnFrameSetup(frame)
        OnUpdateDebuffs(frame)
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
           -- debuffFrame.border:SetTextureSliceMargins(0,0,0,0) -- FIXME backdrop for classic
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
            local stackText = debuffFrame.count
            stackText:ClearAllPoints()
            stackText:SetPoint("BOTTOMRIGHT", debuffFrame, "BOTTOMRIGHT", 0, 0)
            fontObj:SetFontObject("NumberFontNormalSmall")
            stackText:SetFont(fontObj:GetFont())
            stackText:SetTextColor(fontObj:GetTextColor())
            stackText:SetShadowColor(fontObj:GetShadowColor())
            stackText:SetShadowOffset(fontObj:GetShadowOffset())
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
