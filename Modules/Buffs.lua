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
local AuraUtil_ForEachAura = AuraUtil.ForEachAura

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
    local function updateAnchors(frame)
        frame.buffFrames[1]:ClearAllPoints()
        frame.buffFrames[1]:SetPoint(point, frame, relativePoint, x_offset, y_offset)
        for i=1, #frame.buffFrames do
            if ( i > 1 ) then
                frame.buffFrames[i]:ClearAllPoints();
                frame.buffFrames[i]:SetPoint(buffPoint, frame.buffFrames[i - 1], buffRelativePoint, 0, 0);
            end
            resizeAura(frame.buffFrames[i])
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", updateAnchors)
    --blacklist
    local blacklist = {}
    for spellId, value in pairs(RaidFrameSettings.db.profile.Buffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end
    --blacklist
    local whitelist = {}
    for spellId, value in pairs(RaidFrameSettings.db.profile.Buffs.Whitelist) do
        whitelist[tonumber(spellId)] = value
    end
    local resizeBuffFrame = function(buffFrame, aura)
        if aura and blacklist[aura.spellId] then
            buffFrame:SetSize(0.1,0.1)
        else
            buffFrame:SetSize(width, height)
        end
    end
    self:HookFunc("CompactUnitFrame_UtilSetBuff", resizeBuffFrame)
    local function processAura(frame, aura, displayOnlyDispellableDebuffs, ignoreBuffs, ignoreDebuffs,ignoreDispelDebuffs)
        if frame.unit:match("na") then --this will exclude nameplates and arena
            return
        end
        if not frame.buffs then
            return
        end
        if not aura.isHelpful or not whitelist[aura.spellId] then
            return
        end
        if not whitelist[aura.spellId].other and not UnitIsUnit("player", aura.sourceUnit) then
            return
        end
        frame.buffs[aura.auraInstanceID] = aura
    end
    self:HookFunc("CompactUnitFrame_ProcessAura", processAura)
    RaidFrameSettings:IterateRoster(function(frame)
        updateAnchors(frame)
        CompactUnitFrame_UpdateAuras(frame)
        if frame.buffFrames then
            for i=1, #frame.buffFrames do
                local buffFrame = frame.buffFrames[i]
                if buffFrame.auraInstanceID then
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, buffFrame.auraInstanceID)
                    if aura and RaidFrameSettings.db.profile.Buffs.Blacklist[tostring(aura.spellId)] then
                        buffFrame:SetSize(0.1,0.1)
                    end
                end
            end
        end
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