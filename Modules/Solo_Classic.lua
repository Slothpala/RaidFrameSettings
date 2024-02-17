local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Solo = addon:NewModule("Solo")
Mixin(Solo, addonTable.hooks)

local enabled
local org_GetDisplayedAllyFrames = GetDisplayedAllyFrames
function GetDisplayedAllyFrames()
    local useCompact = GetCVarBool("useCompactPartyFrames")
	if ( IsActiveBattlefieldArena() and not useCompact ) then
		return "party"
	elseif ( IsInGroup() and (IsInRaid() or useCompact) ) then
		return "raid"
	elseif ( IsInGroup() ) then
		return "party"
	elseif enabled then
		return "raid"
    else
        return nil
	end
    -- return org_GetDisplayedAllyFrames()
end

function Solo:Refresh()
    if not InCombatLockdown() then
        local c = GetCVar("cameraDistanceMaxZoomFactor")
        if c ~= "1" then
            SetCVar("cameraDistanceMaxZoomFactor", 1)
        else
            SetCVar("cameraDistanceMaxZoomFactor", 1.1)
        end
        SetCVar("cameraDistanceMaxZoomFactor", c)
    end
end

function Solo:OnEnable()
    enabled = true
    self:Refresh()
end

function Solo:OnDisable()
    enabled = false
    self:Refresh()
end
