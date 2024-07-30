--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local ACD = LibStub("AceConfigDialog-3.0")
local AuraGroupPresetUtil = addonTable.AuraGroupPresetUtil

local new_grp_name = UnitClass("player")

local create_grp_btn_image_width, create_grp_btn_image_height = 44, 22
local create_grp_btn_coords = {0,1,0,1}
local create_grp_btn_width = 0.48

local update_aura_groups = function()
  -- defined below options
end

local menu_band = {
  order = 1,
  name = L["aura_groups_menu_band_name"],
  type = "group",
  inline = true,
  args = {
    create_grp_header = {
      order = 0,
      name = L["create_grp_header_name"],
      type = "header",
      dialogControl = "SFX-Header",
    },
    enter_name_field = {
      order = 1,
      name = L["create_aura_group_name"],
      desc = L["create_aura_group_desc"] .. " " .. L["edit_grp_btn_name"],
      type = "input",
      set = function(_, name)
        new_grp_name = name
        update_aura_groups()
      end,
      get = function ()
        return new_grp_name
      end,
      width = 0.6,
    },
    create_aura_group_top_left_btn = {
      order = 2,
      name = L["frame_point_top_left"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightTopLeft.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateTopLeft(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_top_btn = {
      order = 3,
      name = L["frame_point_top"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightTop.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateTop(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_top_right_btn = {
      order = 4,
      name = L["frame_point_top_right"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightTopRight.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateTopRight(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_left_btn = {
      order = 5,
      name = L["frame_point_left"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightLeft.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateLeft(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_center_btn = {
      order = 6,
      name = L["frame_point_center"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightCenter.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateCenter(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_right_btn = {
      order = 7,
      name = L["frame_point_right"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightRight.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateRight(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_bottom_left_btn = {
      order = 8,
      name = L["frame_point_bottom_left"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightBottomLeft.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateBottomLeft(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_bottom_btn = {
      order = 9,
      name = L["frame_point_bottom"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightBottom.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateBottom(new_grp_name)
        update_aura_groups()
      end,
      width = create_grp_btn_width,
    },
    create_aura_group_bottom_right_btn = {
      order = 10,
      name = L["frame_point_bottom_right"],
      image = "Interface\\AddOns\\RaidFrameSettings\\Textures\\AuraGroupIcons\\HighlightBottomRight.png",
      imageWidth = create_grp_btn_image_width,
      imageHeight = create_grp_btn_image_height,
      imageCoords = create_grp_btn_coords,
      type = "execute",
      confirm = true,
      func = function()
        AuraGroupPresetUtil:CreateBottomRight(new_grp_name)
        update_aura_groups()
      end,
      width = 0.6,
    },
    import_spec_preset_header = {
      order = 20,
      name = L["import_spec_preset_header_name"],
      type = "header",
      dialogControl = "SFX-Header",
    },
    import_resto_druid_btn = {
      order = 20.1,
      name = L["import_resto_druid_btn_name"],
      image = "136041", -- Restro Spec Icon
      imageWidth = 26,
      imageHeight = 26,
      imageCoords = {0.1,0.9,0.1,0.9},
      type = "execute",
      confirm = true,
      confirmText = L["import_preset_confirm_msg"],
      func = function()
        AuraGroupPresetUtil:ImportRestorationDruid()
        update_aura_groups()
        addon:ReloadModule("AuraGroups")
      end,
      width = 0.5,
    },
    import_disci_priest_btn = {
      order = 20.2,
      name = L["import_disci_priest_btn_name"],
      image = "135940", -- Disci Spec Icon
      imageWidth = 26,
      imageHeight = 26,
      imageCoords = {0.1,0.9,0.1,0.9},
      type = "execute",
      confirm = true,
      confirmText = L["import_preset_confirm_msg"],
      func = function()
        AuraGroupPresetUtil:ImportDisciplinePriest()
        update_aura_groups()
        addon:ReloadModule("AuraGroups")
      end,
      width = 0.5,
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
