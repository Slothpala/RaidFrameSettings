local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local icon = nil
local icon_obj = nil

local module = addon:NewModule("MiniMapButton")

function module:OnEnable()
  if not icon then
    icon = LibStub("LibDBIcon-1.0")
  end
  if not icon_obj then
    icon_obj = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
      type = "launcher",
      label = addonName,
      icon = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Icon_Circle.tga",
      OnClick = function(_, button)
        if button == "LeftButton" then
          addon:SlashCommand()
        elseif button == "RightButton" then
          if InCombatLockdown() then
            addon:Print(L["mini_map_in_combat_warning"])
          else
            addon:ReloadConfig()
          end
        end
      end,
      OnTooltipShow = function(tooltip)
        tooltip:AddLine(addonName)
        tooltip:AddLine("\n")
        tooltip:AddLine(L["mini_map_tooltip_left_button_text"])
        tooltip:AddLine(L["mini_map_tooltip_right_button_text"])
      end,
    })
    icon:Register(addonName, icon_obj, addon.db.profile.MiniMapButton)
  end
  icon:Show(addonName)
end

function module:OnDisable()
  if icon and icon_obj then
    icon:Hide(addonName)
  end
end
