--[[
    Created by Slothpala
--]]
local CustomSize = RaidFrameSettings:NewModule("CustomSize")

function CustomSize:OnEnable()
    customWidth, customHeight = RaidFrameSettings.db.profile.MinorModules.CustomSize.x, RaidFrameSettings.db.profile.MinorModules.CustomSize.y
    local updateSize = function(frame)
        local frameName = frame:GetName()
        if frameName:match("Arena") then 
            return 
        end
        frame:SetSize(customWidth,customHeight)
    end
    RaidFrameSettings:RegisterOnUpdateAll(updateSize)
    CompactRaidFrameContainer:TryUpdate()
end

function CustomSize:OnDisable()
    local restoreSize = function(frame)
        local defaultWidth  = EditModeManagerFrame:GetRaidFrameWidth(frame.groupType)
        local defaultHeight = EditModeManagerFrame:GetRaidFrameHeight(frame.groupType)
        frame:SetSize(defaultWidth,defaultHeight)
    end
    RaidFrameSettings:IterateRoster(restoreSize)
    CompactRaidFrameContainer:TryUpdate()
end

