--[[
    Created by Slothpala 
--]]
local Debuffs = RaidFrameSettings:NewModule("Debuffs")
local hooked = nil
--Debuffframe size
local SetSize = SetSize
local IsForbidden = IsForbidden
local UtilSetDebuff_Callback


function Debuffs:OnEnable()
    --Debuffframe size
    local width = RaidFrameSettings.db.profile.Debuffs.Display.width
    local height = RaidFrameSettings.db.profile.Debuffs.Display.height
    local Display_increase = RaidFrameSettings.db.profile.Debuffs.Display.increase
    local boss_width  = width + Display_increase
    local boss_height = height + Display_increase
    local blacklist = {}
    for spellId, value in pairs(RaidFrameSettings.db.profile.Debuffs.Blacklist) do
        blacklist[tonumber(spellId)] = true
    end
    UtilSetDebuff_Callback = function(debuffFrame, aura)
        if debuffFrame:IsForbidden() then return end
        if aura and blacklist[aura.spellId] then
            debuffFrame:SetSize(0.1,0.1)
        else
            if aura and aura.isBossAura then
                debuffFrame:SetSize(boss_width, boss_height)
            else
                debuffFrame:SetSize(width, height)
            end
        end
    end
    if not hooked then
        hooksecurefunc("CompactUnitFrame_UtilSetDebuff", function(debuffFrame, aura) UtilSetDebuff_Callback(debuffFrame, aura) end)
        hooked = true
    end
    RaidFrameSettings:RegisterUpdateDebuffFrame(UtilSetDebuff_Callback)
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
    UpdateAllCallback = function(frame)
        frame.debuffFrames[1]:ClearAllPoints()
        frame.debuffFrames[1]:SetPoint(point, frame, relativePoint, x_offset, y_offset)
        for i=1, #frame.debuffFrames do
            if ( i > 1 ) then
                frame.debuffFrames[i]:ClearAllPoints();
                frame.debuffFrames[i]:SetPoint(debuffPoint, frame.debuffFrames[i - 1], debuffRelativePoint, 0, 0);
            end
        end
    end
    RaidFrameSettings:RegisterOnUpdateAll(UpdateAllCallback)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Debuffs:OnDisable()
    UtilSetDebuff_Callback = function() end
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
            if ( i > 1 ) then
                frame.debuffFrames[i]:ClearAllPoints();
                frame.debuffFrames[i]:SetPoint(debuffPos, frame.debuffFrames[i - 1], debuffRelativePoint, 0, 0);
            end
        end
    end
    RaidFrameSettings:IterateRoster(restoreDebuffFrames)
end
