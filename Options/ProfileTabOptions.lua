--[[Created by Slothpala]]--
--[[
  The profile creation is inspired by the default AceDB profile options to give a familiar feel to the user.
  But I had to make some changes to better handle the group type profile options.
]]

local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local ACD = LibStub("AceConfigDialog-3.0")

local class_id = select(3, UnitClass("player"))
local profiles = {}

local function get_profiles(info)
  local no_current = info.arg == "no_current"
  local current_profile = addon.db:GetCurrentProfile()
  local profile_list = {}
  for k, v in pairs(addon.db:GetProfiles(profiles)) do
    if no_current and v == current_profile then
      -- skip
    else
      profile_list[k] = v
    end
  end
  return profile_list
end

local options = {
  name = L["profiles_options_tab_name"],
  handler = addon,
  type = "group",
  childGroups = "tab",
  args = {
    profile_creation = {
      order = 1,
      name = function()
        local current_profile = addon.db:GetCurrentProfile()
        return L["profile_creation_title"] .. "( |cff39FF14" .. current_profile .. "|r )"
      end,
      type = "group",
      inline = true,
      args = {
        reset_profile_btn = {
          order = 0,
          name = L["reset_profile_btn_name"],
          desc = L["reset_profile_btn_desc"],
          type = "execute",
          func = function()
            addon.db:ResetProfile()
          end
        },
        new_profile_desc = {
          order = 1,
          name = L["new_profile_desc_name"],
          type = "description",
          fontSize = "medium",
        },
        new_profile = {
          order = 2,
          name = L["new_profile_name"],
          desc = L["new_profile_desc"],
          type = "input",
          get = function()
            return ""
          end,
          set = function(_, input)
            -- Create the new profile
            addon.db:SetProfile(input)
            -- Set the current group type profile to the newly created profile
            local current_spec_id = GetSpecialization()
            local current_spec_name = select(2, GetSpecializationInfoForClassID(class_id, current_spec_id))
            local group_type = addon:GetGroupType()
            addon.db.global[current_spec_name][group_type .. "_profile"] = input
          end,
        },
        copy_profile_desc = {
          order = 3,
          name = L["copy_profile_desc_name"],
          type = "description",
          fontSize = "medium",
        },
        copy_profile = {
          disabled = function()
            local profile_list = get_profiles({arg = "no_current"})
            return not next(profile_list)
          end,
          order = 4,
          name = L["copy_profile_name"],
          desc = L["copy_profile_desc"],
          type = "select",
          values = get_profiles,
          set = function(_, info)
            addon.db:CopyProfile(profiles[info])
          end,
          arg = "no_current",
        },
        delete_profile_desc = {
          order = 5,
          name = L["delete_profile_desc_name"],
          type = "description",
          fontSize = "medium",
        },
        delete_profile = {
          disabled = function()
            local profile_list = get_profiles({arg = "no_current"})
            return not next(profile_list)
          end,
          order = 6,
          name = L["delete_profile_name"],
          desc = L["delete_profile_desc"],
          type = "select",
          values = get_profiles,
          set = function(_, info)
            addon.db:DeleteProfile(profiles[info])
          end,
          arg = "no_current",
          confirm = true,
          confirmText = L["delete_profile_confirm"],
        },
      },
    },
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
            pop_up_frame.title:SetText("Export" .. ": |cff39FF14" .. addon.db:GetCurrentProfile() .. "|r")
            pop_up_frame:Show()
            ACD:Open("RaidFrameSettings_Export_Profile_Options_PopUp", pop_up_frame.container)
          end
        }
      },
    },
  },
}


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
    -- if it matches the current group type and spec load the profile
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
  return options
end



