--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon
addonTable.AuraGroupPresetUtil = {}
local AuraGroupPresetUtil = addonTable.AuraGroupPresetUtil

function AuraGroupPresetUtil:CreateAuraGroup(name, overwrite_existing)
  local new_name = name
  if not overwrite_existing then
    local i = 1
    while( new_name == addon.db.profile.AuraGroups.aura_groups[new_name].name ) do
      i = i + 1
      new_name = name .. " (" .. tostring(i) .. ")"
    end
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
    indicator_width = 22,
    indicator_height = 22,
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
  return new_name
end
