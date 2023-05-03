--[[
    Created by Slothpala
--]]
local BuffSize = RaidFrameSettings:NewModule("BuffSize")

function BuffSize:OnEnable()
    local width  = RaidFrameSettings.db.profile.MinorModules.BuffSize.width
    local height = RaidFrameSettings.db.profile.MinorModules.BuffSize.height
    local UpdateAllCallback
    if RaidFrameSettings.db.profile.MinorModules.BuffSize.clean_icons then
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
        UpdateAllCallback = function(frame)
            for i = 1,4 do
                local icon_frame = frame.buffFrames[i]
                icon_frame:SetSize(width, height)
                icon_frame.icon:SetTexCoord(left,right,top,bottom)
            end
        end
    else
        UpdateAllCallback = function(frame)
            for i = 1,4 do
                frame.buffFrames[i]:SetSize(width, height)
            end
        end
    end

    RaidFrameSettings:RegisterOnUpdateAll(UpdateAllCallback)
end

function BuffSize:OnDisable()

end