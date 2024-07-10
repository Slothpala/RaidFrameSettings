--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  childGroups = "tab",
  args = {
    class_colors = {
      order = 1,
      name = L["class_colors_tab_name"],
      type = "group",
      args = {

      },
    },
    power_colors = {
      name = L["power_colors_tab_name"],
      type = "group",
      args = {

      },
    },
    dispel_type_colors = {
      order = 3,
      name = L["dispel_type_colors_tab_name"],
      type = "group",
      args = {

      },
    },

  }
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

local function reload_class_color_related_modules()
  addon:CreateOrUpdateClassColors()
  addon:ReloadModule("RaidFrameColor")
  addon:ReloadModule("Font")
end

local function create_class_color_options()
  for class_file_name, _ in next, addon.db.profile.AddOnColors.class_colors do
    options.args.class_colors.args[class_file_name] = {
      name = LOCALIZED_CLASS_NAMES_MALE[class_file_name],
      type = "group",
      inline = true,
      args = {
        class_icon = {
          order = 1,
          name = "",
          image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\CharacterCreateIcons.BLP",
          imageCoords = class_icon_coords[class_file_name] or {0,1,0,1},
          imageWidth = 28,
          imageHeight = 28,
          type = "description",
          width = 0.3,
        },
        normal_color = {
          order = 1,
          name = L["normal_color_name"],
          desc = L["normal_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
        },
        min_color = {
          order = 2,
          name = L["min_color_name"],
          desc = L["min_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
        },
        max_color = {
          order = 3,
          name = L["max_color_name"],
          desc = L["max_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
          width = 2,
        },
        reset_class_color = {
          order = 4,
          type = "execute",
          name = L["reset_button"],
          desc = L["color_reset_button_desc"],
          func = function()
            local defaults = addon:GetDefaultDbValues()
            addon.db.profile.AddOnColors.class_colors[class_file_name] = CopyTable(defaults.profile.AddOnColors.class_colors[class_file_name])
            reload_class_color_related_modules()
          end,
          width = 0.5,
        },
      },
    }
  end
end

local function reload_power_color_related_modules()
  addon:CreateOrUpdatePowerColors()
  addon:ReloadModule("RaidFrameColor")
end

local function create_power_color_options()
  for power_type, _ in next, addon.db.profile.AddOnColors.power_colors do
    options.args.power_colors.args[power_type] = {
      name = _G[power_type],
      type = "group",
      inline = true,
      args = {
        normal_color = {
          order = 1,
          name = L["normal_color_name"],
          desc = L["normal_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
        },
        min_color = {
          order = 2,
          name = L["min_color_name"],
          desc = L["min_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
        },
        max_color = {
          order = 3,
          name = L["max_color_name"],
          desc = L["max_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
          width = 2,
        },
        reset_class_color = {
          order = 4,
          type = "execute",
          name = L["reset_button"],
          desc = L["color_reset_button_desc"],
          func = function()
            local defaults = addon:GetDefaultDbValues()
            addon.db.profile.AddOnColors.power_colors[power_type] = CopyTable(defaults.profile.AddOnColors.power_colors[power_type])
            reload_power_color_related_modules()
          end,
          width = 0.5,
        },
      },
    }
  end
end

local function reload_dispel_color_related_modules()
  addon:CreateOrUpdateDispelTypeColors()
  addon:ReloadModule("DebuffFrame")
  addon:ReloadModule("DebuffHighlight")
end

local function create_dispel_color_options()
  for dispel_type, _ in next, addon.db.profile.AddOnColors.dispel_type_colors do
    options.args.dispel_type_colors.args[dispel_type] = {
      name = L[dispel_type],
      type = "group",
      inline = true,
      args = {
        dispel_icon = {
          order = 0,
          name = "",
          image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Upscaled-Raid-Icon-Debuff" .. dispel_type,
          imageCoords = {0,1,0,1},
          imageWidth = 28,
          imageHeight = 28,
          type = "description",
          width = 0.3,
        },
        normal_color = {
          order = 1,
          name = L["normal_color_name"],
          desc = L["normal_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
        },
        min_color = {
          order = 2,
          name = L["min_color_name"],
          desc = L["min_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
        },
        max_color = {
          order = 3,
          name = L["max_color_name"],
          desc = L["max_color_desc"],
          type = "color",
          get = "GetAddOnColor",
          set = "SetAddOnColor",
          width = 2,
        },
        reset_class_color = {
          order = 4,
          type = "execute",
          name = L["reset_button"],
          desc = L["color_reset_button_desc"],
          func = function()
            local defaults = addon:GetDefaultDbValues()
            addon.db.profile.AddOnColors.dispel_type_colors[dispel_type] = CopyTable(defaults.profile.AddOnColors.dispel_type_colors[dispel_type])
            reload_dispel_color_related_modules()
          end,
          width = 0.5,
        },
      },
    }
  end
end


function addon:GetAddOnColor(info)
  local color = self.db.profile.AddOnColors[info[#info-2]][info[#info-1]][info[#info]]
  return color[1], color[2], color[3], color[4] or 1
end

function addon:SetAddOnColor(info, r, g, b, a)
  local color = {[1] = r, [2] = g, [3] = b, [4] = a}
  self.db.profile.AddOnColors[info[#info-2]][info[#info-1]][info[#info]] = color
  if info[#info-2] == "class_colors" then
    reload_class_color_related_modules()
  elseif info[#info-2] == "power_colors" then
    reload_power_color_related_modules()
  elseif info[#info-2] == "dispel_type_colors" then
    reload_dispel_color_related_modules()
  end

--  self:ReloadConfig()
end

function addon:GetAddOnColorOptions()
  create_class_color_options()
  create_power_color_options()
  create_dispel_color_options()
  return options
end
