local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local ACD = LibStub("AceConfigDialog-3.0")

local update_aura_groups = function()
  -- defined below options
end

local menu_band = {
  order = 1,
  name = L["aura_groups_menu_band_name"],
  type = "group",
  inline = true,
  args = {
    create_aura_group = {
      order = 1,
      name = L["create_aura_group_name"],
      desc = L["create_aura_group_desc"] .. " " .. L["edit_grp_btn_name"],
      type = "input",
      set = function(_, name)
        local new_name = name
        local i = 1
        while( new_name == addon.db.profile.AuraGroups.aura_groups[new_name].name ) do
          i = i + 1
          new_name = name .. " (" .. tostring(i) .. ")"
        end
        addon.db.profile.AuraGroups.aura_groups[new_name] = {
          name = new_name,
          point = "CENTER",
          relative_point = "CENTER",
          offset_x = 0,
          offset_y = 0,
          -- Num indicators row*column
          num_indicators_per_row = 3,
          num_indicators_per_column = 1,
          -- Orientation
          direction_of_growth_vertical = "DOWN",
          vertical_padding = 1,
          direction_of_growth_horizontal = "LEFT",
          horizontal_padding = 1,
          -- Indicator size
          indicator_width = 24,
          indicator_height = 24,
          -- Indicator border
          indicator_border_thickness = 1,
          indicator_border_color = {0.5, 0.5, 0.5, 1},
          -- Cooldown
          show_swipe = false,
          -- swipe_color = {1, 1, 1, 1}, --@TODO: find out why Cooldown:SetSwipeColor(colorR, colorG, colorB [, a]) just ignores the color setting.
          reverse_swipe = false,
          show_edge = false,
          -- Tooltip
          show_tooltip = false,
          auras = {}
        }
        update_aura_groups()
        addon:ReloadModule("AuraGroups")
      end
    },
  },
}

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  childGroups = "tree",
  args = {},
}

update_aura_groups = function()
  options.args = {
    menu_band = menu_band
  }
  local i = 2
  for group_name, group_tbl in next, addon.db.profile.AuraGroups.aura_groups do
    options.args[group_name] = {
      order = i,
      name = group_name,
      type = "group",
      inline = true,
      args = {
        edit_grp_btn = {
          order = 1,
          name = L["edit_grp_btn_name"],
          desc = L["edit_grp_btn_desc"],
          type = "execute",
          func = function()
            local pop_up_frame = addon:GetPopUpFrame()
            pop_up_frame.title:SetText("\124cFF7DF9FF" .. L["edit_grp_title"] .. " " ..  group_name .. "\124r")
            pop_up_frame:Show()
            addon:SetEditAuraGroupOptions(group_name)
            ACD:Open("RaidFrameSettings_Edit_Aura_Group_Options_PopUp", pop_up_frame.container)
          end,
          width = 0.5,
        },
        remove_group_btn = {
          order = 5,
          name = L["remove_button_name"],
          type = "execute",
          confirm = true,
          func = function()
            addon.db.profile.AuraGroups.aura_groups[group_name] = nil
            update_aura_groups()
            addon:ReloadModule("AuraGroups")
          end,
          width = 0.5,
        },
        --[[
        -- add later when more options are added to the menu band.
        new_line_1 = {
          order = 20,
          name = "",
          type = "description",
        },
        ]]
      },
    }
    i = i + 1
    local k = 20
    for spell_id, _ in next, addon.db.profile.AuraGroups.aura_groups[group_name].auras do
      -- Gather spell infos
      local string_id = tostring(spell_id)
      local is_valid_id = #string_id <= 10
      local spell_obj = is_valid_id and Spell:CreateFromSpellID(spell_id) or nil
      options.args[group_name].args[string_id] = {
        name = "",
        image = spell_obj and spell_obj:GetSpellTexture() or "Interface\\ICONS\\INV_Misc_QuestionMark.blp",
        imageWidth = 22,
        imageHeight = 22,
        imageCoords = {0.1,0.9,0.1,0.9},
        type = "description",
        width = 0.15,
      }
      k = k + 1
    end

  end
end

function addon:GetAuraGroupOptions()
  update_aura_groups()
  return options
end
