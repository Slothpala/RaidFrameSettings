--[[
    Created by Slothpala
--]]
local BuffSize = RaidFrameSettings:NewModule("BuffSize")

function BuffSize:OnEnable()
    local width  = RaidFrameSettings.db.profile.MinorModules.BuffSize.width
    local height = RaidFrameSettings.db.profile.MinorModules.BuffSize.height
    local function UpdateAllCallback(frame)
        for i = 1,4 do
            frame.buffFrames[i]:SetSize(width, height)
            if frame.buffFrames[i].icon then frame.buffFrames[i].icon:SetVertexColor(0,0,0) end
        end
    end
    RaidFrameSettings:RegisterOnUpdateAll(UpdateAllCallback)
end

function BuffSize:OnDisable()

end