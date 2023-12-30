--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local Buffs = RaidFrameSettings:NewModule("Buffs")
Mixin(Buffs, addonTable.hooks)

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
    local function updateAnchors(frame, endingIndex)
        local first = true
        local prev
        for i = 1, endingIndex or #frame.buffFrames do
            if frame.buffFrames[i]:IsShown() then
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
    local hideAllBuffs = function(frame, startingIndex)
        if frame.buffFrames then
            updateAnchors(frame, startingIndex)
        end
    end
    self:HookFunc("CompactUnitFrame_HideAllBuffs", hideAllBuffs)

    local createBuffFrames = function(frame)
        -- local maxBuffs = frame:GetWidth() / width
        -- maxBuffs = math.floor(maxBuffs)
        -- maxBuffs = math.max(3, maxBuffs)
        local maxBuffs = 10

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
            resizeAura(frame.buffFrames[i])
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
        if aura and blacklist[aura.spellId] then
            buffFrame:Hide()
        else
            buffFrame:Show()
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", resizeBuffFrame)
    RaidFrameSettings:IterateRoster(function(frame)
        updateAnchors(frame)
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
        updateAnchors(frame)
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
            frame.buffFrames[i]:SetSize(Display, Display)
            frame.buffFrames[i].icon:SetTexCoord(0,1,0,1)
            if ( i > 1 ) then
                frame.buffFrames[i]:ClearAllPoints();
                frame.buffFrames[i]:SetPoint(buffPos, frame.buffFrames[i - 1], buffRelativePoint, 0, 0);
            end
        end
    end
    RaidFrameSettings:IterateRoster(restoreBuffFrames)
end