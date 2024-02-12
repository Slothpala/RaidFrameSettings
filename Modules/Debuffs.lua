--[[
    Created by Slothpala 
    The aura indicator position and the aura timers are greatly inspired by a pull request from: https://github.com/excorp
--]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
local Debuffs = addon:NewModule("Debuffs")
Mixin(Debuffs, addonTable.hooks)
local CDT = addonTable.cooldownText
local Media = LibStub("LibSharedMedia-3.0")

--Debuffframe size
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
local IsForbidden = IsForbidden
--Lua
local next = next

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
    --blacklist
    local blacklist = {}
    for spellId, value in pairs(addon.db.profile.Debuffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end
	--increase
    local increase = {}
    for spellId, value in pairs(addon.db.profile.Debuffs.Increase) do
        increase[tonumber(spellId)] = true
    end
    --user placed 
    local userPlaced = {} --i will bring this at a later date for Debuffs including position and size
    local userPlacedIdx = 1
    local maxUserPlaced = 0
    for _, auraInfo in pairs(addon.db.profile.Debuffs.AuraPosition) do
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
            debuffFrame.border:SetTexture("Interface/AddOns/RaidFrameSettings/Textures/DebuffOverlay_clean_icons.tga")
            debuffFrame.border:SetTexCoord(0,1,0,1)
            debuffFrame.border:SetTextureSliceMargins(5.01, 26.09, 5.01, 26.09) 
            debuffFrame.border:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
        end
    else
        resizeDebuffFrame = function(debuffFrame)
            debuffFrame:SetSize(width, height)
        end
    end
    --Debuffframe position
    local point = addon:ConvertDbNumberToPosition(frameOpt.point)
    local relativePoint = addon:ConvertDbNumberToPosition(frameOpt.relativePoint)
    local followPoint, followRelativePoint = addon:GetAuraGrowthOrientationPoints(frameOpt.orientation)

    local onSetDeuff = function(debuffFrame, aura)
        if debuffFrame:IsForbidden() or not debuffFrame:IsVisible() then --not sure if this is still neede but when i created it at the start if dragonflight it was
            return
        end
        local cooldown = debuffFrame.cooldown
        -- If buffFrame.cooldown is not present, the frame has not been modified by the addon.
        if not cooldown.count then
            return
        end
        CDT:StartCooldownText(cooldown)
        cooldown:SetDrawEdge(frameOpt.edge)
        if aura and (aura.isBossAura or increase[aura.spellId]) then
            debuffFrame:SetSize(boss_width, boss_height)
        else
            debuffFrame:SetSize(width, height)
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetDebuff", onSetDeuff)

    local function onUpdatePrivateAuras(frame)
        if not frame.PrivateAuraAnchors or not frame_registry[frame] or frame:IsForbidden() or not frame:IsVisible()then
            return
        end

        local lastShownDebuff
        for i = frame_registry[frame].maxDebuffs, 1, -1 do
            local debuff = frame.debuffFrames[i] or frame_registry[frame].extraDebuffFrames[i]
            if debuff and debuff:IsShown() then
                lastShownDebuff = debuff
                break
            end
        end
        frame.PrivateAuraAnchor1:ClearAllPoints()
        if lastShownDebuff then
            frame.PrivateAuraAnchor1:SetPoint(followPoint, lastShownDebuff, followRelativePoint, 0, 0)
        else
            frame.PrivateAuraAnchor1:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
        end
        frame.PrivateAuraAnchor2:ClearAllPoints()
        frame.PrivateAuraAnchor2:SetPoint(followPoint, frame.PrivateAuraAnchor1, followRelativePoint, 0, 0)
    end
    self:HookFunc("CompactUnitFrame_UpdatePrivateAuras", onUpdatePrivateAuras)

    local onHideAllDebuffs = function(frame)
        if not frame_registry[frame] or frame:IsForbidden() or not frame:IsVisible() then
            return
        end

        -- set placed aura / other aura
        local frameNum = 1
        frame.debuffs:Iterate(function(auraInstanceID, aura)
            if userPlaced[aura.spellId] then
                local idx = frame_registry[frame].placedAuraStart + userPlaced[aura.spellId].idx - 1
                local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
                CompactUnitFrame_UtilSetDebuff(debuffFrame, aura)
                return false
            end

            if blacklist[aura.spellId] then
                return false
            end

            if frameNum <= frame_registry[frame].maxDebuffs then
                local debuffFrame = frame.debuffFrames[frameNum] or frame_registry[frame].extraDebuffFrames[frameNum]
                CompactUnitFrame_UtilSetDebuff(debuffFrame, aura)
                frameNum = frameNum + 1
            end
            return false
        end)

        -- hide left aura frames
        for i = 1, maxUserPlaced do
            local idx = frame_registry[frame].placedAuraStart + i - 1
            local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
            if not debuffFrame.auraInstanceID or not frame.debuffs[debuffFrame.auraInstanceID] then
                debuffFrame:Hide()
                CooldownFrame_Clear(debuffFrame.cooldown)
            end
        end
        for i = frameNum, frame_registry[frame].maxDebuffs do
            local debuffFrame = frame.debuffFrames[i] or frame_registry[frame].extraDebuffFrames[i]
            debuffFrame:Hide()
            CooldownFrame_Clear(debuffFrame.cooldown)
        end

        onUpdatePrivateAuras(frame)
    end
    self:HookFunc("CompactUnitFrame_HideAllDebuffs", onHideAllDebuffs)

    local function onFrameSetup(frame)
        if frame.maxDebuffs == 0 or not frame.debuffs then
            return
        end

        if not frame_registry[frame] then
            frame_registry[frame] = {
                maxDebuffs        = frameOpt.maxdebuffs,
                placedAuraStart   = 0,
                lockdown          = false,
                dirty             = true,
                extraDebuffFrames = {},
            }
        end

        if InCombatLockdown() then
            frame_registry[frame].lockdown = true
            return
        end
        frame_registry[frame].lockdown = false

        if frame_registry[frame].dirty then
            frame_registry[frame].maxDebuffs = frameOpt.maxdebuffs
            frame_registry[frame].dirty = false

            local placedAuraStart = frame.maxDebuffs + 1
            for i = frame.maxDebuffs + 1, frame_registry[frame].maxDebuffs do
                local debuffFrame = frame.debuffFrames[i] or frame_registry[frame].extraDebuffFrames[i]
                if not debuffFrame then
                    debuffFrame = CreateFrame("Button", nil, nil, "CompactDebuffTemplate")
                    debuffFrame:SetParent(frame)
                    debuffFrame:Hide()
                    debuffFrame.baseSize = width
                    debuffFrame.maxHeight = width
                    debuffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraDebuffFrames[i] = debuffFrame
                end
                debuffFrame.icon:SetTexCoord(0, 1, 0, 1)
                debuffFrame.border:SetTexture("Interface/Buttons/UI-Debuff-Overlays")
                debuffFrame.border:SetTexCoord(0.296875,0.5703125,0,0.515625)
                debuffFrame.border:SetTextureSliceMargins(0,0,0,0)
                placedAuraStart = i + 1
            end
            frame_registry[frame].placedAuraStart = placedAuraStart

            for _, place in pairs(userPlaced) do
                local idx = placedAuraStart + place.idx - 1
                local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
                if not debuffFrame then
                    debuffFrame = CreateFrame("Button", nil, nil, "CompactBuffTemplate")
                    debuffFrame:SetParent(frame)
                    debuffFrame:Hide()
                    debuffFrame.baseSize = width
                    debuffFrame.maxHeight = width
                    debuffFrame.cooldown:SetHideCountdownNumbers(true)
                    frame_registry[frame].extraDebuffFrames[idx] = debuffFrame
                end
                debuffFrame.icon:SetTexCoord(0, 1, 0, 1)
                debuffFrame.border:SetTexture("Interface/Buttons/UI-Debuff-Overlays")
                debuffFrame.border:SetTexCoord(0.296875,0.5703125,0,0.515625)
                debuffFrame.border:SetTextureSliceMargins(0,0,0,0)
            end

            for i = 1, frame_registry[frame].maxDebuffs + maxUserPlaced do
                local debuffFrame = frame_registry[frame].extraDebuffFrames[i] or frame.debuffFrames[i]
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
            end
        end

        -- set anchor and resize
        local anchorSet, prevFrame
        for i = 1, frame_registry[frame].maxDebuffs do
            local debuffFrame = frame.debuffFrames[i] or frame_registry[frame].extraDebuffFrames[i]
            if not anchorSet then
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(point, frame, relativePoint, frameOpt.xOffset, frameOpt.yOffset)
                anchorSet = true
            else
                debuffFrame:ClearAllPoints()
                debuffFrame:SetPoint(followPoint, prevFrame, followRelativePoint, 0, 0)
            end
            prevFrame = debuffFrame
            resizeDebuffFrame(debuffFrame)
        end
        for _, place in pairs(userPlaced) do
            local idx = frame_registry[frame].placedAuraStart + place.idx - 1
            local debuffFrame = frame_registry[frame].extraDebuffFrames[idx]
            debuffFrame:ClearAllPoints()
            debuffFrame:SetPoint(place.point, frame, place.relativePoint, place.xOffset, place.yOffset)
            resizeDebuffFrame(debuffFrame)
        end

        onHideAllDebuffs(frame)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", onFrameSetup)

    for _, v in pairs(frame_registry) do
        v.dirty = true
    end
    addon:IterateRoster(function(frame)
        onFrameSetup(frame)
        CompactUnitFrame_UpdateAuras(frame)
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
function Debuffs:OnDisable()
    self:DisableHooks()
    local restoreDebuffFrames = function(frame)
        -- The add-on will only restore frames that it has modified.
        if not frame_registry[frame] then
            return
        end
        frame_registry[frame].dirty = true
        for _, debuffFrame in pairs(frame.debuffFrames) do
            debuffFrame:Hide()
        end
        for _, extraDebuffFrame in pairs(frame_registry[frame].extraDebuffFrames) do
            extraDebuffFrame:Hide()
        end

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
            debuffFrame:SetFrameStrata(frame:GetFrameStrata())
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
    addon:IterateRoster(restoreDebuffFrames)
end
