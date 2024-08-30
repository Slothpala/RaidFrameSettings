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
local statusbars =  LibStub("LibSharedMedia-3.0"):List("statusbar")

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  inline = true,
  args = {
    RaidFrameColor = {
      order = 1,
      name = L["module_raid_frame_color_name"],
      desc = L["module_raid_frame_color_desc"],
      type = "group",
      inline = true,
      args = {
        -- Healthbar Foreground
        header_1 = {
          order = 0,
          name = L["raid_frame_health_bar_color_foreground"],
          type = "header",
          dialogControl = "SFX-Header",
        },
        health_bar_foreground_color_mode = {
          order = 1,
          name = L["operation_mode"],
          desc = L["raid_frame_color_health_operation_mode_desc"],
          type = "select",
          values = {L["raid_frame_color_operation_mode_class"], L["raid_frame_color_operation_mode_static"]},
          get = "GetStatus",
          set = "SetStatus",
        },
        health_bar_foreground_use_gradient_colors = {
          order = 2,
          name = L["raid_frame_color_foreground_use_gradient_name"],
          desc = L["raid_frame_color_foreground_use_gradient_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        health_bar_foreground_static_normal_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.health_bar_foreground_color_mode == 1 or addon.db.profile.RaidFrameColor.health_bar_foreground_use_gradient_colors
          end,
          order = 3,
          name = L["raid_frame_color_static_normal_color_name"],
          desc = L["raid_frame_color_static_normal_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        health_bar_foreground_static_min_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.health_bar_foreground_color_mode == 1 or not addon.db.profile.RaidFrameColor.health_bar_foreground_use_gradient_colors
          end,
          order = 3,
          name = L["raid_frame_color_static_min_color_name"],
          desc = L["raid_frame_color_static_min_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
          width = 1.2,
        },
        health_bar_foreground_static_max_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.health_bar_foreground_color_mode == 1 or not addon.db.profile.RaidFrameColor.health_bar_foreground_use_gradient_colors
          end,
          order = 4,
          name = L["raid_frame_color_static_max_color_name"],
          desc = L["raid_frame_color_static_max_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        -- Healthbar Background
        header_2 = {
          order = 20,
          name = L["raid_frame_health_bar_color_background"],
          type = "header",
          dialogControl = "SFX-Header",
        },
        health_bar_background_use_gradient_colors = {
          order = 20.1,
          name = L["raid_frame_color_background_use_gradient_name"],
          desc = L["raid_frame_color_background_use_gradient_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        health_bar_background_static_normal_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.health_bar_background_use_gradient_colors
          end,
          order = 20.2,
          name = L["raid_frame_color_static_normal_color_name"],
          desc = L["raid_frame_color_static_normal_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        health_bar_background_static_min_color = {
          hidden = function()
            return not addon.db.profile.RaidFrameColor.health_bar_background_use_gradient_colors
          end,
          order = 20.2,
          name = L["raid_frame_color_static_min_color_name"],
          desc = L["raid_frame_color_static_min_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
          width = 1.2,
        },
        health_bar_background_static_max_color = {
          hidden = function()
            return not addon.db.profile.RaidFrameColor.health_bar_background_use_gradient_colors
          end,
          order = 20.3,
          name = L["raid_frame_color_static_max_color_name"],
          desc = L["raid_frame_color_static_max_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        -- Powerbar Foreground
        header_3 = {
          order = 30,
          name = L["raid_frame_power_bar_color_foreground"],
          type = "header",
          dialogControl = "SFX-Header",
        },
        power_bar_foreground_color_mode = {
          order = 30.1,
          name = L["operation_mode"],
          desc = L["raid_frame_color_power_operation_mode_desc"],
          type = "select",
          values = {L["raid_frame_color_operation_mode_power"], L["raid_frame_color_operation_mode_static"]},
          get = "GetStatus",
          set = "SetStatus",
        },
        power_bar_foreground_use_gradient_colors = {
          order = 30.3,
          name = L["raid_frame_color_foreground_use_gradient_name"],
          desc = L["raid_frame_color_foreground_use_gradient_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        power_bar_foreground_static_normal_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.power_bar_foreground_color_mode == 1 or addon.db.profile.RaidFrameColor.power_bar_foreground_use_gradient_colors
          end,
          order = 30.4,
          name = L["raid_frame_color_static_normal_color_name"],
          desc = L["raid_frame_color_static_normal_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        power_bar_foreground_static_min_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.power_bar_foreground_color_mode == 1 or not addon.db.profile.RaidFrameColor.power_bar_foreground_use_gradient_colors
          end,
          order = 30.5,
          name = L["raid_frame_color_static_min_color_name"],
          desc = L["raid_frame_color_static_min_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
          width = 1.2,
        },
        power_bar_foreground_static_max_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.power_bar_foreground_color_mode == 1 or not addon.db.profile.RaidFrameColor.power_bar_foreground_use_gradient_colors
          end,
          order = 30.6,
          name = L["raid_frame_color_static_max_color_name"],
          desc = L["raid_frame_color_static_max_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        -- Powerbar Background
        header_5 = {
          order = 40,
          name = L["raid_frame_power_bar_color_background"],
          type = "header",
          dialogControl = "SFX-Header",
        },
        power_bar_background_use_gradient_colors = {
          order = 40.1,
          name = L["raid_frame_color_background_use_gradient_name"],
          desc = L["raid_frame_color_background_use_gradient_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        power_bar_background_static_normal_color = {
          hidden = function()
            return addon.db.profile.RaidFrameColor.power_bar_background_use_gradient_colors
          end,
          order = 40.2,
          name = L["raid_frame_color_static_normal_color_name"],
          desc = L["raid_frame_color_static_normal_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
        power_bar_background_static_min_color = {
          hidden = function()
            return not addon.db.profile.RaidFrameColor.power_bar_background_use_gradient_colors
          end,
          order = 40.2,
          name = L["raid_frame_color_static_min_color_name"],
          desc = L["raid_frame_color_static_min_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
          width = 1.2,
        },
        power_bar_background_static_max_color = {
          hidden = function()
            return not addon.db.profile.RaidFrameColor.power_bar_background_use_gradient_colors
          end,
          order = 40.3,
          name = L["raid_frame_color_static_max_color_name"],
          desc = L["raid_frame_color_static_max_color_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
      },
    },
    Texture = {
      hidden = function()
        return not addon:IsModuleEnabled("Texture")
      end,
      order = 2,
      name = L["module_texture_header_name"],
      desc = L["module_texture_header_desc"],
      type = "group",
      inline = true,
      args = {
        health_bar_foreground_texture = {
          order = 1,
          type = "select",
          name = L["texture_health_bar_foreground_name"],
          values = statusbars,
          get = function()
            for i, v in next, statusbars do
              if v == addon.db.profile.Texture.health_bar_foreground_texture then
                return i
              end
            end
          end,
          set = function(_, value)
            addon.db.profile.Texture.health_bar_foreground_texture = statusbars[value]
            addon:ReloadModule("Texture")
            if addon:IsModuleEnabled("DebuffHighlight") then
              addon:ReloadModule("DebuffHighlight")
            end
          end,
          itemControl = "DDI-Statusbar",
          width = 1,
        },
        health_bar_background_texture = {
          order = 2,
          type = "select",
          name = L["texture_health_bar_background_name"],
          values = statusbars,
          get = function()
            for i, v in next, statusbars do
              if v == addon.db.profile.Texture.health_bar_background_texture then
                return i
              end
            end
          end,
          set = function(_, value)
            addon.db.profile.Texture.health_bar_background_texture = statusbars[value]
            addon:ReloadModule("Texture")
          end,
          itemControl = "DDI-Statusbar",
          width = 1,
        },
        new_line_1 = {
          order = 20,
          name = "",
          type = "description",
        },
        power_bar_foreground_texture = {
          order = 20.1,
          type = "select",
          name = L["texture_power_bar_foreground_name"],
          values = statusbars,
          get = function()
            for i, v in next, statusbars do
              if v == addon.db.profile.Texture.power_bar_foreground_texture then
                return i
              end
            end
          end,
          set = function(_, value)
            addon.db.profile.Texture.power_bar_foreground_texture = statusbars[value]
            addon:ReloadModule("Texture")
          end,
          itemControl = "DDI-Statusbar",
          width = 1,
        },
        power_bar_background_texture = {
          order = 20.2,
          type = "select",
          name = L["texture_power_bar_background_name"],
          values = statusbars,
          get = function()
            for i, v in next, statusbars do
              if v == addon.db.profile.Texture.power_bar_background_texture then
                return i
              end
            end
          end,
          set = function(_, value)
            addon.db.profile.Texture.power_bar_background_texture = statusbars[value]
            addon:ReloadModule("Texture")
          end,
          itemControl = "DDI-Statusbar",
          width = 1,
        },
        detach_power_bar = {
          order = 20.3,
          name = L["texture_detach_power_bar_name"],
          desc = L["texture_detach_power_bar_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
          width = 0.5,
        },
        power_bar_width = {
          hidden = function ()
            return not addon.db.profile.Texture.detach_power_bar
          end,
          order = 20.4,
          name = L["texture_power_bar_width_name"],
          desc = L["texture_power_bar_width_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0.01,
          max = 1.3,
          step = 0.01,
          isPercent = true,
          width = 1,
        },
        power_bar_height = {
          hidden = function ()
            return not addon.db.profile.Texture.detach_power_bar
          end,
          order = 20.5,
          name = L["texture_power_bar_height_name"],
          desc = L["texture_power_bar_height_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0.01,
          max = 1.3,
          step = 0.01,
          isPercent = true,
          width = 1,
        },
        new_line_2 = {
          order = 30,
          name = "",
          type = "description",
        },
        point = {
          hidden = function ()
            return not addon.db.profile.Texture.detach_power_bar
          end,
          order = 30.1,
          name = L["point_name"],
          desc = L["point_desc"],
          type = "select",
          values = locale_frame_points,
          get = "GetFramePoint",
          set = "SetFramePoint",
          width = 0.8,
        },
        relative_point = {
          hidden = function ()
            return not addon.db.profile.Texture.detach_power_bar
          end,
          order = 30.2,
          name = L["relative_point_name"],
          desc = L["relative_point_desc"],
          type = "select",
          values = locale_frame_points,
          get = "GetFramePoint",
          set = "SetFramePoint",
          width = 0.8,
        },
        offset_x = {
          hidden = function ()
            return not addon.db.profile.Texture.detach_power_bar
          end,
          order = 30.3,
          name = L["offset_x_name"],
          desc = L["offset_x_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = -10,
          max = 10,
          step = 1,
          width = 0.8,
        },
        offset_y = {
          hidden = function ()
            return not addon.db.profile.Texture.detach_power_bar
          end,
          order = 30.4,
          name = L["offset_y_name"],
          desc = L["offset_y_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = -10,
          max = 10,
          step = 1,
          width = 0.8,
        },
      },
    },
  },
}

function addon:GetGeneralOptions()
  return options
end
