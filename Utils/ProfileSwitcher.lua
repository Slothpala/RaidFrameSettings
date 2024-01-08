local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local groupType = "party"

function addon:LoadGroupBasedProfile()
    local groupProfileName = self.db.global.GroupProfiles[groupType] or "Default"
    local currentProfile = self.db:GetCurrentProfile()
    if currentProfile ~= groupProfileName then
        self.db:SetProfile(groupProfileName) 
        self:Print("Profile set to: " .. groupProfileName)
    end
end

function addon:CheckGroupType()
    local newGroupType = self:GetGroupType()
    if (newGroupType ~= groupType) then
        groupType = newGroupType
        self:LoadGroupBasedProfile()
    end
end

