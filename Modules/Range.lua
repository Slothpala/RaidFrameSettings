--[[
    Created by Slothpala
--]]
local Range = RaidFrameSettings:NewModule("Range")

function Range:OnEnable()
    local statusbarAlpha  = RaidFrameSettings.db.profile.MinorModules.RangeAlpha.statusbar
    local backgroundAlpha = RaidFrameSettings.db.profile.MinorModules.RangeAlpha.background
    local function UpdateInRangeCallback(frame)
            local inRange, checkedRange = UnitInRange(frame.displayedUnit or "")
            if ( checkedRange and not inRange ) then	
                frame:SetAlpha(statusbarAlpha)
                frame.background:SetAlpha(backgroundAlpha)
            else
                frame.background:SetAlpha(1)
            end
    end
    RaidFrameSettings:RegisterUpdateInRange(UpdateInRangeCallback)
end

function Range:OnDisable()

end