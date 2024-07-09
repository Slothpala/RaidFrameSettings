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
  childGroups = "tree",
  args = {
    DefensiveOverlay = {
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
            return not addon.db.profile.DefensiveOverlay.show_swipe
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
  },
}

local class_icon_coords = {
  ["DEATHKNIGHT"] = {0.00048828125, 0.06298828125, 0.0009765625, 0.1259765625},
  ["DEMONHUNTER"] = {0.00048828125, 0.06298828125, 0.1279296875, 0.2529296875},
  ["DRUID"] = {0.00048828125, 0.06298828125, 0.2548828125, 0.3798828125},
  ["EVOKER"] = {0.00048828125, 0.06298828125, 0.3818359375, 0.5068359375},
  ["HUNTER"] = {0.00048828125, 0.06298828125, 0.5087890625, 0.6337890625},
  ["MAGE"] = {0.00048828125, 0.06298828125, 0.6357421875, 0.7607421875},
  ["MONK"] = {0.00048828125, 0.06298828125, 0.7626953125, 0.8876953125},
  ["PALADIN"] = {0.06396484375, 0.12646484375, 0.0009765625, 0.1259765625},
  ["PRIEST"] = {0.06396484375, 0.12646484375, 0.1279296875, 0.2529296875},
  ["ROGUE"] = {0.06396484375, 0.12646484375, 0.2548828125, 0.3798828125},
  ["SHAMAN"] = {0.06396484375, 0.12646484375, 0.3818359375, 0.5068359375},
  ["WARLOCK"] = {0.06396484375, 0.12646484375, 0.5087890625, 0.6337890625},
  ["WARRIOR"] = {0.06396484375, 0.12646484375, 0.6357421875, 0.7607421875},
}

local function create_class_options()
  local class_cooldowns = addon:ClassCooldowns_GetDB()
  local i = 2
  for class, icon_coords in next, class_icon_coords do
    -- create the class entry
    local class_group = {
      order = i,
      name = LOCALIZED_CLASS_NAMES_MALE[class],
      type = "group",
      icon = "Interface\\AddOns\\RaidFrameSettings\\Textures\\CharacterCreateIcons.BLP",
      iconCoords = icon_coords,
      args = {

      },
    }
    -- get all spell infos
    for spell_id, _ in next, class_cooldowns[class].defensive do
      local spell_obj = Spell:CreateFromSpellID(spell_id)
      local spell_name = spell_obj:GetSpellName()
      local string_id = tostring(spell_id)
      class_group.args[string_id .. "_toggle"] = {
        order = i,
        name = spell_name,
        type = "toggle",
        desc = spell_obj:GetSpellDescription(),
        get = function()
          return addon.db.profile.DefensiveOverlay[spell_id]
        end,
        set = function(_, value)
          addon.db.profile.DefensiveOverlay[spell_id] = value
          addon:ReloadModule("DefensiveOverlay")
        end,
        width = 0.15,
      }
      i = i + 1
      class_group.args[string_id .. "_icon"] = {
        order = i,
        name = spell_name,
        image = spell_obj:GetSpellTexture(),
        imageWidth = 32,
        imageHeight = 32,
        imageCoords = {0.1,0.9,0.1,0.9},
        type = "description",
        width = 1.5,
      }
      i = i + 1
      class_group.args[string_id .. "_new_line"] = {
        order = i,
        name = "",
        type = "description",
      }
      i = i + 1
    end
    -- store it in the options table
    options.args[class] = class_group
  end
end

function addon:GetDefensiveOverlayOptions()
  create_class_options()
  return options
end
