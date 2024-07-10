--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local IsInRaid = IsInRaid
local IsInInstance = IsInInstance

--always default to party profile
function addon:GetGroupType()
  local in_instance, instance_type = IsInInstance()
  if in_instance then
    if instance_type == "pvp" then
      return "battleground"
    end
    if instance_type == "arena" then
      return instance_type
    end
  end
  local in_raid = IsInRaid()
  local group_type = in_raid and "raid" or "party"
  return group_type
end
