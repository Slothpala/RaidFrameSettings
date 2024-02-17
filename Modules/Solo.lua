local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Solo = addon:NewModule("Solo")
Mixin(Solo, addonTable.hooks)

local last
function Solo:OnEnable()
    local function onUpdateVisibility()
        local solo = true
        if IsInGroup() or IsInRaid() then
            solo = false
        end
        if solo == false and last == false then
            return
        end
        CompactPartyFrame:SetShown(solo)
        last = solo
    end

    self:HookFunc(CompactPartyFrame, "UpdateVisibility", onUpdateVisibility);
    CompactPartyFrame:SetShown(true)
end

function Solo:OnDisable()
    self:DisableHooks()
    CompactPartyFrame:SetShown(false)
end
