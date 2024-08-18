--[[Created by Slothpala]]--
--[[
  This is used when i have to make db changes and is alway loaded right after LoadDataBase.
]]
local _, addonTable = ...
local addon = addonTable.addon

-- @TODO: Remove after a few updates.
local function convert_buff_highlight_auras()
  for spell_id, value in next, addon.db.profile.BuffHighlight.auras do
    if type(value) ~= "table" then
      addon.db.profile.BuffHighlight.auras[spell_id] = {
        own_only = true
      }
    end
  end
end

local function overwrite_detach_power_bar_setting()
  addon.db.profile.Texture.detach_power_bar = false
end

function addon:CheckDatabase()
  convert_buff_highlight_auras()
  overwrite_detach_power_bar_setting()
end
