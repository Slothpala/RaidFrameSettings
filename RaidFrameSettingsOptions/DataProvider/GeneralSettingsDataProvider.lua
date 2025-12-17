local addon_name, private = ...
local main_addon = _G["RaidFrameSettings"]
local data_base = main_addon.db
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

local data_provider = CreateTreeDataProvider()
private.DataHandler.RegisterDataProvider("general_settings", data_provider)

local color_mode_options = {
  [1] = L["class"],
  [2] = L["class_gradient"],
  [3] = L["static"],
  [4] = L["static_gradient"],
  [5] = L["health_value"],
  [6] = L["power_type"],
  [7] = L["power_type_gradient"],
}

local options = {
  -- Colors.
  [1] = {
    title = {
      order = 1,
      type = "title",
      settings_text = L["title_colors"],
    },
    health_bar_fg = {
      order = 2,
      type = "color_mode",
      settings_text = L["health_bar_fg"],
      db_obj = data_base.profile.health_bars.fg,
      color_modes = {
        {color_mode_options[1], 1},
        {color_mode_options[2], 2},
        {color_mode_options[3], 3},
        {color_mode_options[4], 4},
        {color_mode_options[5], 5},
      },
      associated_modules = {
        "HealthBarForeground_Color",
      },
    },
    health_bar_bg = {
      order = 3,
      type = "color_mode",
      settings_text = L["health_bar_bg"],
      db_obj = data_base.profile.health_bars.bg,
      color_modes = {
        {color_mode_options[1], 1},
        {color_mode_options[2], 2},
        {color_mode_options[3], 3},
        {color_mode_options[4], 4},
      },
      associated_modules = {
        "HealthBarBackground_Color"
      },
    },
    power_bar_fg = {
      order = 4,
      type = "color_mode",
      settings_text = L["power_bar_fg"],
      db_obj = data_base.profile.power_bars.fg,
      color_modes = {
        {color_mode_options[3], 3},
        {color_mode_options[4], 4},
        {color_mode_options[6], 6},
        {color_mode_options[7], 7},
      },
      associated_modules = {
        "PowerBarForeground_Color",
      },
    },
    power_bar_bg = {
      order = 5,
      type = "color_mode",
      settings_text = L["power_bar_bg"],
      db_obj = data_base.profile.power_bars.bg,
      color_modes = {
        {color_mode_options[3], 3},
        {color_mode_options[4], 4},
        {color_mode_options[6], 6},
        {color_mode_options[7], 7},
      },
      associated_modules = {
        "PowerBarBackground_Color",
      },
    },
    border_color = {
      order = 6,
      type = "color",
      settings_text = L["border_color"],
      db_obj = data_base.profile.module_data.UnitFrameBorder,
      db_key = "border_color",
      associated_modules = {
        "UnitFrameBorder",
      },
    },
  },
  -- Textures.
  [2] = {
    title = {
      order = 1,
      type = "title",
      settings_text = L["textures"],
    },
    health_bar_fg = {
      order = 2,
      type = "lsm_texture",
      settings_text = L["health_bar_fg"],
      db_obj = data_base.profile.health_bars.fg,
      associated_modules = {
        "HealthBarForeground_Texture"
      },
    },
    health_bar_bg = {
      order = 3,
      type = "lsm_texture",
      settings_text = L["health_bar_bg"],
      db_obj = data_base.profile.health_bars.bg,
      associated_modules = {
        "HealthBarBackground_Texture",
      },
    },
    power_bar_fg = {
      order = 4,
      type = "lsm_texture",
      settings_text = L["power_bar_fg"],
      db_obj = data_base.profile.power_bars.fg,
      associated_modules = {
        "PowerBarForeground_Texture",
      },
    },
    power_bar_bg = {
      order = 5,
      type = "lsm_texture",
      settings_text = L["power_bar_bg"],
      db_obj = data_base.profile.power_bars.bg,
      associated_modules = {
        "PowerBarBackground_Texture",
      },
    }
  },
  -- Unit Frames.
  [3] = {
    title = {
      order = 1,
      type = "title",
      settings_text = L["blizzard_settings_unit_frames"],
    },
    display_pets = {
      order = 2,
      type = "toggle",
      settings_text = L["display_pets"],
      db_obj = data_base.profile.cvars,
      db_key = "raidOptionDisplayPets",
      associated_modules = {
        "CVar_raidOptionDisplayPets"
      },
    },
    display_power_bars = {
      order = 3,
      type = "dropdown",
      settings_text = L["option_power_bars"],
      db_obj = data_base.profile.module_data,
      db_key = "power_bar_display_mode",
      options = {
        {L["option_show"] , 1},
        {L["option_healer_only"] , 2},
        {L["option_hide"] , 3},
      },
      associated_modules = {
        "CVar_raidFramesDisplayPowerBars",
        "CVar_raidFramesDisplayOnlyHealerPowerBars",
        "CVar_pvpFramesDisplayPowerBars",
        "CVar_pvpFramesDisplayOnlyHealerPowerBars",
      },
    },
    health_text_display_mode = {
      order = 4,
      type = "dropdown",
      settings_text = L["option_health_text_display_mode"],
      db_obj = data_base.profile.module_data,
      db_key = "health_text_display_mode",
      options = {
        {L["option_health_none"] , "none"},
        {L["option_health_health"] , "health"},
        {L["option_health_lost"] , "losthealth"},
        {L["option_health_perc"] , "perc"},
      },
      associated_modules = {
        "CVar_raidFramesHealthText",
        "CVar_pvpFramesHealthText",
      },
    },
  },
}

for _, category in ipairs(options) do
  local order_tbl = {}
  for _, option in pairs(category) do
    order_tbl[option.order or #order_tbl] = option
  end
  for _, option in ipairs(order_tbl) do
    data_provider:Insert(option)
  end
end
