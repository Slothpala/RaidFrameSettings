local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Solo = addon:NewModule("Solo")
Mixin(Solo, addonTable.hooks)

local last = false
function Solo:OnEnable()
    local function onUpdateVisibility()
        local solo = true
        if IsInGroup() then
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
    PartyFrame:UpdatePaddingAndLayout()
end

function Solo:OnDisable()
    self:DisableHooks()
    if not IsInGroup() then
        CompactPartyFrame:SetShown(false)
        last = false
    end
end
