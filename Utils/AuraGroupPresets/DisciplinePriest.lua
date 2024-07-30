--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local AuraGroupPresetUtil = addonTable.AuraGroupPresetUtil
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function AuraGroupPresetUtil:ImportDisciplinePriest()
  local preset_name = "AddOn Preset: " .. L["import_disci_priest_btn_name"] .. " - "
  -- TOPLEFT
  local grp_name = self:CreateAuraGroup(preset_name .. L["frame_point_top_left"], true)
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "TOPLEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "TOPLEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_horizontal = "RIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].auras = {
    [194384] = { -- Atonement
      prio = 1,
      track_if_present = true,
      own_only = true,
      show_glow = false,
      track_if_missing = true,
    },
  }
  -- TOP
  grp_name = self:CreateAuraGroup(preset_name .. L["frame_point_top"], true)
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "TOP"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "TOP"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].auras = {
    [139] = { -- Renew
      prio = 1,
      track_if_present = true,
      own_only = true,
      show_glow = false,
      track_if_missing = false,
    }
  }
  -- TOPRIGHT
  grp_name = self:CreateAuraGroup(preset_name .. L["frame_point_top_right"], true)
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "TOPRIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "TOPRIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].auras = {
    [17] = { -- Power Word: Shield
      prio = 1,
      track_if_present = true,
      own_only = true,
      show_glow = false,
      track_if_missing = false,
    }
  }
end
