--[[
    Created by Slothpala
    position 1,2,3,4 = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},
--]]
local hooked = nil
local function donothing() end
local Callback
local RoleIcon = RaidFrameSettings:NewModule("RoleIcon")

function RoleIcon:OnEnable()
    local x,y,relativePoint
    local x_offset,y_offset = RaidFrameSettings.db.profile.MinorModules.RoleIcon.x_offset,RaidFrameSettings.db.profile.MinorModules.RoleIcon.y_offset
    local position = RaidFrameSettings.db.profile.MinorModules.RoleIcon.position
    if position == 1 then
        x = 4
        y = -4
        relativePoint = "TOPLEFT"
    elseif position == 2 then
        x = -4
        y = -4
        relativePoint = "TOPRIGHT"
    elseif position == 3 then
        x = 4
        y = 4
        relativePoint = "BOTTOMLEFT"
    elseif position == 4 then
        x = -4
        y = 4
        relativePoint = "BOTTOMRIGHT"
    end
    Callback = function(frame)
        if not frame.roleIcon then
            return
        end
        frame.roleIcon:ClearAllPoints()
        frame.roleIcon:SetPoint(relativePoint, frame, relativePoint, x + x_offset, y + y_offset)
    end
    if not hooked then
        hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(frame)
            Callback(frame)
        end)
        hooked = true
    end
end

function RoleIcon:OnDisable()
    if hooked then
        Callback = donothing
    end
end