--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon
addonTable.colors = {}

------------------------
--- Condition Colors ---
------------------------

addonTable.colors.unit_dead_color = {[1] = 1, [2] = 0, [3] = 0}
addonTable.colors.unit_offline_color = {[1] = 0.5, [2] = 0.5, [3] = 0.5}

--------------------
--- Class Colors ---
--------------------

function addon:CreateOrUpdateClassColors()
  local dbObj = CopyTable(self.db.profile.AddOnColors.class_colors)
  addonTable.colors.class_colors = {}
  for class, color_info in next, dbObj do
    addonTable.colors.class_colors[class] = {
      min_color = CreateColor(unpack(color_info.min_color)),
      max_color = CreateColor(unpack(color_info.max_color)),
      normal_color = color_info.normal_color,
    }
  end
end

--------------------
--- Power Colors ---
--------------------

function addon:CreateOrUpdatePowerColors()
  local dbObj = CopyTable(self.db.profile.AddOnColors.power_colors)
  addonTable.colors.power_colors = {}
  for power, color_info in next, dbObj do
    addonTable.colors.power_colors[power] = {
      min_color = CreateColor(unpack(color_info.min_color)),
      max_color = CreateColor(unpack(color_info.max_color)),
      normal_color = color_info.normal_color,
    }
  end
end

--------------------------
--- Dispel Type Colors ---
--------------------------

function addon:CreateOrUpdateDispelTypeColors()
  local dbObj = CopyTable(self.db.profile.AddOnColors.dispel_type_colors)
  addonTable.colors.dispel_type_colors = {}
  for dispel_type, color_info in next, dbObj do
    addonTable.colors.dispel_type_colors[dispel_type] = {
      min_color = CreateColor(unpack(color_info.min_color)),
      max_color = CreateColor(unpack(color_info.max_color)),
      normal_color = color_info.normal_color,
    }
  end
end
