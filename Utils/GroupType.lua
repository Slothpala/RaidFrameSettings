local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local IsInRaid = IsInRaid
local IsInInstance = IsInInstance

--always default to party profile
function addon:GetGroupType()
    local inInstance, instanceType = IsInInstance()
    if inInstance then
        if instanceType == "pvp" then
            return "battleground"
        end
        if instanceType == "arena" then
            return instanceType
        end
    end
    local inRaid = IsInRaid()
    local groupType = inRaid and "raid" or "party"
    return groupType
end

