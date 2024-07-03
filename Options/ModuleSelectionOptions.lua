local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local ACD = LibStub("AceConfigDialog-3.0")

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

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  inline = true,
  args = {
    modules = {
      order = 0,
      name = L["module_selection_header_name"],
      desc = L["module_selection_header_desc"],
      type = "group",
      inline = true,
      -- Module Toggles:
      args = {
        Texture = {
          order = 1,
          name = L["module_texture_name"],
          desc = L["module_texture_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        Font = {
          order = 2,
          name = L["module_font_name"],
          desc = L["module_font_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        RoleIcon = {
          order = 3,
          name = L["module_role_icon_name"],
          desc = L["module_role_icon_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        Range = {
          order = 4,
          name = L["module_range_name"],
          desc = L["module_range_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        Overabsorb = {
          order = 5,
          name = L["module_overabsorb_name"],
          desc = L["module_overabsorb_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        BuffFrame = {
          order = 6,
          name = L["module_buff_frame_name"],
          desc = L["module_buff_frame_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        DebuffFrame = {
          order = 7,
          name = L["module_debuff_frame_name"],
          desc = L["module_debuff_frame_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        DefensiveOverlay = {
          order = 8,
          name = L["module_defensive_overlay_name"],
          desc = L["module_defensive_overlay_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        AuraGroups = {
          order = 9,
          name = L["module_aura_groups_name"],
          desc = L["module_aura_groups_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        DebuffHighlight = {
          order = 10,
          name = L["module_debuff_highlight_name"],
          desc = L["module_debuff_highlight_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        BuffHighlight = {
          order = 11,
          name = L["module_buff_highlight_name"],
          desc = L["module_buff_highlight_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        Resizer = {
          order = 12,
          name = L["module_resizer_name"],
          desc = L["module_resizer_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        SoloFrame = {
          order = 13,
          name = L["module_solo_frame_name"],
          desc = L["module_solo_frame_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
        MiniMapButton = {
          order = 14,
          name = L["module_mini_map_button_name"],
          desc = L["module_mini_map_button_desc"],
          type = "toggle",
          get = "GetModuleStatus",
          set = "SetModuleStatus",
        },
      },
    },
    -- Minor Module Settings
    RoleIcon = {
      order = 3,
      hidden = function()
        return not addon:IsModuleEnabled("RoleIcon")
      end,
      name = L["module_role_icon_name"],
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
        },
        relative_point = {
          order = 2,
          name = L["relative_point_name"],
          desc = L["relative_point_desc"],
          type = "select",
          values = locale_frame_points,
          get = "GetFramePoint",
          set = "SetFramePoint",
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
          width = 1,
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
          width = 1,
        },
        scale_factor = {
          order = 5,
          name = L["scale_factor_name"],
          desc = L["scale_factor_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0.3,
          max = 3,
          step = 0.01,
          isPercent = true,
          width = 1,
        },
        new_line = {
          order = 20,
          type = "description",
          name = "",
        },
        show_for_dps = {
          image = function()
            local atla_info = C_Texture.GetAtlasInfo("UI-LFG-RoleIcon-DPS-Micro")
            return atla_info.file
          end,
          imageCoords = function()
            local atla_info = C_Texture.GetAtlasInfo("UI-LFG-RoleIcon-DPS-Micro")
            return {atla_info.leftTexCoord, atla_info.rightTexCoord, atla_info.topTexCoord, atla_info.bottomTexCoord}
          end,
          order = 20.1,
          name = L["role_icon_show_for_dps_name"],
          desc = L["role_icon_show_for_dps_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        show_for_heal = {
          image = function()
            local atla_info = C_Texture.GetAtlasInfo("UI-LFG-RoleIcon-Healer-Micro")
            return atla_info.file
          end,
          imageCoords = function()
            local atla_info = C_Texture.GetAtlasInfo("UI-LFG-RoleIcon-Healer-Micro")
            return {atla_info.leftTexCoord, atla_info.rightTexCoord, atla_info.topTexCoord, atla_info.bottomTexCoord}
          end,
          order = 20.2,
          name = L["role_icon_show_for_heal_name"],
          desc = L["role_icon_show_for_heal_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
        show_for_tank = {
          image = function()
            local atla_info = C_Texture.GetAtlasInfo("UI-LFG-RoleIcon-Tank-Micro")
            return atla_info.file
          end,
          imageCoords = function()
            local atla_info = C_Texture.GetAtlasInfo("UI-LFG-RoleIcon-Tank-Micro")
            return {atla_info.leftTexCoord, atla_info.rightTexCoord, atla_info.topTexCoord, atla_info.bottomTexCoord}
          end,
          order = 20.3,
          name = L["role_icon_show_for_tank_name"],
          desc = L["role_icon_show_for_tank_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
        },
      },
    },
    Range = {
      order = 4,
      hidden = function()
        return not addon:IsModuleEnabled("Range")
      end,
      name = L["module_range_name"],
      type = "group",
      inline = true,
      args = {
        out_of_range_foregorund_alpha = {
          order = 1,
          name = L["range_out_of_range_foregorund_alpha_name"],
          desc = L["range_out_of_range_foregorund_alpha_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0,
          max = 1,
          step = 0.01,
          isPercent = true,
          width = 1.3,
        },
        out_of_range_background_alpha = {
          order = 2,
          name = L["range_out_of_range_background_alpha_name"],
          desc = L["range_out_of_range_background_alpha_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0,
          max = 1,
          step = 0.01,
          isPercent = true,
          width = 1.3,
        },
        use_out_of_range_background_color = {
          order = 3,
          name = L["range_use_out_of_range_background_color_name"],
          desc = L["range_use_out_of_range_background_color_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
          width = 1,
        },
        out_of_range_background_color = {
          disabled = function()
            return not addon.db.profile.Range.use_out_of_range_background_color
          end,
          order = 4,
          name = L["color_picker_name"],
          desc = L["color_picker_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
        },
      },
    },
    Overabsorb = {
      order = 5,
      hidden = function()
        return not addon:IsModuleEnabled("Overabsorb")
      end,
      name = L["module_overabsorb_name"],
      type = "group",
      inline = true,
      args = {
        glow_alpha = {
          order = 1,
          name = L["overabsorb_glow_alpha_name"],
          desc = L["overabsorb_glow_alpha_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0,
          max = 1,
          step = 0.01,
          isPercent = true,
          width = 1.3,
        },
      },
    },
    DebuffHighlight = {
      order = 10,
      hidden = function()
        return not addon:IsModuleEnabled("DebuffHighlight")
      end,
      name = L["module_debuff_highlight_name"],
      type = "group",
      inline = true,
      args = {
        operation_mode = {
          order = 1,
          name = L["operation_mode"],
          desc = L["module_debuff_highlight_operation_mode_desc"],
          type = "select",
          values = {L["operation_mode_option_smart"], L["operation_mode_option_manual"]},
          get = "GetStatus",
          set = "SetStatus",
        },
        spece = {
          order = 2,
          name = "",
          type = "description",
          width = 0.05,
        },
        Curse = {
          hidden = function()
            return addon.db.profile.DebuffHighlight.operation_mode == 1
          end,
          order = 3,
          image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Upscaled-Raid-Icon-DebuffCurse",
          name = L["debuff_highlight_show_curses_name"],
          desc = L["debuff_highlight_show_curses_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
          width = 0.9,
        },
        Disease = {
          hidden = function()
            return addon.db.profile.DebuffHighlight.operation_mode == 1
          end,
          order = 4,
          image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Upscaled-Raid-Icon-DebuffDisease",
          name = L["debuff_highlight_show_diseases_name"],
          desc = L["debuff_highlight_show_diseases_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
          width = 0.9,
        },
        Magic = {
          hidden = function()
            return addon.db.profile.DebuffHighlight.operation_mode == 1
          end,
          order = 5,
          image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Upscaled-Raid-Icon-DebuffMagic",
          name = L["debuff_highlight_show_magic_name"],
          desc = L["debuff_highlight_show_magic_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
          width = 0.9,
        },
        Poison = {
          hidden = function()
            return addon.db.profile.DebuffHighlight.operation_mode == 1
          end,
          order = 6,
          image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Upscaled-Raid-Icon-DebuffPoison",
          name = L["debuff_highlight_show_poisons_name"],
          desc = L["debuff_highlight_show_poisons_desc"],
          type = "toggle",
          get = "GetStatus",
          set = "SetStatus",
          width = 0.9,
        },
      },
    },
    BuffHighlight = {
      order = 11,
      hidden = function()
        return not addon:IsModuleEnabled("BuffHighlight")
      end,
      name = L["module_buff_highlight_name"],
      type = "group",
      inline = true,
      args = {
        operation_mode = {
          order = 1,
          name = L["operation_mode"],
          desc = L["buff_highlight_operation_mode_desc"],
          type = "select",
          values = {L["buff_highlight_option_present"], L["buff_highlight_option_missing"]},
          get = "GetStatus",
          set = "SetStatus",
        },
        spece = {
          order = 2,
          name = "",
          type = "description",
          width = 0.05,
        },
        highlight_color = {
          order = 3,
          name = L["color_picker_name"],
          desc = L["color_picker_desc"],
          type = "color",
          get = "GetColor",
          set = "SetColor",
          width = 0.4
        },
        edit_auras = {
          order = 4,
          name = L["buff_highlight_edit_auras_name"],
          desc = L["buff_highlight_edit_auras_desc"],
          type = "execute",
          func = function()
            local pop_up_frame = addon:GetPopUpFrame()
            pop_up_frame.title:SetText(L["module_buff_highlight_name"])
            local color = addon.db.profile.BuffHighlight.highlight_color
            pop_up_frame.title:SetTextColor(color[1], color[2], color[3])
            ACD:Open("RaidFrameSettings_Buff_Highlight_Auras_Options_PopUp", pop_up_frame.container)
            pop_up_frame:Show()
          end,
          width = 0.8,
        },
      }
    },
    Resizer = {
      order = 12,
      hidden = function()
        return not addon:IsModuleEnabled("Resizer")
      end,
      name = L["module_resizer_name"],
      type = "group",
      inline = true,
      args = {
        party_frame_container_scale_factor = {
          order = 1,
          name = L["resizer_party_scale_factor_name"],
          desc = L["scale_factor_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0.3,
          max = 3,
          step = 0.01,
          isPercent = true,
          width = 1.3,
        },
        raid_frame_container_scale_factor = {
          order = 2,
          name = L["resizer_raid_scale_factor_name"],
          desc = L["scale_factor_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0.3,
          max = 3,
          step = 0.01,
          isPercent = true,
          width = 1.3,
        },
        arena_frame_container_scale_factor = {
          order = 3,
          name = L["resizer_arena_scale_factor_name"],
          desc = L["scale_factor_desc"],
          type = "range",
          get = "GetStatus",
          set = "SetStatus",
          min = 0.3,
          max = 3,
          step = 0.01,
          isPercent = true,
          width = 1.3,
        },
      },
    },
  },
}

function addon:GetModuleSelectionOptions()
  return options
end
