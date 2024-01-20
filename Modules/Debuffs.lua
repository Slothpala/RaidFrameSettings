--[[
    Created by Slothpala 
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local Debuffs = RaidFrameSettings:NewModule("Debuffs")
Mixin(Debuffs, addonTable.hooks)
local Media                                   = LibStub("LibSharedMedia-3.0")

--Debuffframe size
local SetSize = SetSize
local IsForbidden = IsForbidden
local ClearAllPoints = ClearAllPoints
local SetPoint = SetPoint
local SetTexture = SetTexture
local SetTexCoord = SetTexCoord
local SetTextureSliceMargins = SetTextureSliceMargins
local SetTextureSliceMode  = SetTextureSliceMode
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local AuraUtil_ForEachAura                    = AuraUtil.ForEachAura

local frame_registry = {}

function Debuffs:HookFrame(frame)
    self:RemoveHandler(frame, "OnEvent")
    self:HookScript(frame, "OnEvent", function(frame, event, unit, updateInfo)
        if event ~= "PLAYER_REGEN_ENABLED" then
            return
        end
        if frame_registry[frame] and frame_registry[frame].lockdown then
            DefaultCompactUnitFrameSetup(frame)
        end
    end)
end

function Debuffs:OnEnable()
        --Debuffframe size
    local width = RaidFrameSettings.db.profile.Debuffs.Display.width
    local height = RaidFrameSettings.db.profile.Debuffs.Display.height
    local resizeAura
    local increase = RaidFrameSettings.db.profile.Debuffs.Display.increase
    local boss_width  = width * increase
    local boss_height = height * increase
    if RaidFrameSettings.db.profile.Debuffs.Display.clean_icons then
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
        resizeAura = function(debuffFrame)
            debuffFrame:SetSize(width, height)
            debuffFrame.icon:SetTexCoord(left,right,top,bottom)
            debuffFrame.border:SetTexture("Interface/AddOns/RaidFrameSettings/Textures/DebuffOverlay_clean_icons.tga")
            debuffFrame.border:SetTexCoord(0,1,0,1)
            debuffFrame.border:SetTextureSliceMargins(5.01, 26.09, 5.01, 26.09) 
            debuffFrame.border:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
        end
    else
        resizeAura = function(debuffFrame)
            debuffFrame:SetSize(width, height)
        end
    end
    --Debuffframe position
    local point = RaidFrameSettings.db.profile.Debuffs.Display.point
    point = ( point == 1 and "TOPLEFT" ) or ( point == 2 and "TOPRIGHT" ) or ( point == 3 and "BOTTOMLEFT" ) or ( point == 4 and "BOTTOMRIGHT" ) 
    local relativePoint = RaidFrameSettings.db.profile.Debuffs.Display.relativePoint
    relativePoint = ( relativePoint == 1 and "TOPLEFT" ) or ( relativePoint == 2 and "TOPRIGHT" ) or ( relativePoint == 3 and "BOTTOMLEFT" ) or ( relativePoint == 4 and "BOTTOMRIGHT" ) 
    local orientation = RaidFrameSettings.db.profile.Debuffs.Display.orientation
    -- 1==LEFT, 2==RIGHT, 3==UP, 4==DOWN
    -- LEFT == "BOTTOMRIGHT","BOTTOMLEFT"; RIGHT == "BOTTOMLEFT","BOTTOMRIGHT"; UP == "BOTTOMLEFT","TOPLEFT"; DOWN = "TOPLEFT","BOTTOMLEFT"
    local debuffPoint = ( orientation == 1 and "BOTTOMRIGHT" ) or ( orientation == 2 and "BOTTOMLEFT" ) or ( orientation == 3 and "BOTTOMLEFT" ) or ( orientation == 4 and "TOPLEFT" ) 
    local debuffRelativePoint = ( orientation == 1 and "BOTTOMLEFT" ) or ( orientation == 2 and "BOTTOMRIGHT" ) or ( orientation == 3 and "TOPLEFT" ) or ( orientation == 4 and "BOTTOMLEFT" ) 
    local x_offset = RaidFrameSettings.db.profile.Debuffs.Display.x_offset
    local y_offset = RaidFrameSettings.db.profile.Debuffs.Display.y_offset
    local maxDebuffs = RaidFrameSettings.db.profile.Debuffs.Display.maxdebuffs
    local framestrataIdx = RaidFrameSettings.db.profile.Debuffs.Display.framestrata
    local framestrata = (framestrataIdx == 1 and "Inherited") or
        (framestrataIdx == 2 and "BACKGROUND") or (framestrataIdx == 3 and "LOW") or (framestrataIdx == 4 and "MEDIUM") or
        (framestrataIdx == 5 and "HIGH") or (framestrataIdx == 6 and "DIALOG") or (framestrataIdx == 7 and "FULLSCREEN") or
        (framestrataIdx == 8 and "FULLSCREEN_DIALOG") or (framestrataIdx == 9 and "TOOLTIP")

    local edge = RaidFrameSettings.db.profile.Debuffs.Display.edge
    local swipe = RaidFrameSettings.db.profile.Debuffs.Display.swipe
    local reverse = RaidFrameSettings.db.profile.Debuffs.Display.reverse
    local showCdnum = RaidFrameSettings.db.profile.Debuffs.Display.showCdnum

    local dbObj = RaidFrameSettings.db.profile.Debuffs.Display.Duration
    local Duration = {
        Font        = Media:Fetch("font", dbObj.font),
        FontSize    = dbObj.fontsize,
        DebuffColor = dbObj.usedebuffcolor,
        FontColor   = dbObj.fontcolor,
        ShadowColor = dbObj.shadowColor,
        ShadowXoffset = dbObj.shadow_x_offset,
        ShadowYoffset = dbObj.shadow_y_offset,
        OutlineMode = (dbObj.thick and "THICK" or "") ..
        (dbObj.outline and "OUTLINE" or "") .. ", " .. (dbObj.monochrome and "MONOCHROME" or ""),
        Position    = (dbObj.position == 1 and "TOPLEFT") or (dbObj.position == 2 and "TOP") or
            (dbObj.position == 3 and "TOPRIGHT")
            or (dbObj.position == 4 and "LEFT") or (dbObj.position == 5 and "CENTER") or
            (dbObj.position == 6 and "RIGHT")
            or (dbObj.position == 7 and "BOTTOMLEFT") or (dbObj.position == 8 and "BOTTOM") or
            (dbObj.position == 9 and "BOTTOMRIGHT"),
        JustifyH    = (dbObj.justifyH == 1 and "LEFT") or (dbObj.justifyH == 2 and "CENTER") or (dbObj.justifyH == 3 and "RIGHT"),
        JustifyV    = (dbObj.justifyV == 1 and "TOP") or (dbObj.justifyV == 2 and "MIDDLE") or (dbObj.justifyV == 3 and "BOTTOM"),
        X_Offset    = dbObj.x_offset,
        Y_Offset    = dbObj.y_offset,
    }

    dbObj = RaidFrameSettings.db.profile.Debuffs.Display.Stacks
    local Stacks = {
        Font        = Media:Fetch("font", dbObj.font),
        FontSize    = dbObj.fontsize,
        DebuffColor = dbObj.usedebuffcolor,
        FontColor   = dbObj.fontcolor,
        ShadowColor = dbObj.shadowColor,
        ShadowXoffset = dbObj.shadow_x_offset,
        ShadowYoffset = dbObj.shadow_y_offset,
        OutlineMode = (dbObj.thick and "THICK" or "") ..
        (dbObj.outline and "OUTLINE" or "") .. ", " .. (dbObj.monochrome and "MONOCHROME" or ""),
        Position    = (dbObj.position == 1 and "TOPLEFT") or (dbObj.position == 2 and "TOP") or
            (dbObj.position == 3 and "TOPRIGHT")
            or (dbObj.position == 4 and "LEFT") or (dbObj.position == 5 and "CENTER") or
            (dbObj.position == 6 and "RIGHT")
            or (dbObj.position == 7 and "BOTTOMLEFT") or (dbObj.position == 8 and "BOTTOM") or
            (dbObj.position == 9 and "BOTTOMRIGHT"),
        JustifyH    = (dbObj.justifyH == 1 and "LEFT") or (dbObj.justifyH == 2 and "CENTER") or (dbObj.justifyH == 3 and "RIGHT"),
        JustifyV    = (dbObj.justifyV == 1 and "TOP") or (dbObj.justifyV == 2 and "MIDDLE") or (dbObj.justifyV == 3 and "BOTTOM"),
        X_Offset    = dbObj.x_offset,
        Y_Offset    = dbObj.y_offset,
    }


    local debuffColors = {
        Curse   = { r = 0.6, g = 0.0, b = 1.0 },
        Disease = { r = 0.6, g = 0.4, b = 0.0 },
        Magic   = { r = 0.2, g = 0.6, b = 1.0 },
        Poison  = { r = 0.0, g = 0.6, b = 0.0 },
        Bleed   = { r = 0.8, g = 0.0, b = 0.0 },
    }
    local Bleeds = addonTable.Bleeds

    dbObj = RaidFrameSettings.db.profile.AuraHighlight.DebuffColors
    debuffColors.Curse = dbObj.Curse
    debuffColors.Disease = dbObj.Disease
    debuffColors.Magic = dbObj.Magic
    debuffColors.Poison = dbObj.Poison
    debuffColors.Bleed = dbObj.Bleed

    --blacklist
    local blacklist = {}
    for spellId, value in pairs(RaidFrameSettings.db.profile.Debuffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end
    
    local function updateAnchors(frame, endingIndex)
        local first, prev, isBossAura
        for i = 1, endingIndex and endingIndex > #frame.debuffFrames and #frame.debuffFrames or endingIndex or #frame.debuffFrames do
            if frame.debuffFrames[i]:IsShown() and not frame.debuffFrames[i]:IsForbidden() then
                if not first then
                    frame.debuffFrames[i]:ClearAllPoints()
                    frame.debuffFrames[i]:SetPoint(point, frame, relativePoint, x_offset, y_offset)
                    prev = frame.debuffFrames[i]
                    first = frame.debuffFrames[i]
                else
                    frame.debuffFrames[i]:ClearAllPoints()
                    frame.debuffFrames[i]:SetPoint(debuffPoint, prev, debuffRelativePoint, 0, 0)
                    isBossAura = frame.debuffFrames[i].isBossAura or isBossAura
                    prev = frame.debuffFrames[i]
                end
            end
        end
        if first and not first.isBossAura and isBossAura then
            if (point == 1 or point == 2) and (orientation == 1 or orientation == 2) then
                first:SetPoint(point, frame, relativePoint, x_offset, y_offset + width - boss_width)
            elseif (point == 2 or point == 4) and (orientation == 3 or orientation == 4) then
                first:SetPoint(point, frame, relativePoint, x_offset - boss_width + width, y_offset)
            end
        end
    end
    local function hideAllDebuffs(frame)
        if frame.debuffFrames and frame.debuffs then
            local frameNum = 1
            frame.debuffs:Iterate(function(auraInstanceID, aura)
                if frameNum > maxDebuffs then
					return true
				end
				if CompactUnitFrame_IsAuraInstanceIDBlocked(frame, auraInstanceID) then
					return false
				end
                if blacklist[aura.spellId] then
                    return false
                end
				local debuffFrame = frame.debuffFrames[frameNum]
				CompactUnitFrame_UtilSetDebuff(debuffFrame, aura)
				frameNum = frameNum + 1
				return false
			end)
            for i = frameNum, #frame.debuffFrames do
                frame.debuffFrames[i]:Hide()
                CooldownFrame_Clear(frame.debuffFrames[i].cooldown)
            end
            updateAnchors(frame, frameNum - 1)
        end
    end
    self:HookFunc("CompactUnitFrame_HideAllDebuffs", hideAllDebuffs)

    local function updatePrivateAuras(frame)
        if not frame.PrivateAuraAnchors then
            return
        end

        local lastShownDebuff;
        for i = #frame.debuffFrames, 1, -1 do
            local debuff = frame.debuffFrames[i]
            if debuff:IsShown() then
                lastShownDebuff = debuff
                break
            end
        end
        frame.PrivateAuraAnchor1:ClearAllPoints()
        if lastShownDebuff then
            frame.PrivateAuraAnchor1:SetPoint(debuffPoint, lastShownDebuff, debuffRelativePoint, 0, 0)
        else
            frame.PrivateAuraAnchor1:SetPoint(point, frame.Debuff1, relativePoint, 0, 0)
        end
        frame.PrivateAuraAnchor2:ClearAllPoints()
        frame.PrivateAuraAnchor2:SetPoint(debuffPoint, frame.PrivateAuraAnchor1, debuffRelativePoint, 0, 0)
    end
    self:HookFunc("CompactUnitFrame_UpdatePrivateAuras", updatePrivateAuras)

    local function GetTimerText(remain)
        if remain < 0 then
            return ""
        elseif remain < 100 then
            return Round(remain)
        elseif remain < 570 then
            return string.format("%dm", Round(remain / 60))
        elseif remain < 34200 then
            return string.format("%dh", Round(remain / 3600))
        else
            return string.format("%dd", Round(remain / 86400))
        end
    end
    local createDebuffFrames = function(frame)
        if not frame_registry[frame] then
            self:HookFrame(frame)
            frame_registry[frame] = {
                lockdown = false,
                dirty    = true,
            }
        end

        if frame_registry[frame].dirty then
            if InCombatLockdown() then
                frame_registry[frame].lockdown = true
                return
            end

            frame_registry[frame].lockdown = false
            frame_registry[frame].dirty = false

            -- 프레임 생성
            if maxDebuffs > frame.maxDebuffs then
                local frameName = frame:GetName() .. "Debuff"
                for i = frame.maxDebuffs + 1, maxDebuffs do
                    local child = _G[frameName .. i] 
                    if not child then
                        child = CreateFrame("Button", frameName .. i, frame, "CompactDebuffTemplate")
                        child:Hide()
                        child:SetPoint("BOTTOMLEFT", _G[frameName .. i - 1], "BOTTOMRIGHT")
                    end
                    if not frame.debuffFrames[i] then
                        frame.debuffFrames[i] = child
                    end
                    frame["Debuff" .. i] = child
                end
            end

            -- 설정 변경
            if framestrata == "Inherited" then
                framestrata = frame:GetFrameStrata()
            end

            for i = 1, #frame.debuffFrames do
                local debuffFrame = frame.debuffFrames[i]
                resizeAura(debuffFrame)
                debuffFrame:SetFrameStrata(framestrata)

                local cooldown = debuffFrame.cooldown
                if not cooldown.original then
                    cooldown.original = {
                        edge = cooldown:GetDrawEdge(),
                        swipe = cooldown:GetDrawSwipe(),
                        reverse = cooldown:GetReverse(),
                        noCooldownCount = cooldown.noCooldownCount
                    }
                end
                cooldown:SetDrawEdge(edge)
                cooldown:SetDrawSwipe(swipe)
                cooldown:SetReverse(reverse)
                cooldown.expirationTime = (cooldown:GetCooldownTimes() + cooldown:GetCooldownDuration()) / 1000

                local count = debuffFrame.count
                if not count.original then
                    local r, g, b, a = count:GetShadowColor()
                    local x, y = count:GetShadowOffset()
                    count.original = {
                        font = count:GetFontObject(),
                        justifyH = count:GetJustifyH(),
                        justifyV = count:GetJustifyV(),
                        shadowColor = { r = r, g = g, b = b, a = a },
                        shadowOffset = { x = x, y = y },
                    }
                end
                count:ClearAllPoints()
                count:SetPoint(Stacks.Position, Stacks.X_Offset, Stacks.Y_Offset)
                count:SetJustifyH(Stacks.JustifyH)
                count:SetJustifyV(Stacks.JustifyV)
                count:SetFont(Stacks.Font, Stacks.FontSize, Stacks.OutlineMode)
                count:SetShadowColor(Stacks.ShadowColor.r, Stacks.ShadowColor.g, Stacks.ShadowColor.b, Stacks.ShadowColor.a)
                count:SetShadowOffset(Stacks.ShadowXoffset, Stacks.ShadowYoffset)

                if not cooldown.text then
                    cooldown.text = cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
                    cooldown:SetScript("OnUpdate", function(s, t)
                        s.expirationTime = (cooldown:GetCooldownTimes() + cooldown:GetCooldownDuration()) / 1000
                        if s.expirationTime == 0 then
                            return
                        end
                        local left = GetTimerText(s.expirationTime - GetTime())
                        if s.left ~= left then
                            s.left = left
                            s.text:SetText(left or "")
                        end
                    end)
                end
                local text = cooldown.text
                text:ClearAllPoints()
                text:SetPoint(Duration.Position, Duration.X_Offset, Duration.Y_Offset)
                text:SetJustifyH(Duration.JustifyH)
                text:SetJustifyV(Duration.JustifyV)
                text:SetFont(Duration.Font, Duration.FontSize, Duration.OutlineMode)
                text:SetShadowColor(Duration.ShadowColor.r, Duration.ShadowColor.g, Duration.ShadowColor.b, Duration.ShadowColor.a)
                text:SetShadowOffset(Duration.ShadowXoffset, Duration.ShadowYoffset)
                text:SetText(GetTimerText(cooldown.expirationTime - GetTime()))
                if showCdnum then
                    text:Show()
                    if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
                        OmniCC.Cooldown.SetNoCooldownCount(cooldown, true)
                    end
                else
                    text:Hide()
                end
            end

            if frame.PrivateAuraAnchors then
                for _, privateAuraAnchor in ipairs(frame.PrivateAuraAnchors) do
                    privateAuraAnchor:SetSize(boss_width, boss_height)
                    privateAuraAnchor:SetFrameStrata(framestrata)
                end
            end
        end
        hideAllDebuffs(frame)
        updateAnchors(frame)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", createDebuffFrames)


    local utilSetDebuff = function(debuffFrame, aura)
        if debuffFrame:IsForbidden() or not aura then
            return
        end
        debuffFrame.isBossAura = aura.isBossAura
        if aura and aura.isBossAura then
            debuffFrame:SetSize(boss_width, boss_height)
        else
            debuffFrame:SetSize(width, height)
        end

        if debuffFrame.cooldown.text then
            local color = Duration.FontColor
            if Duration.DebuffColor then
                if aura.dispelName then
                    color = debuffColors[aura.dispelName]
                end
                if Bleeds[aura.spellId] then
                    color = debuffColors.Bleed
                end
            end
            debuffFrame.cooldown.text:SetVertexColor(color.r, color.g, color.b)
            debuffFrame.border:SetVertexColor(color.r, color.g, color.b)
        end

        local color = Stacks.FontColor
        if Stacks.DebuffColor then
            if aura.dispelName then
                color = debuffColors[aura.dispelName]
            end
            if Bleeds[aura.spellId] then
                color = debuffColors.Bleed
            end
        end
        debuffFrame.count:SetVertexColor(color.r, color.g, color.b)

        local cooldown = debuffFrame.cooldown
        cooldown.expirationTime = (cooldown:GetCooldownTimes() + cooldown:GetCooldownDuration()) / 1000
        cooldown.text:SetText(GetTimerText(cooldown.expirationTime - GetTime()))
    end
    self:HookFunc("CompactUnitFrame_UtilSetDebuff", utilSetDebuff)

    for _, v in pairs(frame_registry) do
        v.dirty = true
    end

    RaidFrameSettings:IterateRoster(function(frame)
        createDebuffFrames(frame)
        if frame.debuffFrames then
            for i=1, #frame.debuffFrames do
                local debuffFrame = frame.debuffFrames[i]
                if debuffFrame.auraInstanceID then
                    local aura = C_UnitAuras_GetAuraDataByAuraInstanceID(frame.unit, debuffFrame.auraInstanceID)
                    utilSetDebuff(debuffFrame, aura)
                end
            end
        end
        updateAnchors(frame)
    end)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Debuffs:OnDisable()
    self:DisableHooks()
    local restoreDebuffFrames = function(frame)
        if not frame_registry[frame] then
            return
        end
        frame_registry[frame] = nil

        local frameWidth = frame:GetWidth()
        local frameHeight = frame:GetHeight()
        local componentScale = min(frameWidth / NATIVE_UNIT_FRAME_HEIGHT, frameWidth / NATIVE_UNIT_FRAME_WIDTH)
        local buffSize = math.min(15, 11 * componentScale)
        local powerBarUsedHeight = frame.powerBar:IsShown() and frame.powerBar:GetHeight() or 0
        local maxDebuffSize = math.min(20, frameHeight - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE);
        for i=1,#frame.debuffFrames do  
            frame.debuffFrames[i]:SetSize(buffSize, buffSize)
        end
        local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight
        frame.debuffFrames[1]:ClearAllPoints()
        frame.debuffFrames[1]:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset)
        for i=1, #frame.debuffFrames do
            frame.debuffFrames[i].border:SetTexture("Interface\\BUTTONS\\UI-Debuff-Overlays")
            frame.debuffFrames[i].border:SetTexCoord(0.296875, 0, 0.296875, 0.515625, 0.5703125, 0, 0.5703125, 0.515625)
            frame.debuffFrames[i].border:SetTextureSliceMargins(0,0,0,0)
            frame.debuffFrames[i].icon:SetTexCoord(0,1,0,1)
            if ( i > 1 ) then
                frame.debuffFrames[i]:ClearAllPoints();
                frame.debuffFrames[i]:SetPoint(debuffPos, frame.debuffFrames[i - 1], debuffRelativePoint, 0, 0);
            end
            frame.debuffFrames[i]:SetFrameStrata(frame:GetFrameStrata())
            -- frame.debuffFrames[i]:SetFrameLevel(frame:GetFrameLevel() + 1)

            local cooldown = frame.debuffFrames[i].cooldown
            cooldown:SetDrawEdge(cooldown.original.edge)
            cooldown:SetDrawSwipe(cooldown.original.swipe)
            cooldown:SetReverse(cooldown.original.reverse)
            cooldown.text:Hide()
            if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
                OmniCC.Cooldown.SetNoCooldownCount(cooldown, cooldown.original.noCooldownCount)
            end

            local count = frame.debuffFrames[i].count
            count:ClearAllPoints()
            count:SetPoint("BOTTOMRIGHT", 5, 0)
            count:SetFont(count.original.font:GetFont())
            count:SetJustifyH(count.original.justifyH)
            count:SetJustifyV(count.original.justifyV)
            count:SetShadowColor(count.original.shadowColor.r, count.original.shadowColor.g, count.original.shadowColor.b, count.original.shadowColor.a)
            count:SetShadowOffset(count.original.shadowOffset.x, count.original.shadowOffset.y)
        end
        if frame.PrivateAuraAnchors then
            for _, privateAuraAnchor in ipairs(frame.PrivateAuraAnchors) do
                local size = min(buffSize + BOSS_DEBUFF_SIZE_INCREASE, maxDebuffSize)
                privateAuraAnchor:SetSize(size, size)
                privateAuraAnchor:SetFrameStrata(frame:GetFrameStrata())
            end
        end
    end
    RaidFrameSettings:IterateRoster(restoreDebuffFrames)
end
