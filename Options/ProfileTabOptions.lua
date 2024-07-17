--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local ACD = LibStub("AceConfigDialog-3.0")

local options = {
  name = L["profiles_options_tab_name"],
  handler = addon,
  type = "group",
  childGroups = "tab",
  args = {
    -- Order 1 = Ace Profile tab
    group_type_profiles = {
      order = 2,
      name = "Group Profiles",
      type = "group",
      childGroups = "tab",
      args = {

      },
    },
    ImportExportPofile = {
      order = 3,
      name = L["share_profile_title"],
      type = "group",
      args = {
        import_btn = {
          order = 1,
          name = "Import",
          type = "execute",
          func = function()
            local pop_up_frame = addon:GetPopUpFrame()
            pop_up_frame.title:SetText("Import")
            pop_up_frame:Show()
            ACD:Open("RaidFrameSettings_Import_Profile_Options_PopUp", pop_up_frame.container)
          end
        },
        new_line = {
          order = 20,
          name = "",
          type = "description",
        },
        export_btn = {
          order = 20.1,
          name = "Export",
          type = "execute",
          func = function()
            local pop_up_frame = addon:GetPopUpFrame()
            pop_up_frame.title:SetText("Export")
            pop_up_frame:Show()
            ACD:Open("RaidFrameSettings_Export_Profile_Options_PopUp", pop_up_frame.container)
          end
        }
      },
    },
  },
}

local profiles = {}

local class_id = select(3, UnitClass("player"))
for i=1, GetNumSpecializationsForClassID(class_id) do
  local _, spec_name, _, spec_icon = GetSpecializationInfoForClassID(class_id, i)

  local function get_spec_group_profile(info)
    addon.db:GetProfiles(profiles)
    for k, v in next, profiles do
      if addon.db.global[spec_name][info[#info]] == v then
        return k
      end
    end
  end

  local function set_spec_group_profile(info, value)
    addon.db:GetProfiles(profiles)
    addon.db.global[spec_name][info[#info]] = profiles[value]
    if string.find(info[#info], addon:GetGroupType()) then
      local current_spec_id = GetSpecialization()
      local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
      if current_spec_name == info[#info-1] then
        addon.db:SetProfile(profiles[value])
      end
    end
  end

  options.args.group_type_profiles.args[spec_name] = {
    order = i,
    name = function()
      local current_spec_id = GetSpecialization()
      local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
      if current_spec_name == spec_name then
        return spec_name .. " - " .. "|cff39FF14" .. L["active_spec_indicator"] .. "|r"
      else
        return spec_name
      end
    end,
    type = "group",
    args = {
      icon = {
        order = 0,
        name = "",
        image = spec_icon,
        imageWidth = 22,
        imageHeight = 22,
        imageCoords = {0.1,0.9,0.1,0.9},
        type = "description",
        width = 0.15,
      },
      space = {
        order = 0.1,
        name = "",
        type = "description",
        width = 0.05
      },
      party_profile = {
        name = function()
          local current_group_type = addon:GetGroupType()
          local current_spec_id = GetSpecialization()
          local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
          if current_group_type == "party" and ( current_spec_name == spec_name ) then
            return L["party_profile_name"] .. " - " .. "|cff39FF14" .. L["active_spec_indicator"] .. "|r"
          else
            return L["party_profile_name"]
          end
        end,
        order = 1,
        type = "select",
        values = function()
          return addon.db:GetProfiles(profiles)
        end,
        get = get_spec_group_profile,
        set = set_spec_group_profile,
      },
      raid_profile = {
        name = function()
          local current_group_type = addon:GetGroupType()
          local current_spec_id = GetSpecialization()
          local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
          if current_group_type == "raid" and ( current_spec_name == spec_name ) then
            return L["raid_profile_name"] .. " - " .. L["active_spec_indicator"]
          else
            return L["raid_profile_name"]
          end
        end,
        order = 2,
        type = "select",
        values = function()
          return addon.db:GetProfiles(profiles)
        end,
        get = get_spec_group_profile,
        set = set_spec_group_profile,
      },
      arena_profile = {
        name = function()
          local current_group_type = addon:GetGroupType()
          local current_spec_id = GetSpecialization()
          local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
          if current_group_type == "arena" and ( current_spec_name == spec_name ) then
            return L["arena_profile_name"] .. " - " .. L["active_spec_indicator"]
          else
            return L["arena_profile_name"]
          end
        end,
        order = 3,
        type = "select",
        values = function()
          return addon.db:GetProfiles(profiles)
        end,
        get = get_spec_group_profile,
        set = set_spec_group_profile,
      },
      battleground_profile = {
        name = function()
          local current_group_type = addon:GetGroupType()
          local current_spec_id = GetSpecialization()
          local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
          if current_group_type == "battleground" and ( current_spec_name == spec_name ) then
            return L["battleground_profile_name"] .. " - " .. L["active_spec_indicator"]
          else
            return L["battleground_profile_name"]
          end
        end,
        order = 4,
        type = "select",
        values = function()
          return addon.db:GetProfiles(profiles)
        end,
        get = get_spec_group_profile,
        set = set_spec_group_profile,
      },
    }
  }
end

function addon:GetProfileTabOptions()
  local profile_options = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
  profile_options.order = 1
  profile_options.inline = true
  options.args.profiles = profile_options
  return options
end



