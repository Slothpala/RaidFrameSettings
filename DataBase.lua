--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local default_duration_font = "LTSaeada-Medium"
local default_duration_font_size = 10
local default_duration_font_color = {1, 1, 1, 1}
local default_stack_font = "LTSaeada-Medium"
local default_stack_font_size = 11
local default_stack_font_color = {1, 0.4118, 0.7059, 1}

local defaults = {
  profile = {
    db_version = 3.0, -- This is used to check if imported profiles are compatible with the current db.
    ["**"] = {
      enabled = true,
    },
    BuffHighlight = {
      enabled = false,
      operation_mode = 2, -- 1: Highlight when present, 2: Highlight when missing.
      highlight_color = {0, 0.8, 0.8, 1},
      auras = {
      },
    },
    SoloFrame = {
      enabled = false,
    },
    Nicknames = {
    },
    AuraGroupsDurationFont = {
      point = "TOPLEFT",
      relative_point = "TOPLEFT",
      offset_x = 0,
      offset_y = 0,
      font = default_duration_font,
      font_size = default_duration_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_duration_font_color,
    },
    AuraGroupsStackFont = {
      point = "BOTTOMRIGHT",
      relative_point = "BOTTOMRIGHT",
      offset_x = 0,
      offset_y = 0,
      font = default_stack_font,
      font_size = default_stack_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_stack_font_color,
    },
    AuraGroups = {
      aura_groups = {
        ["**"] = {
          name = "AURA_GROUP",
          point = "CENTER",
          relative_point = "CENTER",
          offset_x = 0,
          offset_y = 0,
          -- Num indicators row*column
          num_indicators_per_row = 2,
          num_indicators_per_column = 1,
          -- Orientation
          direction_of_growth_vertical = "DOWN",
          vertical_padding = 1,
          direction_of_growth_horizontal = "LEFT",
          horizontal_padding = 1,
          -- Indicator size
          indicator_width = 22,
          indicator_height = 22,
          -- Indicator border
          indicator_border_thickness = 1,
          indicator_border_color = {0.5, 0.5, 0.5, 1},
          -- Cooldown
          show_swipe = false,
          -- swipe_color = {1, 1, 1, 1}, --@TODO: find out why Cooldown:SetSwipeColor(colorR, colorG, colorB [, a]) just ignores the color setting.
          reverse_swipe = false,
          show_edge = false,
          show_cooldown_numbers = true,
          -- Tooltip
          show_tooltip = false,
          auras = {},
        },
      },

    },
    DebuffHighlight = {
      operation_mode = 1, -- 1: Smart Mode, 2: Manual Mode
      Curse = true,
      Disease = true,
      Magic = true,
      Poison = true,
      highlight_texture = "RFS_HealthBar_Striped",
    },
    -- DefensiveOverlay Font Settings
    DefensiveOverlayDurationFont = {
      point = "TOPLEFT",
      relative_point = "TOPLEFT",
      offset_x = 0,
      offset_y = 0,
      font = default_duration_font,
      font_size = default_duration_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_duration_font_color,
    },
    DefensiveOverlayStackFont = {
      point = "BOTTOMRIGHT",
      relative_point = "BOTTOMRIGHT",
      offset_x = 0,
      offset_y = 0,
      font = default_stack_font,
      font_size = default_stack_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_stack_font_color,
    },
    DefensiveOverlay = {
      -- Position
      point = "CENTER",
      relative_point = "CENTER",
      offset_x = 0,
      offset_y = 0,
      -- Num indicators row*column
      num_indicators_per_row = 1,
      num_indicators_per_column = 1,
      -- Orientation
      direction_of_growth_vertical = "DOWN",
      vertical_padding = 1,
      direction_of_growth_horizontal = "RIGHT",
      horizontal_padding = 1,
      -- Indicator size
      indicator_width = 24,
      indicator_height = 24,
      -- Indicator border
      indicator_border_thickness = 1,
      indicator_border_color = {0, 1, 0, 1},
      -- Cooldown
      show_swipe = false,
      -- swipe_color = {1, 1, 1, 1}, --@TODO: find out why Cooldown:SetSwipeColor(colorR, colorG, colorB [, a]) just ignores the color setting.
      reverse_swipe = false,
      show_edge = false,
      show_cooldown_numbers = true,
      -- Tooltip
      show_tooltip = false,
      auras = {
        ["*"] = {
          track = true,
        }
      }
    },
    BuffFrameDurationFont = {
      point = "TOPLEFT",
      relative_point = "TOPLEFT",
      offset_x = 0,
      offset_y = 0,
      font = default_duration_font,
      font_size = default_duration_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_duration_font_color,
    },
    BuffFrameStackFont = {
      point = "BOTTOMRIGHT",
      relative_point = "BOTTOMRIGHT",
      offset_x = 0,
      offset_y = 0,
      font = default_stack_font,
      font_size = default_stack_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_stack_font_color,
    },
    BuffFrame = {
      hide_indicator_settings = false,
      -- Position
      point = "BOTTOMRIGHT",
      relative_point = "BOTTOMRIGHT",
      offset_x = -2,
      offset_y = 2,
      -- Num indicators row*column
      num_indicators_per_row = 2,
      num_indicators_per_column = 2,
      -- Orientation
      direction_of_growth_vertical = "UP",
      vertical_padding = 1,
      direction_of_growth_horizontal = "LEFT",
      horizontal_padding = 1,
      -- Indicator size
      indicator_width = 22,
      indicator_height = 22,
      -- Indicator border
      indicator_border_thickness = 1,
      indicator_border_color = {0.5, 0.5, 0.5, 1},
      -- Cooldown
      show_swipe = false,
      -- swipe_color = {1, 1, 1, 1}, --@TODO: find out why Cooldown:SetSwipeColor(colorR, colorG, colorB [, a]) just ignores the color setting.
      reverse_swipe = false,
      show_edge = false,
      show_cooldown_numbers = true,
      -- Tooltip
      show_tooltip = true,
      blacklist = {},
      watchlist = {},
    },
    DebuffFrameDurationFont = {
      point = "TOPLEFT",
      relative_point = "TOPLEFT",
      offset_x = 0,
      offset_y = 0,
      font = default_duration_font,
      font_size = default_duration_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_duration_font_color,
    },
    DebuffFrameStackFont = {
      point = "BOTTOMRIGHT",
      relative_point = "BOTTOMRIGHT",
      offset_x = 0,
      offset_y = 0,
      font = default_stack_font,
      font_size = default_stack_font_size,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = default_stack_font_color,
    },
    DebuffFrame = {
      hide_indicator_settings = false,
      show_only_raid_auras = true,
      -- Position
      point = "BOTTOMLEFT",
      relative_point = "BOTTOMLEFT",
      priv_point = "CENTER",
      priv_relative_point = "CENTER",
      offset_x = 2,
      offset_y = 2,
      -- Num indicators row*column
      num_indicators_per_row = 3,
      num_indicators_per_column = 1,
      -- Orientation
      direction_of_growth_vertical = "UP",
      vertical_padding = 1,
      direction_of_growth_horizontal = "RIGHT",
      horizontal_padding = 1,
      -- Indicator size
      indicator_width = 22,
      indicator_height = 22,
      increase_factor = 1.3,
      -- Indicator border
      indicator_border_thickness = 1,
      indicator_border_color = {0.8, 0.2, 0.2, 1},
      indicator_border_by_dispel_color = true,
      duration_font_by_dispel_color = true,
      -- Cooldown
      show_swipe = false,
      -- swipe_color = {1, 1, 1, 1}, --@TODO: find out why Cooldown:SetSwipeColor(colorR, colorG, colorB [, a]) just ignores the color setting.
      reverse_swipe = false,
      show_edge = false,
      show_cooldown_numbers = true,
      -- Tooltip
      show_tooltip = true,
      blacklist = {},
      watchlist = {},
      increased_auras = {},
    },
    Overabsorb = {
      glow_alpha = 1,
    },
    RoleIcon = {
      point = "TOPRIGHT",
      relative_point = "TOPRIGHT",
      offset_x = -4,
      offset_y = -4,
      scale_factor = 1,
      show_for_dps = false,
      show_for_heal = true,
      show_for_tank = true,
    },
    Resizer = {
      enabled = false,
      party_frame_container_scale_factor  = 1.2,
      raid_frame_container_scale_factor = 1.2,
      arena_frame_container_scale_factor = 1.2,
    },
    Range = {
      out_of_range_foregorund_alpha = 0.3,
      out_of_range_background_alpha = 0.3,
      use_out_of_range_background_color = true,
      out_of_range_background_color = {0, 0, 0},
    },
    Texture = {
      health_bar_foreground_texture = "RFS_HealthBar",
      health_bar_background_texture = "Solid",
      power_bar_foreground_texture = "RFS_PowerBar",
      power_bar_background_texture = "Solid",
      detach_power_bar = true,
      power_bar_width = 0.8,
      power_bar_height = 0.08,
      point = "BOTTOM",
      relative_point = "BOTTOM",
      offset_x = 0,
      offset_y = 7,
    },
    -- Name
    NameFont = {
      point = "TOP",
      relative_point = "TOP",
      offset_x = 0,
      offset_y = -5,
      font = "Poppins-Regular",
      font_size = 12,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = {1, 1, 1},
      class_colored = false,
      show_server = false,
    },
    StatusFont = {
      point = "CENTER",
      relative_point = "CENTER",
      offset_x = 0,
      offset_y = -5,
      font = "LTSuperiorMono-Regular",
      font_size = 12,
      font_outlinemode = "OUTLINE",
      horizontal_justification = "LEFT", -- can be: LEFT, CENTER, RIGHT
      vertical_justification = "MIDDLE", -- can be: TOP, MIDDLE, BOTTOM
      shadow_color = {0, 0, 0, 1},
      shadow_offset_x = 1,
      shadow_offset_y = -1,
      text_color = {0.9, 0.9, 0.9},
      class_colored = false,
    },
    RaidFrameColor = {
      -- Border
      health_bar_border_color = {0, 1, 0},
      -- Health foreground
      health_bar_foreground_color_mode = 1, -- 1: Class/Reaction color. 2: Static Color.
      health_bar_foreground_use_gradient_colors = false,
      health_bar_foreground_static_min_color = {1, 1, 1, 1},
      health_bar_foreground_static_max_color = {0, 0, 0, 1},
      health_bar_foreground_static_normal_color = {0.1, 0.1, 0.1, 1},
      -- Health background
      health_bar_background_use_gradient_colors = false,
      health_bar_background_static_min_color = {0.6, 0, 0, 1},
      health_bar_background_static_max_color = {0, 0, 0, 1},
      health_bar_background_static_normal_color = {0.22, 0.22, 0.22, 1},
      -- Power foreground
      power_bar_foreground_color_mode = 1,
      power_bar_foreground_use_gradient_colors = false,
      power_bar_foreground_static_min_color = {1, 1, 1, 1},
      power_bar_foreground_static_max_color = {0, 0, 1, 1},
      power_bar_foreground_static_normal_color = {1, 1, 1, 1},
      -- Power background
      power_bar_background_use_gradient_colors = false,
      power_bar_background_static_min_color = {0, 0, 0, 1},
      power_bar_background_static_max_color = {0.33, 0.33, 0.33, 1},
      power_bar_background_static_normal_color = {0.28, 0.28, 0.28, 1},
    },
    AddOnColors = {
      -- Class
      class_colors = {
        DEATHKNIGHT = {
          min_color = {0.77, 0.12, 0.23},
          max_color = {0, 0, 0},
          normal_color = {0.77,  0.12, 0.23},
        },
        DEMONHUNTER = {
          min_color = {0.64, 0.19, 0.79},
          max_color = {0, 0, 0},
          normal_color = {0.64,  0.19, 0.79},
        },
        DRUID = {
          min_color = {1, 0.49, 0.04},
          max_color = {0, 0, 0},
          normal_color = {1,  0.49, 0.04},
        },
        EVOKER = {
          min_color = {0.2, 0.58, 0.50},
          max_color = {0, 0, 0},
          normal_color = {0.2,  0.58, 0.50},
        },
        HUNTER = {
          min_color = {0.67, 0.83, 0.45},
          max_color = {0, 0, 0},
          normal_color = {0.67,  0.83, 0.45},
        },
        MAGE = {
          min_color = {0.25, 0.78, 0.92},
          max_color = {0, 0, 0},
          normal_color = {0.25,  0.78, 0.92},
        },
        MONK = {
          min_color = {0, 1, 0.60},
          max_color = {0, 0, 0},
          normal_color = {0,  1, 0.60},
        },
        PALADIN = {
          min_color = {0.96, 0.55, 0.73},
          max_color = {0, 0, 0},
          normal_color = {0.96,  0.55, 0.73},
        },
        PRIEST = {
          min_color = {1, 1, 1},
          max_color = {0, 0, 0},
          normal_color = {1,  1, 1},
        },
        ROGUE = {
          min_color = {1, 0.96, 0.41},
          max_color = {0, 0, 0},
          normal_color = {1,  0.96, 0.41},
        },
        SHAMAN = {
          min_color = {0, 0.44, 0.87},
          max_color = {0, 0, 0},
          normal_color = {0,  0.44, 0.87},
        },
        WARLOCK = {
          min_color = {0.53, 0.53, 0.93},
          max_color = {0, 0, 0},
          normal_color = {0.53,  0.53, 0.93},
        },
        WARRIOR = {
          min_color = {0.78, 0.61, 0.43},
          max_color = {0, 0, 0},
          normal_color = {0.78,  0.61, 0.43},
        },
      },
      -- Power
      power_colors = {
        MANA = {
          min_color = {0, 0, 0, 1},
          max_color = {0, 0, 1, 1},
          normal_color = {0, 0, 1, 1},
        },
        RAGE = {
          min_color = {0, 0, 0, 1},
          max_color = {1, 0, 0, 1},
          normal_color = {1, 0, 0, 1},
        },
        FOCUS = {
          min_color = {0, 0, 0, 1},
          max_color = {1, 0.5, 0.25, 1},
          normal_color = {1, 0.5, 0.25, 1},
        },
        ENERGY = {
          min_color = {0, 0, 0, 1},
          max_color = {1, 1, 0, 1},
          normal_color = {1, 1, 0, 1},
        },
        RUNIC_POWER = {
          min_color = {0, 0, 0, 1},
          max_color = {0, 0.82, 1, 1},
          normal_color = {0, 0.82, 1, 1},
        },
        LUNAR_POWER = {
          min_color = {0, 0, 0, 1},
          max_color = {0.3, 0.52, 0.9, 1},
          normal_color = {0.3, 0.52, 0.9, 1},
        },
        MAELSTROM = {
          min_color = {0, 0, 0, 1},
          max_color = {0, 0.5, 1, 1},
          normal_color = {0, 0.5, 1, 1},
        },
        FURY = {
          min_color = {0, 0, 0, 1},
          max_color = {0.788, 0.259, 0.992, 1},
          normal_color = {0.788, 0.259, 0.992, 1},
        },
        INSANITY = {
          min_color = {0, 0, 0, 1},
          max_color = {0.4, 0, 0.8, 1},
          normal_color = {0.4, 0, 0.8, 1},
        },
      },
      -- Debuff
      dispel_type_colors = {
        Curse = {
          min_color = {0.5, 0, 0.9, 1},
          max_color = {0.6, 0, 1, 1},
          normal_color = {0.6, 0, 1, 1},
        },
        Disease = {
          min_color = {0.5, 0.3, 0, 1},
          max_color = {0.6, 0.4, 0, 1},
          normal_color = {0.6, 0.4, 0, 1},
        },
        Magic = {
          min_color = {0.1, 0.5, 0.9, 1},
          max_color = {0.2, 0.6, 1.0, 1},
          normal_color = {0.2, 0.6, 1.0, 1},
        },
        Poison = {
          min_color = {0, 0.5, 0, 1},
          max_color = {0, 0.6, 0, 1},
          normal_color = {0, 0.6, 0, 1},
        },
      },
    },
    MiniMapButton = {

    }
  },
  global = {
    options_frame = {
      scale = 0.7,
    },
    ["**"] = {
      party_profile = "Default",
      raid_profile = "Default",
      arena_profile = "Default",
      battleground_profile = "Default",
    },
  },

}

function addon:GetDefaultDbValues()
  return defaults
end

function addon:LoadDataBase()
  self.db = LibStub("AceDB-3.0"):New("RaidFrameSettingsDB", defaults, true)
  --db callbacks
  self.db.RegisterCallback(self, "OnProfileChanged", "ReloadConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "ReloadConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "ReloadConfig")
end

function addon:SetModuleStatus(info, value)
  local module_name = info[#info]
  self.db.profile[module_name].enabled = value
  if value == false then
    self:DisableModule(module_name)
  else
    self:EnableModule(module_name)
  end
  if module_name == "Texture" and self:IsModuleEnabled("DebuffHighlight") then
    self:ReloadModule("DebuffHighlight")
  end
  self:OptionsFrame_UpdateTabs()
end

function addon:GetModuleStatus(info)
  return self.db.profile[info[#info]].enabled
end

function addon:SetStatus(info, value)
  self.db.profile[info[#info-1]][info[#info]] = value
  self:ReloadModule(info[#info-1])
end

function addon:GetStatus(info)
  return self.db.profile[info[#info-1]][info[#info]]
end

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

function addon:SetFramePoint(info, value)
  self.db.profile[info[#info-1]][info[#info]] = frame_points[value]
  self:ReloadModule(info[#info-1])
end

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

function addon:GetFramePoint(info)
  return frame_points_reverse[self.db.profile[info[#info-1]][info[#info]]]
end

function addon:GetColor(info)
  local color = self.db.profile[info[#info-1]][info[#info]]
  return color[1], color[2], color[3], color[4] or 1
end

function addon:SetColor(info, r, g, b, a)
  local color = {
    [1] = r,
    [2] = g,
    [3] = b,
    [4] = a,
  }
  self.db.profile[info[#info-1]][info[#info]] = color
  self:ReloadModule(info[#info-1])
end

local font_flags = {
  [1] = "MONOCHROME",
  [2] = "MONOCHROMEOUTLINE",
  [3] = "MONOCHROMETHICKOUTLINE",
  [4] = "NONE",
  [5] = "OUTLINE",
  [6] = "THICKOUTLINE",
}

function addon:SetFontFlag(info, value)
  self.db.profile[info[#info-1]][info[#info]] = font_flags[value]
  self:ReloadModule(info[#info-1])
end

local font_flags_reverse = {
  ["MONOCHROME"] = 1,
  ["MONOCHROMEOUTLINE"] = 2,
  ["MONOCHROMETHICKOUTLINE"] = 3,
  ["NONE"] = 4,
  ["OUTLINE"] = 5,
  ["THICKOUTLINE"] = 6,
}

function addon:GetFontFlag(info)
  return font_flags_reverse[self.db.profile[info[#info-1]][info[#info]]]
end

local horizontal_justification = {
  [1] = "LEFT",
  [2] = "CENTER",
  [3] = "RIGHT",
}

function addon:SetHorizontalJustification(info, value)
  self.db.profile[info[#info-1]][info[#info]] = horizontal_justification[value]
  self:ReloadModule(info[#info-1])
end

local horizontal_justification_reverse = {
  ["LEFT"] = 1,
  ["CENTER"] = 2,
  ["RIGHT"] = 3,
}

function addon:GetHorizontalJustification(info)
  return horizontal_justification_reverse[self.db.profile[info[#info-1]][info[#info]]]
end

local vertical_justification = {
  [1] = "TOP",
  [2] = "MIDDLE",
  [3] = "BOTTOM",
}

function addon:SetVerticalJustification(info, value)
  self.db.profile[info[#info-1]][info[#info]] = vertical_justification[value]
  self:ReloadModule(info[#info-1])
end

local vertical_justification_reverse = {
  ["TOP"] = 1,
  ["MIDDLE"] = 2,
  ["BOTTOM"] = 3,
}

function addon:GetVerticalJustification(info)
  return vertical_justification_reverse[self.db.profile[info[#info-1]][info[#info]]]
end

local growth_direction_vertical = {
  [1] = "UP",
  [2] = "DOWN",
}

function addon:SetVerticalGrwothDirection(info, value)
  self.db.profile[info[#info-1]][info[#info]] = growth_direction_vertical[value]
  self:ReloadModule(info[#info-1])
end

local growth_direction_vertical_reverse = {
  ["UP"] = 1,
  ["DOWN"] = 2,
}

function addon:GetVerticalGrwothDirection(info)
  return growth_direction_vertical_reverse[self.db.profile[info[#info-1]][info[#info]]]
end

local growth_direction_horizontal = {
  [1] = "LEFT",
  [2] = "RIGHT",
}

function addon:SetHorizontalGrwothDirection(info, value)
  self.db.profile[info[#info-1]][info[#info]] = growth_direction_horizontal[value]
  self:ReloadModule(info[#info-1])
end

local growth_direction_horizontal_reverse = {
  ["LEFT"] = 1,
  ["RIGHT"] = 2,
}

function addon:GetHorizontalGrwothDirection(info)
  return growth_direction_horizontal_reverse[self.db.profile[info[#info-1]][info[#info]]]
end
