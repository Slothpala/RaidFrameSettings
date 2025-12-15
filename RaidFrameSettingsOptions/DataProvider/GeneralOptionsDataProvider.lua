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
    {color_mode_options_health[5], 5},
  },
}
data_provider:Insert(colors_health_bar_fg)

local colors_health_bar_bg = {
  template = "RaidFrameSettings_ColorModeTemplate",
  associated_modules = {
    "HealthBarBackground_Color"
  },
  settings_text = L["health_bar_bg"],
  db_obj = addon.db.profile.health_bars.bg,
  color_modes = {
    {color_mode_options_health[1], 1},
    {color_mode_options_health[2], 2},
    {color_mode_options_health[3], 3},
    {color_mode_options_health[4], 4},
  },
}
data_provider:Insert(colors_health_bar_bg)

local colors_power_bar_fg = {
  template = "RaidFrameSettings_ColorModeTemplate",
  associated_modules = {
    "PowerBarForeground_Color",
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
    "PowerBarBackground_Color",
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

local border_color = {
  template = "RaidFrameSettings_SingleChoiceColorPicker",
  settings_text = L["border_color"],
  db_obj = addon.db.profile.module_data.UnitFrameBorder,
  db_key = "border_color",
  associated_modules = {
    "UnitFrameBorder",
  },
}
data_provider:Insert(border_color)

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
    "HealthBarBackground_Texture",
  },
}
data_provider:Insert(texture_health_bar_bg)

local texture_power_bar_fg = {
  template = "RaidFrameSettings_DropdownSelectionTemplate_Texture",
  settings_text = L["power_bar_fg"],
  db_obj = addon.db.profile.power_bars.fg,
  associated_modules = {
    "PowerBarForeground_Texture",
  },
}
data_provider:Insert(texture_power_bar_fg)

local texture_power_bar_bg = {
  template = "RaidFrameSettings_DropdownSelectionTemplate_Texture",
  settings_text = L["power_bar_bg"],
  db_obj = addon.db.profile.power_bars.bg,
  associated_modules = {
    "PowerBarBackground_Texture",
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
    "Font_Name",
  },
}
data_provider:Insert(fonts_name_font)

local fonts_name_color = {
  template = "RaidFrameSettings_ColorModeTemplate",
  settings_text = L["name_color"],
  associated_modules = {
    "Font_Name",
  },
  db_obj = addon.db.profile.fonts.name,
  color_modes = {
    {color_mode_options_health[1], 1},
    {color_mode_options_health[3], 3},
  },
}
data_provider:Insert(fonts_name_color)

local fonts_npc_color = {
  template = "RaidFrameSettings_SingleChoiceColorPicker",
  settings_text = L["npc_color"],
  db_obj = addon.db.profile.fonts.name,
  db_key = "npc_color",
  associated_modules = {
    "Font_Name",
  },
}
data_provider:Insert(fonts_npc_color)

local fonts_name_pos = {
  template = "RaidFrameSettings_AnchorTemplate",
  settings_text = L["name_pos"],
  db_obj = addon.db.profile.fonts.name,
  associated_modules = {
    "Font_Name",
  },
}
data_provider:Insert(fonts_name_pos)

local fonts_name_horizontal_justification = {
  template = "RaidFrameSettings_DropdownSelectionTemplate",
  settings_text = L["text_horizontal_justification"],
  db_obj = addon.db.profile.fonts.name,
  db_key = "horizontal_justification",
  associated_modules = {
    "Font_Name",
  },
  options = {
    {L["text_horizontal_justification_option_left"] , "LEFT"},
    {L["text_horizontal_justification_option_center"] , "CENTER"},
    {L["text_horizontal_justification_option_right"] , "RIGHT"},
  },
}
data_provider:Insert(fonts_name_horizontal_justification)

local fonts_name_max_length = {
  template = "RaidFrameSettings_SliderTemplate",
  settings_text = L["max_length"],
  db_obj = addon.db.profile.fonts.name,
  db_key = "max_length",
  associated_modules = {
    "Font_Name",
  },
  slider_options = {
    min_value = 0.5,
    max_value = 2,
    steps = 15,
    decimals = 1,
  },
}
data_provider:Insert(fonts_name_max_length)

--[[
-- Currently not needed as the font strings height is always the fonts height.
local fonts_name_vertical_justification = {
  template = "RaidFrameSettings_DropdownSelectionTemplate",
  settings_text = L["text_vertical_justification"],
  db_obj = addon.db.profile.fonts.name,
  db_key = "vertical_justification",
  associated_modules = {
    "Font_Name",
  },
  options = {
    {L["text_horizontal_justification_option_top"] , "TOP"},
    {L["text_horizontal_justification_option_middle"] , "MIDDLE"},
    {L["text_horizontal_justification_option_bottom"] , "BOTTOM"},
  },
}
data_provider:Insert(fonts_name_vertical_justification)
]]

-- Category: Blizzard Settings - Raid Frames
local blizzard_raid_frames_title = {
  template = "RaidFrameSettings_HeaderTemplate",
  title = L["blizzard_settings_raid_frames"],
}
data_provider:Insert(blizzard_raid_frames_title)

local module_clean_borders = {
  template = "RaidFrameSettings_ToggleTemplate",
  settings_text = L["clean_borders"],
  db_obj = addon.db.profile.module_status,
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
    "CVar_raidOptionDisplayPets"
  },
}
data_provider:Insert(blizzard_display_pets)

local raid_frame_display_power_bars = {
  template = "RaidFrameSettings_ToggleTemplate",
  settings_text = L["display_power_bars"],
  db_obj = addon.db.profile.cvars,
  db_key = "raidFramesDisplayPowerBars",
  associated_modules = {
    "CVar_raidFramesDisplayPowerBars"
  },
}
data_provider:Insert(raid_frame_display_power_bars)

local raid_frame_display_power_bars_healer_only = {
  template = "RaidFrameSettings_ToggleTemplate",
  settings_text = L["display_power_bars_healer_only"],
  db_obj = addon.db.profile.cvars,
  db_key = "raidFramesDisplayOnlyHealerPowerBars",
  associated_modules = {
    "CVar_raidFramesDisplayOnlyHealerPowerBars"
  },
}
data_provider:Insert(raid_frame_display_power_bars_healer_only)

function private.GetDataProvider_GeneralOptions()
  return data_provider
end
