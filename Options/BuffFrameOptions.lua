--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


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

local locale_growth_direction_vertical = {
  [1] = L["growth_direction_up"],
  [2] = L["growth_direction_down"],
}

local locale_growth_direction_horizontal = {
  [1] = L["growth_direction_left"],
  [2] = L["growth_direction_right"],
}

local options = {
  name = " ", -- required field but will never be shown.
  handler = addon,
  type = "group",
  childGroups = "tab",
  args = {
  },
}

local function update_options()

  local update_blacklist = function()
    -- defined below options
  end

  local update_watchlist = function()
    -- defined below options
  end

  options.args = {
    BuffFrame = {
      hidden = function()
        return addon.db.profile.BuffFrame.hide_indicator_settings
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
          get = "GetFramePoint",
          set = "SetFramePoint",
          width = 0.6,
        },
        relative_point = {
          order = 2,
          name = L["relative_point_name"],
          desc = L["relative_point_desc"],
          type = "select",
          values = locale_frame_points,
          get = "GetFramePoint",
          set = "SetFramePoint",
          width = 0.6,
        },
        offset_x = {
          order = 3,
          name = L["offset_x_name"],
          desc = L["offset_x_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetVerticalGrwothDirection",
          set = "SetVerticalGrwothDirection",
          width = 0.6,
        },
        num_indicators_per_column = {
          order = 20.2,
          name = L["num_indicators_per_column_name"],
          desc = L["num_indicators_per_column_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0,
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
          get = "GetHorizontalGrwothDirection",
          set = "SetHorizontalGrwothDirection",
          width = 0.6,
        },
        num_indicators_per_row = {
          order = 20.4,
          name = L["num_indicators_per_row_name"],
          desc = L["num_indicators_per_row_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0,
          max = 10,
          step = 1,
          width = 0.6,
        },
        horizontal_padding = {
          order = 20.5,
          name = L["horizontal_padding_name"],
          desc = L["padding_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetStatus",
          set = "SetStatus",
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
          get = "GetColor",
          set = "SetColor",
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
          get = "GetStatus",
          set = "SetStatus",
        },
        reverse_swipe = {
          disabled = function()
            return not addon.db.profile.BuffFrame.show_swipe
          end,
          order = 30.2,
          name = L["reverse_swipe_name"],
          desc = L["reverse_swipe_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        show_edge = {
          order = 30.3,
          name = L["show_edge_name"],
          desc = L["show_edge_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        show_tooltip = {
          order = 30.4,
          name = L["show_tooltip_name"],
          desc = L["show_tooltip_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
      },
    },
    MenuBand = {
      order = 2,
      name = L["aura_meanu_band_name"],
      type = "group",
      inline = true,
      args = {
        add_to_blacklist = {
          order = 1,
          name = L["add_to_blacklist_name"],
          desc = L["spell_id_input_field_desc"],
          type = "input",
          pattern = "^%d+$", -- only digits from 0 - 9
          usage = L["spell_id_wrong_input_notification"],
          set = function(_, value)
            local spell_id = tonumber(value)
            addon.db.profile.BuffFrame.blacklist[spell_id] = true
            update_options() -- this will only update the options table.
            addon:ReloadModule("BuffFrame")
          end,
        },
        add_to_watchlist = {
          order = 2,
          name = L["add_to_watchlist_name"],
          desc = L["spell_id_input_field_desc"],
          type = "input",
          pattern = "^%d+$", -- only digits from 0 - 9
          usage = L["spell_id_wrong_input_notification"],
          set = function(_, value)
            local spell_id = tonumber(value)
            addon.db.profile.BuffFrame.watchlist[spell_id] = {
              own_only = true,
              show_glow = false,
            }
            update_options() -- this will only update the options table.
            addon:ReloadModule("BuffFrame")
          end,
        },
        hide_indicator_settings = {
          order = 3,
          name = function()
            if addon.db.profile.BuffFrame.hide_indicator_settings then
              return L["settings_toggle_button_show_name"]
            else
              return L["settings_toggle_button_hide_name"]
            end
          end,
          desc = function()
            if addon.db.profile.BuffFrame.hide_indicator_settings then
              return L["settings_toggle_button_show_desc"]
            else
              return L["settings_toggle_button_hide_desc"]
            end
          end,
          type = "execute",
          func = function()
            if addon.db.profile.BuffFrame.hide_indicator_settings then
              addon.db.profile.BuffFrame.hide_indicator_settings = false
            else
              addon.db.profile.BuffFrame.hide_indicator_settings = true
            end
          end
        },
      },
    },
    blacklist = {
      order = 3,
      name = L["blacklist_name"],
      type = "group",
      args = {
      },
    },
    watchlist = {
      order = 4,
      name = L["watchlist_name"],
      type = "group",
      args = {
      },
    },
  }

  update_blacklist = function()
    for spell_id, _ in next, addon.db.profile.BuffFrame.blacklist do
      -- Gather spell infos
      local string_id = tostring(spell_id)
      local is_valid_id = #string_id < 10 -- Passing spellIds with more than 9 integers to the C_Spell API will cause a stack overflow error.
      local spell_obj = is_valid_id and Spell:CreateFromSpellID(spell_id) or nil
      local spell_name = spell_obj and spell_obj:GetSpellName() or "|cffff0000aura not found|r"

      options.args.blacklist.args[string_id] = {
        order = spell_id,
        name = "",
        type = "group",
        inline = true,
        args = {
          icon = {
            order = 1,
            name = spell_name .. " ( "  .. string_id .. " )",
            image = spell_obj and spell_obj:GetSpellTexture() or "Interface\\ICONS\\INV_Misc_QuestionMark.blp",
            imageWidth = 24,
            imageHeight = 24,
            imageCoords = {0.1,0.9,0.1,0.9},
            type = "description",
            width = 1.5,
          },
          remove_btn = {
            order = 2,
            name = L["remove_button_name"],
            desc = L["remove_button_name"] .. " " .. spell_name .. " " .. L["remove_button_desc"],
            type = "execute",
            func = function()
              addon.db.profile.BuffFrame.blacklist[spell_id] = nil
              update_options()
              addon:ReloadModule("BuffFrame")
            end,
            width = 0.5,
          }
        }
      }
    end
  end

  update_watchlist = function()
    for spell_id, _ in next, addon.db.profile.BuffFrame.watchlist do
      -- Gather spell infos
      local string_id = tostring(spell_id)
      local is_valid_id = #string_id < 10 -- Passing spellIds with more than 9 integers to the C_Spell API will cause a stack overflow error.
      local spell_obj = is_valid_id and Spell:CreateFromSpellID(spell_id) or nil
      local spell_name = spell_obj and spell_obj:GetSpellName() or "|cffff0000aura not found|r"

      options.args.watchlist.args[string_id] = {
        order = spell_id,
        name = "",
        type = "group",
        inline = true,
        args = {
          icon = {
            order = 1,
            name = spell_name .. " ( "  .. string_id .. " )",
            image = spell_obj and spell_obj:GetSpellTexture() or "Interface\\ICONS\\INV_Misc_QuestionMark.blp",
            imageWidth = 24,
            imageHeight = 24,
            imageCoords = {0.1,0.9,0.1,0.9},
            type = "description",
            width = 1.5,
          },
          own_only = {
            order = 2,
            name = L["aura_groups_own_only_name"],
            desc = L["aura_groups_own_only_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.BuffFrame.watchlist[spell_id].own_only
            end,
            set = function(_, value)
              addon.db.profile.BuffFrame.watchlist[spell_id].own_only = value
              addon:ReloadModule("BuffFrame")
            end
          },
          show_glow = {
            order = 3,
            name = L["aura_groups_show_glow_name"],
            desc = L["aura_groups_show_glow_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.BuffFrame.watchlist[spell_id].show_glow
            end,
            set = function(_, value)
              addon.db.profile.BuffFrame.watchlist[spell_id].show_glow = value
              addon:ReloadModule("BuffFrame")
            end
          },
          remove_btn = {
            order = 4,
            name = L["remove_button_name"],
            desc = L["remove_button_name"] .. " " .. spell_name .. " " .. L["remove_button_desc"],
            type = "execute",
            func = function()
              addon.db.profile.BuffFrame.watchlist[spell_id] = nil
              update_options()
              addon:ReloadModule("BuffFrame")
            end,
            width = 0.5,
          }
        }
      }
    end
  end

  update_blacklist()
  update_watchlist()
end



function addon:GetBuffFrameOptions()
  update_options()
  return options
end
