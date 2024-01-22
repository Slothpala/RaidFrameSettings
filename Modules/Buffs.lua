--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local Buffs = RaidFrameSettings:NewModule("Buffs")
Mixin(Buffs, addonTable.hooks)
local Media = LibStub("LibSharedMedia-3.0")

local SetSize = SetSize
local SetTexCoord = SetTexCoord
local ClearAllPoints = ClearAllPoints
local SetPoint = SetPoint

local frame_registry = {}

function Buffs:OnEnable()
    --Buff size
    local width  = RaidFrameSettings.db.profile.Buffs.Display.width
    local height = RaidFrameSettings.db.profile.Buffs.Display.height
    local resizeAura
    if RaidFrameSettings.db.profile.Buffs.Display.clean_icons then
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
        resizeAura = function(buffFrame)
            buffFrame:SetSize(width, height)
            buffFrame.icon:SetTexCoord(left,right,top,bottom)
        end
    else
        resizeAura = function(buffFrame)
            buffFrame:SetSize(width, height)
        end
    end
    --Buffframe position
    local point = RaidFrameSettings.db.profile.Buffs.Display.point
    point = ( point == 1 and "TOPLEFT" ) or ( point == 2 and "TOPRIGHT" ) or ( point == 3 and "BOTTOMLEFT" ) or ( point == 4 and "BOTTOMRIGHT" ) 
    local relativePoint = RaidFrameSettings.db.profile.Buffs.Display.relativePoint
    relativePoint = ( relativePoint == 1 and "TOPLEFT" ) or ( relativePoint == 2 and "TOPRIGHT" ) or ( relativePoint == 3 and "BOTTOMLEFT" ) or ( relativePoint == 4 and "BOTTOMRIGHT" ) 
    local orientation = RaidFrameSettings.db.profile.Buffs.Display.orientation
    -- 1==LEFT, 2==RIGHT, 3==UP, 4==DOWN
    -- LEFT == "BOTTOMRIGHT","BOTTOMLEFT"; RIGHT == "BOTTOMLEFT","BOTTOMRIGHT"; UP == "BOTTOMLEFT","TOPLEFT"; DOWN = "TOPLEFT","BOTTOMLEFT"
    local buffPoint = ( orientation == 1 and "BOTTOMRIGHT" ) or ( orientation == 2 and "BOTTOMLEFT" ) or ( orientation == 3 and "BOTTOMLEFT" ) or ( orientation == 4 and "TOPLEFT" ) 
    local buffRelativePoint = ( orientation == 1 and "BOTTOMLEFT" ) or ( orientation == 2 and "BOTTOMRIGHT" ) or ( orientation == 3 and "TOPLEFT" ) or ( orientation == 4 and "BOTTOMLEFT" ) 
    local x_offset = RaidFrameSettings.db.profile.Buffs.Display.x_offset
    local y_offset = RaidFrameSettings.db.profile.Buffs.Display.y_offset
    local maxBuffsAuto = RaidFrameSettings.db.profile.Buffs.Display.maxbuffsAuto
    local maxBuffs = RaidFrameSettings.db.profile.Buffs.Display.maxbuffs
    local framestrataIdx = RaidFrameSettings.db.profile.Buffs.Display.framestrata
    local framestrata = (framestrataIdx == 1 and "Inherited") or
        (framestrataIdx == 2 and "BACKGROUND") or (framestrataIdx == 3 and "LOW") or (framestrataIdx == 4 and "MEDIUM") or
        (framestrataIdx == 5 and "HIGH") or
        (framestrataIdx == 6 and "DIALOG") or (framestrataIdx == 7 and "FULLSCREEN") or
        (framestrataIdx == 8 and "FULLSCREEN_DIALOG") or (framestrataIdx == 9 and "TOOLTIP")

    local edge = RaidFrameSettings.db.profile.Buffs.Display.edge
    local swipe = RaidFrameSettings.db.profile.Buffs.Display.swipe
    local reverse = RaidFrameSettings.db.profile.Buffs.Display.reverse
    local showCdnum = RaidFrameSettings.db.profile.Buffs.Display.showCdnum

    local dbObj = RaidFrameSettings.db.profile.Buffs.Display.Duration
    local Duration = {
        Font        = Media:Fetch("font", dbObj.font),
        FontSize    = dbObj.fontsize,
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

    dbObj = RaidFrameSettings.db.profile.Buffs.Display.Stacks
    local Stacks = {
        Font        = Media:Fetch("font", dbObj.font),
        FontSize    = dbObj.fontsize,
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

    local Position = {}
    local PositionIdx = 1
    for k, v in pairs(RaidFrameSettings.db.profile.Buffs.Position) do
        Position[tonumber(k)] = {
            idx = PositionIdx,
            point = (v.point == 1 and "TOPLEFT") or (v.point == 2 and "TOP") or (v.point == 3 and "TOPRIGHT") or
                (v.point == 4 and "LEFT") or (v.point == 5 and "CENTER") or (v.point == 6 and "RIGHT") or
                (v.point == 7 and "BOTTOMLEFT") or (v.point == 8 and "BOTTOM") or (v.point == 9 and "BOTTOMRIGHT"),
            x_offset = width * v.x + v.x_offset,
            y_offset = height * v.y + v.y_offset,
        }
        PositionIdx = PositionIdx + 1
    end
    local PositionMax = PositionIdx - 1

    --blacklist
    local blacklist = {}
    for spellId, value in pairs(RaidFrameSettings.db.profile.Buffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end

    local function updateAnchors(frame, endingIndex)
        local first = true
        local prev
        for i = 1, endingIndex and endingIndex > frame_registry[frame].positionStart and frame_registry[frame].positionStart or endingIndex or frame_registry[frame].positionStart do
            local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
            if first then
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, frame, relativePoint, x_offset, y_offset)
                prev = buffFrame
                first = false
            else
                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(buffPoint, prev, buffRelativePoint, 0, 0)
                prev = buffFrame
            end
            resizeAura(buffFrame)
        end
        for _, v in pairs(Position) do
            local buffFrame = frame_registry[frame].extraBuffFrames[frame_registry[frame].positionStart + v.idx]
            buffFrame:ClearAllPoints()
            buffFrame:SetPoint(v.point, frame, v.point, v.x_offset, v.y_offset)
            resizeAura(buffFrame)
        end
    end
    local hideAllBuffs = function(frame)
        if frame.buffFrames and frame.buffs and frame_registry[frame] and frame:IsVisible() then
            local idx = frame_registry[frame].positionStart + 1
            while frame_registry[frame].extraBuffFrames[idx] do
                local buffFrame = frame_registry[frame].extraBuffFrames[idx]
                buffFrame:Hide()
                CooldownFrame_Clear(buffFrame.cooldown)
                idx = idx + 1
            end
            frame.buffs:Iterate(function(auraInstanceID, aura)
                if Position[aura.spellId] then
                    local idx = frame_registry[frame].positionStart + Position[aura.spellId].idx
                    local buffFrame = frame_registry[frame].extraBuffFrames[idx]
                    CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                    return false
                end
            end)

            local frameNum = 1
            frame.buffs:Iterate(function(auraInstanceID, aura)
                if frameNum > frame_registry[frame].maxBuffs then
                    return true
                end
                if blacklist[aura.spellId] or Position[aura.spellId] then
                    return false
                end
                local buffFrame = frame.buffFrames[frameNum] or frame_registry[frame].extraBuffFrames[frameNum]
                CompactUnitFrame_UtilSetBuff(buffFrame, aura)
                frameNum = frameNum + 1
                return false
            end)
            for i = frameNum, frame_registry[frame].positionStart do
                local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
                buffFrame:Hide()
                CooldownFrame_Clear(buffFrame.cooldown)
            end
        end
    end
    self:HookFunc("CompactUnitFrame_HideAllBuffs", hideAllBuffs)

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
    local createBuffFrames = function(frame)
        if frame.updateAllEvent == "UNIT_PET" or frame.maxBuffs == 0 then
            return
        end

        if not frame_registry[frame] then
            frame_registry[frame] = {
                maxBuffs        = maxBuffsAuto and frame.maxBuffs or maxBuffs,
                positionStart   = 0,
                lockdown        = false,
                dirty           = true,
                extraBuffFrames = {},
            }
        end

        if frame_registry[frame].dirty then
            frame_registry[frame].maxBuffs = maxBuffsAuto and frame.maxBuffs or maxBuffs
            local frameMaxBuffs = frame_registry[frame].maxBuffs

            if InCombatLockdown() then
                frame_registry[frame].lockdown = true
                return
            end

            frame_registry[frame].lockdown = false
            frame_registry[frame].dirty = false
            frame_registry[frame].positionStart = math.max(#frame.buffFrames, frameMaxBuffs)

            if frameMaxBuffs > #frame.buffFrames then
                for i = #frame.buffFrames + 1, frameMaxBuffs do
                    local child = frame_registry[frame].extraBuffFrames[i]
                    if not child then
                        child = CreateFrame("Button", nil, nil, "CompactBuffTemplate")
                        child:Hide()
                        child.cooldown:SetHideCountdownNumbers(true)
                        frame_registry[frame].extraBuffFrames[i] = child
                    end
                end
            end
            if PositionMax > 0 then
                for i = 1, PositionMax do
                    local idx = frame_registry[frame].positionStart + i
                    local child = frame_registry[frame].extraBuffFrames[idx]
                    if not child then
                        child = CreateFrame("Button", nil, nil, "CompactBuffTemplate")
                        child:SetParent(frame)
                        child:Hide()
                        child.cooldown:SetHideCountdownNumbers(true)
                        frame_registry[frame].extraBuffFrames[idx] = child
                    end
                end
            end

            if framestrata == "Inherited" then
                framestrata = frame:GetFrameStrata()
            end

            for i = 1, frame_registry[frame].positionStart + PositionMax do
                local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
                resizeAura(buffFrame)
                buffFrame:SetFrameStrata(framestrata)

                local cooldown = buffFrame.cooldown
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

                local count = buffFrame.count
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
                count.fontobj = count:GetFontObject()
                count:SetFont(Stacks.Font, Stacks.FontSize, Stacks.OutlineMode)
                count:SetVertexColor(Stacks.FontColor.r, Stacks.FontColor.g, Stacks.FontColor.b)
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
                text:SetVertexColor(Duration.FontColor.r, Duration.FontColor.g, Duration.FontColor.b)
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
                    if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
                        OmniCC.Cooldown.SetNoCooldownCount(cooldown, cooldown.original.noCooldownCount)
                    end
                end
            end
        end
        updateAnchors(frame)
        hideAllBuffs(frame)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", createBuffFrames)
    local utilSetBuff = function(buffFrame, aura)
        if buffFrame:IsForbidden() or not buffFrame:IsVisible() then
            return
        end
        local frame = buffFrame:GetParent()
        if not frame_registry[frame] then
            return
        end

        buffFrame.aura = aura
        
        local cooldown = buffFrame.cooldown
        cooldown.expirationTime = (cooldown:GetCooldownTimes() + cooldown:GetCooldownDuration()) / 1000
        cooldown.text:SetText(GetTimerText(cooldown.expirationTime - GetTime()))
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", utilSetBuff)

    for _, v in pairs(frame_registry) do
        v.dirty = true
    end

    RaidFrameSettings:IterateRoster(function(frame)
        createBuffFrames(frame)
        if not frame_registry[frame] then
            return
        end
        if frame.buffFrames then
            for i=1, frame_registry[frame].maxBuffs do
                local buffFrame = frame.buffFrames[i] or frame_registry[frame].extraBuffFrames[i]
                if buffFrame.auraInstanceID then
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, buffFrame.auraInstanceID)
                    utilSetBuff(buffFrame, aura)
                end
            end
        end
        hideAllBuffs(frame)
    end)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        for frame, v in pairs(frame_registry) do
            if v.lockdown and v.dirty then
                createBuffFrames(frame)
            end
        end
    end)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Buffs:OnDisable()
    self:DisableHooks()
    local restoreBuffFrames = function(frame)
        if frame_registry[frame] then
            frame_registry[frame].dirty = true
            for _, extraBuffFrame in pairs(frame_registry[frame].extraBuffFrames) do
                extraBuffFrame:Hide()
            end
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
            buffFrame:SetSize(Display, Display)
            buffFrame.icon:SetTexCoord(0,1,0,1)
            if ( i > 1 ) then
                buffFrame:ClearAllPoints();
                buffFrame:SetPoint(buffPos, frame.buffFrames[i - 1], buffRelativePoint, 0, 0);
            end
            buffFrame:SetFrameStrata(frame:GetFrameStrata())
            -- frame.buffFrames[i]:SetFrameLevel(frame:GetFrameLevel() + 1)

            local cooldown = buffFrame.cooldown
            if cooldown and cooldown.original then
                cooldown:SetDrawEdge(cooldown.original.edge)
                cooldown:SetDrawSwipe(cooldown.original.swipe)
                cooldown:SetReverse(cooldown.original.reverse)
                cooldown.text:Hide()
                if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
                    OmniCC.Cooldown.SetNoCooldownCount(cooldown, cooldown.original.noCooldownCount)
                end
            end

            local count = buffFrame.count
            if count and count.original then
                count:ClearAllPoints()
                count:SetPoint("BOTTOMRIGHT", 5, 0)
                count:SetFont(count.original.font:GetFont())
                count:SetShadowColor(count.original.shadowColor.r, count.original.shadowColor.g, count.original.shadowColor.b, count.original.shadowColor.a)
                count:SetShadowOffset(count.original.shadowOffset.x, count.original.shadowOffset.y)
                count:SetJustifyH(count.original.justifyH)
                count:SetJustifyV(count.original.justifyV)
            end
        end
    end
    RaidFrameSettings:IterateRoster(restoreBuffFrames)
end