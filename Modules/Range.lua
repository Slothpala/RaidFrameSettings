--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local Range = RaidFrameSettings:NewModule("Range")
Mixin(Range, addonTable.hooks)

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
    self:HookFuncFiltered("CompactUnitFrame_UpdateInRange", UpdateInRangeCallback)
    RaidFrameSettings:IterateRoster(UpdateInRangeCallback)
end

function Range:OnDisable()
    self:DisableHooks()
    local restoreRangeAlpha = function(frame)
        local inRange, checkedRange = UnitInRange(frame.displayedUnit or "")
        if ( checkedRange and not inRange ) then	
            frame:SetAlpha(0.55)
        end
        frame.background:SetAlpha(1)
    end
    RaidFrameSettings:IterateRoster(restoreRangeAlpha)
end