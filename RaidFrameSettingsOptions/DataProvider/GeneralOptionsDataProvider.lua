local addon_name, private = ...
local addon = _G["RaidFrameSettings"]
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

local data_provider = CreateTreeDataProvider()

local color_mode_options_health = {
  [1] = L["class"],
  [2] = L["class_gradient"],
  [3] = L["static"],
  [4] = L["static_gradient"],
  [5] = L["health_value"],
  [6] = L["power_type"],
  [7] = L["power_type_gradient"],
}

-- Category: Colors
local colors_title = {
  template = "RaidFrameSettings_HeaderTemplate",
  title = L["colors"] ,
}
data_provider:Insert(colors_title)

local colors_health_bar_fg = {
  template = "RaidFrameSettings_ColorModeTemplate",
  associated_modules = {
    "HealthBarForeground_Color",
  },
  settings_text = L["health_bar_fg"],
  db_obj = addon.db.profile.health_bars.fg,
  color_modes = {
    {color_mode_options_health[1], 1},
    {color_mode_options_health[2], 2},
    {color_mode_options_health[3], 3},
    {color_mode_options_health[4], 4},
    {color_mode_options_health[5], 6},
  },
}
data_provider:Insert(colors_health_bar_fg)

local colors_health_bar_bg = {
  template = "RaidFrameSettings_ColorModeTemplate",
  associated_modules = {
  },
  settings_text = L["health_bar_bg"],
  db_obj = addon.db.profile.health_bars.bg,
  color_modes = {
    {color_mode_options_health[1], 1},
    {color_mode_options_health[2], 2},
    {color_mode_options_health[3], 3},
    {color_mode_options_health[4], 4},
    {color_mode_options_health[5], 6},
  },
}
data_provider:Insert(colors_health_bar_bg)

local colors_power_bar_fg = {
  template = "RaidFrameSettings_ColorModeTemplate",
  associated_modules = {
  },
  settings_text = L["power_bar_fg"],
  db_obj = addon.db.profile.power_bars.fg,
  color_modes = {
    {color_mode_options_health[3], 3},
    {color_mode_options_health[4], 4},
    {color_mode_options_health[6], 6},
    {color_mode_options_health[7], 7},
  },
}
data_provider:Insert(colors_power_bar_fg)

local colors_power_bar_bg = {
  template = "RaidFrameSettings_ColorModeTemplate",
  associated_modules = {
  },
  settings_text = L["power_bar_bg"],
  db_obj = addon.db.profile.power_bars.bg,
  color_modes = {
    {color_mode_options_health[3], 3},
    {color_mode_options_health[4], 4},
    {color_mode_options_health[6], 6},
    {color_mode_options_health[7], 7},
  },
}
data_provider:Insert(colors_power_bar_bg)

-- Category: Textures
local textures_title = {
  template = "RaidFrameSettings_HeaderTemplate",
  title = L["textures"],
}
data_provider:Insert(textures_title)

local texture_health_bar_fg = {
  template = "RaidFrameSettings_DropdownSelectionTemplate_Texture",
  settings_text = L["health_bar_fg"],
  db_obj = addon.db.profile.health_bars.fg,
  associated_modules = {
    "HealthBarForeground_Texture"
  },
}
data_provider:Insert(texture_health_bar_fg)

local texture_health_bar_bg = {
  template = "RaidFrameSettings_DropdownSelectionTemplate_Texture",
  settings_text = L["health_bar_bg"],
  db_obj = addon.db.profile.health_bars.bg,
  associated_modules = {
  },
}
data_provider:Insert(texture_health_bar_bg)

local texture_power_bar_fg = {
  template = "RaidFrameSettings_DropdownSelectionTemplate_Texture",
  settings_text = L["power_bar_fg"],
  db_obj = addon.db.profile.power_bars.fg,
  associated_modules = {
  },
}
data_provider:Insert(texture_power_bar_fg)

local texture_power_bar_bg = {
  template = "RaidFrameSettings_DropdownSelectionTemplate_Texture",
  settings_text = L["power_bar_bg"],
  db_obj = addon.db.profile.power_bars.bg,
  associated_modules = {
  },
}
data_provider:Insert(texture_power_bar_bg)

-- Category: Fonts
local fonts_title = {
  template = "RaidFrameSettings_HeaderTemplate",
  title = L["fonts"],
}
data_provider:Insert(fonts_title)

local fonts_name_font = {
  template = "RaidFrameSettings_FontSelectionTemplate",
  settings_text = L["name_font"],
  db_obj = addon.db.profile.fonts.name,
  associated_modules = {
  },
}
data_provider:Insert(fonts_name_font)

local fonts_name_color = {
  template = "RaidFrameSettings_ColorModeTemplate",
  settings_text = L["name_color"],
  associated_modules = {
  },
  db_obj = addon.db.profile.fonts.name,
  color_modes = {
    {color_mode_options_health[1], 1},
    {color_mode_options_health[3], 3},
  },
}
data_provider:Insert(fonts_name_color)

local fonts_name_pos = {
  template = "RaidFrameSettings_AnchorTemplate",
  settings_text = L["name_pos"],
  db_obj = addon.db.profile.fonts.name,
  associated_modules = {
  },
}
data_provider:Insert(fonts_name_pos)

-- Category: Blizzard Settings - Raid Frames
local blizzard_raid_frames_title = {
  template = "RaidFrameSettings_HeaderTemplate",
  title = L["blizzard_settings_raid_frames"],
}
data_provider:Insert(blizzard_raid_frames_title)

local module_clean_borders = {
  template = "RaidFrameSettings_ToggleTemplate",
  settings_text = L["clean_borders"],
  db_obj = addon.db.profile.modules,
  db_key = "CleanHighlight",
  associated_modules = {
    "CleanHighlight",
  },
}
data_provider:Insert(module_clean_borders)

local blizzard_display_pets = {
  template = "RaidFrameSettings_ToggleTemplate",
  settings_text = L["display_pets"],
  db_obj = addon.db.profile.cvars,
  db_key = "raidOptionDisplayPets",
  associated_modules = {
  },
}
data_provider:Insert(blizzard_display_pets)

function private.GetDataProvider_GeneralOptions()
  return data_provider
end
