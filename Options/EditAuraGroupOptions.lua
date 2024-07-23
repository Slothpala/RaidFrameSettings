--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local ACD = LibStub("AceConfigDialog-3.0")

---------------------------
--- Frame Point Settings---
---------------------------

local locale_frame_points = {
  [1] = L["frame_point_top_left"],
  [2] = L["frame_point_top_right"],
  [3] = L["frame_point_bottom_left"],
  [4] = L["frame_point_bottom_right"],
  [5] = L["frame_point_top"],
  [6] = L["frame_point_bottom"],
  [7] = L["frame_point_left"],
  [8] = L["frame_point_right"],
  [9] = L["frame_point_center"],
}

local frame_points = {
  [1] = "TOPLEFT",
  [2] = "TOPRIGHT",
  [3] = "BOTTOMLEFT",
  [4] = "BOTTOMRIGHT",
  [5] = "TOP",
  [6] = "BOTTOM",
  [7] = "LEFT",
  [8] = "RIGHT",
  [9] = "CENTER",
}

local frame_points_reverse = {
  ["TOPLEFT"] = 1,
  ["TOPRIGHT"] = 2,
  ["BOTTOMLEFT"] = 3,
  ["BOTTOMRIGHT"] = 4,
  ["TOP"] = 5,
  ["BOTTOM"] = 6,
  ["LEFT"] = 7,
  ["RIGHT"] = 8,
  ["CENTER"] = 9,
}

-----------------------
--- Growth Directon ---
-----------------------

local locale_growth_direction_vertical = {
  [1] = L["growth_direction_up"],
  [2] = L["growth_direction_down"],
}

local growth_direction_vertical = {
  [1] = "UP",
  [2] = "DOWN",
}

local growth_direction_vertical_reverse = {
  ["UP"] = 1,
  ["DOWN"] = 2,
}

local locale_growth_direction_horizontal = {
  [1] = L["growth_direction_left"],
  [2] = L["growth_direction_right"],
}

local growth_direction_horizontal = {
  [1] = "LEFT",
  [2] = "RIGHT",
}

local growth_direction_horizontal_reverse = {
  ["LEFT"] = 1,
  ["RIGHT"] = 2,
}

--------------
--- Options---
--------------

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  args = {
  }
}

function addon:SetEditAuraGroupOptions(gorup_name)

  local function update_options()
    -- scope
  end

  local function get_status(info)
    return addon.db.profile.AuraGroups.aura_groups[gorup_name][info[#info]]
  end

  local function set_status(info, value)
    addon.db.profile.AuraGroups.aura_groups[gorup_name][info[#info]] = value
    self:ReloadModule("AuraGroups")
  end

  local function get_color(info)
    local color = addon.db.profile.AuraGroups.aura_groups[gorup_name][info[#info]]
    return color[1], color[2], color[3], color[4] or 1
  end

  local function set_color(info, r, g, b, a)
    local color = {
      [1] = r,
      [2] = g,
      [3] = b,
      [4] = a,
    }
    addon.db.profile.AuraGroups.aura_groups[gorup_name][info[#info]] = color
    self:ReloadModule("AuraGroups")
  end

  update_options = function()
    options.args = {
      aura_group_settings = {
        hidden = function()
          return addon.db.profile.AuraGroups.aura_groups[gorup_name].hide_indicator_settings
        end,
        order = 1,
        name = L["indicator_header_name"],
        type = "group",
        inline = true,
        args = {
          point = {
            order = 1,
            name = L["point_name"],
            desc = L["point_desc"],
            type = "select",
            values = locale_frame_points,
            get = function()
              return  frame_points_reverse[addon.db.profile.AuraGroups.aura_groups[gorup_name].point]
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].point = frame_points[value]
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          relative_point = {
            order = 2,
            name = L["relative_point_name"],
            desc = L["relative_point_desc"],
            type = "select",
            values = locale_frame_points,
            get = function()
              return  frame_points_reverse[addon.db.profile.AuraGroups.aura_groups[gorup_name].relative_point]
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].relative_point = frame_points[value]
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          offset_x = {
            order = 3,
            name = L["offset_x_name"],
            desc = L["offset_x_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = -10,
            max = 10,
            step = 1,
            width = 0.7,
          },
          offset_y = {
            order = 4,
            name = L["offset_y_name"],
            desc = L["offset_y_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = -10,
            max = 10,
            step = 1,
            width = 0.7,
          },
          indicator_width = {
            order = 5,
            name = L["indicator_width_name"],
            desc = L["indicator_width_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = 8,
            max = 48,
            step = 1,
            width = 0.7,
          },
          indicator_height = {
            order = 6,
            name = L["indicator_height_name"],
            desc = L["indicator_height_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = 8,
            max = 48,
            step = 1,
            width = 0.7,
          },
          indicator_border_thickness = {
            order = 7,
            name = L["indicator_border_thicknes_name"],
            desc = L["indicator_border_thicknes_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = 0,
            max = 5,
            step = 0.1,
            width = 0.7,
          },
          new_line_1 = {
            order = 20,
            name = "",
            type = "description",
          },
          direction_of_growth_vertical = {
            order = 20.1,
            name = L["direction_of_growth_vertical_name"],
            desc = L["direction_of_growth_vertical_desc"],
            type = "select",
            values = locale_growth_direction_vertical,
            get = function()
              return  growth_direction_vertical_reverse[addon.db.profile.AuraGroups.aura_groups[gorup_name].direction_of_growth_vertical]
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].direction_of_growth_vertical = growth_direction_vertical[value]
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          num_indicators_per_column = {
            order = 20.2,
            name = L["num_indicators_per_column_name"],
            desc = L["num_indicators_per_column_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = 1,
            max = 10,
            step = 1,
            width = 0.6,
          },
          direction_of_growth_horizontal = {
            order = 20.3,
            name = L["direction_of_growth_horizontal_name"],
            desc = L["direction_of_growth_horizontal_desc"],
            type = "select",
            values = locale_growth_direction_horizontal,
            get = function()
              return  growth_direction_horizontal_reverse[addon.db.profile.AuraGroups.aura_groups[gorup_name].direction_of_growth_horizontal]
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].direction_of_growth_horizontal = growth_direction_horizontal[value]
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          num_indicators_per_row = {
            order = 20.4,
            name = L["num_indicators_per_row_name"],
            desc = L["num_indicators_per_row_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = 1,
            max = 10,
            step = 1,
            width = 0.6,
          },
          horizontal_padding = {
            order = 20.5,
            name = L["horizontal_padding_name"],
            desc = L["padding_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = -5,
            max = 5,
            step = 1,
            width = 0.8,
          },
          vertical_padding = {
            order = 20.6,
            name = L["vertical_padding_name"],
            desc = L["padding_desc"],
            type = "range",
            get = get_status,
            set = set_status,
            min = -5,
            max = 5,
            step = 1,
            width = 0.8,
          },
          indicator_border_color = {
            order = 20.7,
            name = L["indicator_border_color_name"],
            desc = L["indicator_border_color_desc"],
            type = "color",
            get = get_color,
            set = set_color,
            width = 0.8,
          },
          new_line_2 = {
            order = 30,
            name = "",
            type = "description",
          },
          show_swipe = {
            order = 30.1,
            name = L["show_swipe_name"],
            desc = L["show_swipe_desc"],
            type = "toggle",
            get = get_status,
            set = set_status,
          },
          reverse_swipe = {
            disabled = function()
              return not addon.db.profile.AuraGroups.aura_groups[gorup_name].show_swipe
            end,
            order = 30.2,
            name = L["reverse_swipe_name"],
            desc = L["reverse_swipe_desc"],
            type = "toggle",
            get = get_status,
            set = set_status,
          },
          show_edge = {
            order = 30.3,
            name = L["show_edge_name"],
            desc = L["show_edge_desc"],
            type = "toggle",
            get = get_status,
            set = set_status,
          },
          show_tooltip = {
            order = 30.4,
            name = L["show_tooltip_name"],
            desc = L["show_tooltip_desc"],
            type = "toggle",
            get = get_status,
            set = set_status,
          },
        }
      },
      menu_band = {
        order = 2,
        name = " ",
        type = "group",
        inline = true,
        args = {
          add_aura_to_grp = {
            order = 1,
            name = L["add_aura_to_grp_name"],
            desc = L["add_aura_to_grp_desc"],
            type = "input",
            pattern = "^%d+$", -- only digits from 0 - 9
            usage = L["spell_id_wrong_input_notification"],
            set = function(_, value)
              local spell_id = tonumber(value)
              for other_goup_name, _ in next, addon.db.profile.AuraGroups.aura_groups do
                for other_spell_id, _ in next, addon.db.profile.AuraGroups.aura_groups[other_goup_name].auras do
                  if spell_id == other_spell_id then
                    addon:Print("Aura already in group " .. other_goup_name)
                    return
                  end
                end
              end
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id] = {
                prio = 1,
                track_if_present = true,
                own_only = true,
                show_glow = false,
                track_if_missing = false,
              }
              update_options() -- this will only update the options table.

              addon:GetAuraGroupOptions() -- this is used to update the aura groups options (the spell icons)
              local options_frame = addon:GetOptionsFrame()
              options_frame.container:ReleaseChildren()
              ACD:Open("RaidFrameSettings_Aura_Group_Options_Tab", options_frame.container)
              addon:ReloadModule("AuraGroups")
            end,
          },
          hide_indicator_settings = {
            order = 2,
            name = function()
              if addon.db.profile.AuraGroups.aura_groups[gorup_name].hide_indicator_settings then
                return L["settings_toggle_button_show_name"]
              else
                return L["settings_toggle_button_hide_name"]
              end
            end,
            desc = function()
              if addon.db.profile.AuraGroups.aura_groups[gorup_name].hide_indicator_settingss then
                return L["settings_toggle_button_show_desc"]
              else
                return L["settings_toggle_button_hide_desc"]
              end
            end,
            type = "execute",
            func = function()
              if addon.db.profile.AuraGroups.aura_groups[gorup_name].hide_indicator_settings then
                addon.db.profile.AuraGroups.aura_groups[gorup_name].hide_indicator_settings = false
              else
                addon.db.profile.AuraGroups.aura_groups[gorup_name].hide_indicator_settings = true
              end
              update_options()
            end
          },
        },
      },
    }

    for spell_id, info in next, addon.db.profile.AuraGroups.aura_groups[gorup_name].auras do
      -- Gather spell infos
      local string_id = tostring(spell_id)
      local is_valid_id = #string_id < 10 -- Passing spellIds with more than 9 integers to the C_Spell API will cause a stack overflow error.
      local spell_obj = is_valid_id and Spell:CreateFromSpellID(spell_id) or nil
      local spell_name = spell_obj and spell_obj:GetSpellName() or "|cffff0000aura not found|r"
      local is_spell = not ( spell_name == "|cffff0000aura not found|r" )

      options.args[string_id] = {
        order = 3 + addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].prio,
        name = "",
        type = "group",
        inline = true,
        args = {
          space = {
            order = 1,
            name = "",
            type = "description",
            width = 0.05,
          },
          prio = {
            order = 2,
            name = L["aura_prio_name"],
            desc = L["aura_prio_desc"],
            type = "select",
            values = {"1", "2", "3", "4", "5", "6", "7", "8"},
            sorting = {1, 2, 3, 4, 5, 6, 7, 8},
            get = function()
              return addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].prio
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].prio = value
              addon:ReloadModule("AuraGroups")
              update_options()
            end,
            width = 0.3,
          },
          space_2 = {
            order = 3,
            name = "",
            type = "description",
            width = 0.05,
          },
          icon = {
            order = 4,
            name = spell_name .. " ( "  .. string_id .. " )",
            image = spell_obj and spell_obj:GetSpellTexture() or "Interface\\ICONS\\INV_Misc_QuestionMark.blp",
            imageWidth = 24,
            imageHeight = 24,
            imageCoords = {0.1,0.9,0.1,0.9},
            type = "description",
            width = 2,
          },
          track_if_present = {
            disabled = function()
              return not is_spell
            end,
            order = 5,
            name = L["aura_groups_track_if_present_name"],
            desc = L["aura_groups_track_if_present_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].track_if_present
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].track_if_present = value
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          own_only = {
            disabled = function()
              return not is_spell
            end,
            order = 6,
            name = L["aura_groups_own_only_name"],
            desc = L["aura_groups_own_only_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].own_only
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].own_only = value
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          show_glow = {
            disabled = function()
              return not is_spell or not addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].track_if_present
            end,
            order = 7,
            name = L["aura_groups_show_glow_name"],
            desc = L["aura_groups_show_glow_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].show_glow
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].show_glow = value
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          track_if_missing = {
            disabled = not is_spell,
            order = 8,
            name = L["aura_groups_track_if_missing_name"],
            desc = L["aura_groups_track_if_missing_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].track_if_missing
            end,
            set = function(_, value)
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id].track_if_missing = value
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.6,
          },
          remove_btn = {
            order = 9,
            image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Remove.tga",
            imageWidth = 22,
            imageHeight = 22,
            name = "",
            desc = "",
            type = "execute",
            func = function()
              addon.db.profile.AuraGroups.aura_groups[gorup_name].auras[spell_id] = nil
              update_options()
              addon:GetAuraGroupOptions() -- this is used to update the aura groups options (the spell icons)
              local options_frame = addon:GetOptionsFrame()
              options_frame.container:ReleaseChildren()
              ACD:Open("RaidFrameSettings_Aura_Group_Options_Tab", options_frame.container)
              addon:ReloadModule("AuraGroups")
            end,
            width = 0.1,
          }
        },
      }
    end
  end

  update_options()
end

function addon:GetEditAuraGroupOptions()
  return options
end
