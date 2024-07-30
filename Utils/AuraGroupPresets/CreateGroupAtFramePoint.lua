--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local AuraGroupPresetUtil = addonTable.AuraGroupPresetUtil
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function AuraGroupPresetUtil:CreateTopLeft(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_top_left"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "TOPLEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "TOPLEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_horizontal = "RIGHT"
end

function AuraGroupPresetUtil:CreateTop(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_top"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "TOP"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "TOP"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].num_indicators_per_row = 1
  addon.db.profile.AuraGroups.aura_groups[grp_name].num_indicators_per_column = 2
end

function AuraGroupPresetUtil:CreateTopRight(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_top_right"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "TOPRIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "TOPRIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = -2
end

function AuraGroupPresetUtil:CreateLeft(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_left"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "LEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "LEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_horizontal = "RIGHT"
end

function AuraGroupPresetUtil:CreateCenter(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_center"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "CENTER"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "CENTER"
end

function AuraGroupPresetUtil:CreateRight(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_right"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "RIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "RIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = -2
end

function AuraGroupPresetUtil:CreateBottomLeft(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_bottom_left"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "BOTTOMLEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "BOTTOMLEFT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_vertical = "UP"
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_horizontal = "RIGHT"
end

function AuraGroupPresetUtil:CreateBottom(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_bottom"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "BOTTOM"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "BOTTOM"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = 0
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_vertical = "UP"
  addon.db.profile.AuraGroups.aura_groups[grp_name].num_indicators_per_row = 1
  addon.db.profile.AuraGroups.aura_groups[grp_name].num_indicators_per_column = 2
end

function AuraGroupPresetUtil:CreateBottomRight(name)
  local grp_name = self:CreateAuraGroup(name .. " - " .. L["frame_point_bottom_right"])
  addon.db.profile.AuraGroups.aura_groups[grp_name].point = "BOTTOMRIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].relative_point = "BOTTOMRIGHT"
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_x = -2
  addon.db.profile.AuraGroups.aura_groups[grp_name].offset_y = 2
  addon.db.profile.AuraGroups.aura_groups[grp_name].direction_of_growth_vertical = "UP"
end
