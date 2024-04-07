local addonName, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Icon = nil
local IconObj = nil

local module = addon:NewModule("MinimapButton")

function module:OnEnable()
  if not addon.db.global.MinimapButton.enabled then
    return
  end
  if not Icon then
    Icon = LibStub("LibDBIcon-1.0")
  end
  if not IconObj then
    IconObj = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
      type = "launcher",
      label = addonName,
      icon = addonTable.texturePaths.PortraitIcon,
      OnClick = function(self, button)
        if button == "LeftButton" then
          addon:SlashCommand() 
        elseif button == "MiddleButton" then
          addon.db.global.MinimapButton.enabled = false
          addon:DisableModule("MinimapButton")
          addon:Print("If you want to show the minimap icon again, enable it in the \"Enabled Modules\" section of the addon.")
        end
      end,
      OnTooltipShow = function(tooltip)
        tooltip:AddLine(addonName)
        tooltip:AddLine(" ")
        tooltip:AddLine("Left click: Open settings.") 
        tooltip:AddLine("Middle click: Hide minmap icon.")
      end,
    })
    Icon:Register(addonName, IconObj, addon.db.global.MinimapButton)
  end
  Icon:Show(addonName)
end

function module:OnDisable()
  if Icon and IconObj then
    Icon:Hide(addonName)
  end
end
