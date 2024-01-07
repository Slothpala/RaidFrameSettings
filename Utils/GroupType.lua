local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsActiveBattlefieldArena = IsActiveBattlefieldArena

function addon:GetGroupType()
    local inRaid = IsInRaid()
    local inArena = IsActiveBattlefieldArena()
    local groupType = inRaid and not inArena and "raid" or inArena and "arena" or "party" 
    return groupType
end

