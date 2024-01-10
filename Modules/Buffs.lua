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
    local maxBuffs = RaidFrameSettings.db.profile.Buffs.Display.maxbuffs
    local framestrataIdx = RaidFrameSettings.db.profile.Buffs.Display.framestrata
    local framestrata = (framestrataIdx == 1 and "Inherited") or
        (framestrataIdx == 2 and "BACKGROUND") or (framestrataIdx == 3 and "LOW") or (framestrataIdx == 4 and "MEDIUM") or
        (framestrataIdx == 5 and "HIGH") or
        (framestrataIdx == 6 and "DIALOG") or (framestrataIdx == 7 and "FULLSCREEN") or
        (framestrataIdx == 8 and "FULLSCREEN_DIALOG") or (framestrataIdx == 9 and "TOOLTIP")

    local dbObj = RaidFrameSettings.db.profile.Buffs.Display.Duration
    local Duration = {
        Font        = Media:Fetch("font", dbObj.font),
        FontSize    = dbObj.fontsize,
        FontColor   = dbObj.fontcolor,
        OutlineMode = (dbObj.thick and "THICK" or "") ..
        (dbObj.outline and "OUTLINE" or "") .. ", " .. (dbObj.monochrome and "MONOCHROME" or ""),
        Position    = (dbObj.position == 1 and "TOPLEFT") or (dbObj.position == 2 and "TOP") or
            (dbObj.position == 3 and "TOPRIGHT")
            or (dbObj.position == 4 and "LEFT") or (dbObj.position == 5 and "CENTER") or
            (dbObj.position == 6 and "RIGHT")
            or (dbObj.position == 7 and "BOTTOMLEFT") or (dbObj.position == 8 and "BOTTOM") or
            (dbObj.position == 9 and "BOTTOMRIGHT"),
        X_Offset    = dbObj.x_offset,
        Y_Offset    = dbObj.y_offset,
    }

    dbObj = RaidFrameSettings.db.profile.Buffs.Display.Stacks
    local Stacks = {
        Font        = Media:Fetch("font", dbObj.font),
        FontSize    = dbObj.fontsize,
        FontColor   = dbObj.fontcolor,
        OutlineMode = (dbObj.thick and "THICK" or "") ..
        (dbObj.outline and "OUTLINE" or "") .. ", " .. (dbObj.monochrome and "MONOCHROME" or ""),
        Position    = (dbObj.position == 1 and "TOPLEFT") or (dbObj.position == 2 and "TOP") or
            (dbObj.position == 3 and "TOPRIGHT")
            or (dbObj.position == 4 and "LEFT") or (dbObj.position == 5 and "CENTER") or
            (dbObj.position == 6 and "RIGHT")
            or (dbObj.position == 7 and "BOTTOMLEFT") or (dbObj.position == 8 and "BOTTOM") or
            (dbObj.position == 9 and "BOTTOMRIGHT"),
        X_Offset    = dbObj.x_offset,
        Y_Offset    = dbObj.y_offset,
    }

    local Position = {}
    for k, v in pairs(RaidFrameSettings.db.profile.Buffs.Position) do
        Position[tonumber(k)] = {
            point = (v.point == 1 and "TOPLEFT") or (v.point == 2 and "TOP") or (v.point == 3 and "TOPRIGHT") or
                (v.point == 4 and "LEFT") or (v.point == 5 and "CENTER") or (v.point == 6 and "RIGHT") or
                (v.point == 7 and "BOTTOMLEFT") or (v.point == 8 and "BOTTOM") or (v.point == 9 and "BOTTOMRIGHT"),
            x_offset = width * v.x + v.x_offset,
            y_offset = height * v.y + v.y_offset,
        }
    end

    local function updateAnchors(frame, endingIndex)
        local first = true
        local prev
        for i = 1, endingIndex and endingIndex > #frame.buffFrames and #frame.buffFrames or endingIndex or #frame.buffFrames do
            if frame.buffFrames[i]:IsShown() and not frame.buffFrames[i]:IsForbidden() then
                local continue
                if frame.buffFrames[i].aura then
                    local aura = frame.buffFrames[i].aura
                    if Position[aura.spellId] then
                        local pos = Position[aura.spellId]
                        frame.buffFrames[i]:ClearAllPoints()
                        frame.buffFrames[i]:SetPoint(pos.point, frame, pos.point, pos.x_offset, pos.y_offset)
                        continue = true
                    end
                end

                if not continue then
                    if first then
                        frame.buffFrames[i]:ClearAllPoints()
                        frame.buffFrames[i]:SetPoint(point, frame, relativePoint, x_offset, y_offset)
                        prev = frame.buffFrames[i]
                        first = false
                    else
                        frame.buffFrames[i]:ClearAllPoints()
                        frame.buffFrames[i]:SetPoint(buffPoint, prev, buffRelativePoint, 0, 0)
                        prev = frame.buffFrames[i]
                    end
                end
            end
        end
    end
    local hideAllBuffs = function(frame, startingIndex)
        if frame.buffFrames then
            updateAnchors(frame, startingIndex and startingIndex > 0 and startingIndex - 1)
        end
    end
    self:HookFunc("CompactUnitFrame_HideAllBuffs", hideAllBuffs)

    local function GetTimerText(remain)
        if remain < 60 then
            return Round(remain)
        elseif remain < 600 then
            return string.format("%d:%02d", math.floor(remain / 60), (remain % 60))
        elseif remain < 3600 then
            return string.format("%dm", Round(remain / 60))
        elseif remain < 36000 then
            return string.format("%d:%02dm", math.floor(remain / 3600), math.ceil((remain % 3600) / 60))
        elseif remain < 86400 then
            return string.format("%dh", Round(remain / 3600))
        else
            return string.format("%dd", Round(remain / 86400))
        end
    end
    local createBuffFrames = function(frame)
        if framestrata == "Inherited" then
            framestrata = frame:GetFrameStrata()
        end

        if maxBuffs > frame.maxBuffs then
            local frameName = frame:GetName() .. "Buff"
            for i = frame.maxBuffs + 1, maxBuffs do
                local child = _G[frameName .. i] or CreateFrame("Button", frameName .. i, frame, "CompactBuffTemplate")
                child:ClearAllPoints()
                child:SetPoint("BOTTOMRIGHT", _G[frameName .. i - 1], "BOTTOMLEFT")
            end
            frame.maxBuffs = maxBuffs
        end

        for i = 1, maxBuffs do
            local buffFrame = frame.buffFrames[i]
            resizeAura(buffFrame)
            buffFrame:SetFrameStrata(framestrata)

            local cooldown = buffFrame.cooldown
            cooldown:SetHideCountdownNumbers(false)
            cooldown:SetDrawBling(false)
            cooldown:SetDrawSwipe(false)

            local count = buffFrame.count
            count:ClearAllPoints()
            count:SetPoint(Stacks.Position, Stacks.X_Offset, Stacks.Y_Offset)
            count:SetFont(Stacks.Font, Stacks.FontSize, Stacks.OutlineMode)
            count:SetTextHeight(Stacks.FontSize)
            count:SetVertexColor(Stacks.FontColor.r, Stacks.FontColor.g, Stacks.FontColor.b)

            if not cooldown.text then
                cooldown.text = cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
                cooldown:SetScript("OnUpdate", function(s, t)
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
            text:SetFont(Duration.Font, Duration.FontSize, Duration.OutlineMode)
            text:SetTextHeight(Duration.FontSize)
            text:SetVertexColor(Duration.FontColor.r, Duration.FontColor.g, Duration.FontColor.b)
        end

        updateAnchors(frame)
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", createBuffFrames)
    --blacklist
    local blacklist = {}
    for spellId, value in pairs(RaidFrameSettings.db.profile.Buffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end
    local resizeBuffFrame = function(buffFrame, aura)
        if buffFrame:IsForbidden() then
            return
        end

        buffFrame.aura = aura
        if aura and blacklist[aura.spellId] then
            buffFrame:Hide()
        else
            buffFrame:Show()

            buffFrame.cooldown.start = aura.expirationTime - aura.duration
            buffFrame.cooldown.duration = aura.duration
            buffFrame.cooldown.expirationTime = aura.expirationTime

            if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
                OmniCC.Cooldown.SetNoCooldownCount(buffFrame.cooldown, true)
            end
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", resizeBuffFrame)
    RaidFrameSettings:IterateRoster(function(frame)
        if frame.buffFrames then
            for i=1, #frame.buffFrames do
                local buffFrame = frame.buffFrames[i]
                if buffFrame.auraInstanceID then
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, buffFrame.auraInstanceID)
                    if aura and RaidFrameSettings.db.profile.Buffs.Blacklist[tostring(aura.spellId)] then
                        buffFrame:Hide()
                    end
                end
            end
        end
        createBuffFrames(frame)
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
        frame.buffFrames[1]:SetFrameStrata(frame:GetFrameStrata())
        for i=1, #frame.buffFrames do
            frame.buffFrames[i]:SetSize(Display, Display)
            frame.buffFrames[i].icon:SetTexCoord(0,1,0,1)
            if ( i > 1 ) then
                frame.buffFrames[i]:ClearAllPoints();
                frame.buffFrames[i]:SetPoint(buffPos, frame.buffFrames[i - 1], buffRelativePoint, 0, 0);
                frame.buffFrames[i]:SetFrameStrata(frame:GetFrameStrata())
            end
        end

        local maxDebuffSize = math.min(20, frameHeight - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE)
        local buffSpace = frame:GetWidth() - (3 * maxDebuffSize)
        local maxBuffs = buffSpace / Display
        maxBuffs = math.floor(maxBuffs)
        maxBuffs = math.max(3, maxBuffs)
        maxBuffs = math.min(#frame.buffFrames, maxBuffs)
        frame.maxBuffs = maxBuffs
    end
    RaidFrameSettings:IterateRoster(restoreBuffFrames)
end