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
        show_cooldown_numbers = {
          order = 30.5,
          name = L["show_cooldown_numbers_name"],
          desc = L["show_cooldown_numbers_desc"],
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
  ["TRINKET"] = {0, 1, 0, 1},
}

local localized_class_names = LOCALIZED_CLASS_NAMES_MALE
localized_class_names["TRINKET"] = L["TRINKET"]

local function  update_class_options()
  local class_cooldowns = addon:ClassCooldowns_GetDB()
  local i = 2
  for class, icon_coords in next, class_icon_coords do
    -- create the class entry
    local class_group = {
      order = class == "TRINKET" and 1 or i,
      name = localized_class_names[class],
      type = "group",
      icon = class == "TRINKET" and "132778" or "Interface\\AddOns\\RaidFrameSettings\\Textures\\CharacterCreateIcons.BLP", -- 132778 = Unstable Arcanocrystal
      iconCoords = icon_coords,
      args = {},
    }
    -- get all spell infos
    for spell_id, spell_info in next, class_cooldowns[class].defensive do
      local spell_obj = Spell:CreateFromSpellID(spell_id)
      local spell_name = spell_obj:GetSpellName() or ""
      local db_spell_info = addon.db.profile.DefensiveOverlay.auras[spell_id]
      class_group.args[spell_name] = {
        order = db_spell_info.prio or spell_info.prio or 1,
        name = "",
        type = "group",
        inline = true,
        args = {
          prio = {
            order = 1,
            name = L["aura_prio_name"],
            desc = L["aura_prio_desc"],
            type = "select",
            values = {"1", "2", "3", "4", "5", "6", "7", "8"},
            sorting = {1, 2, 3, 4, 5, 6, 7, 8},
            get = function()
              return db_spell_info.prio or spell_info.prio or 1
            end,
            set = function(_, value)
              addon.db.profile.DefensiveOverlay.auras[spell_id].prio = value
              addon:ReloadModule("DefensiveOverlay")
              update_class_options()
            end,
            width = 0.3,
          },
          space = {
            order = 2,
            name = "",
            type = "description",
            width = 0.05,
          },
          icon = {
            order = 3,
            name = spell_name,
            image = spell_obj and spell_obj:GetSpellTexture() or "Interface\\ICONS\\INV_Misc_QuestionMark.blp",
            imageWidth = 24,
            imageHeight = 24,
            imageCoords = {0.1,0.9,0.1,0.9},
            type = "description",
            width = 1.5,
          },
          track = {
            order = 4,
            name = L["aura_groups_track_if_present_name"],
            desc = L["aura_groups_track_if_present_desc"] .. "\n\n" .. ( spell_obj:GetSpellDescription() or "" ),
            type = "toggle",
            get = function()
              return addon.db.profile.DefensiveOverlay.auras[spell_id].track
            end,
            set = function(_, value)
              addon.db.profile.DefensiveOverlay.auras[spell_id].track = value
              addon:ReloadModule("DefensiveOverlay")
              update_class_options()
            end,
            width = 0.6,
          },
        }
      }
      i = i + 1
    end
    -- store it in the options table
    options.args[class] = class_group
  end
end

function addon:GetDefensiveOverlayOptions()
  update_class_options()
  return options
end
