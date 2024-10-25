--[[Created by Slothpala]]--
local addonName, addonTable = ...
addonTable.addon = LibStub("AceAddon-3.0"):NewAddon("RaidFrameSettings", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0", "AceSerializer-3.0")
local addon = addonTable.addon
addon:SetDefaultModuleLibraries("AceEvent-3.0")
addon:SetDefaultModuleState(false)
local AC = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

function addon:OnInitialize()
  Mixin(self, addonTable.HookRegistryMixin)
  -- Create/Load the Data Base
  self:LoadDataBase()
  self:CheckDatabase()
  --Slash command
  self:RegisterChatCommand(addonName, "SlashCommand")
  self:RegisterChatCommand("rfs", "SlashCommand")
end

function addon:OnEnable()
  -- Options
  -- Leave this in OnEnable to update the UI on profile change.
  AC:RegisterOptionsTable("RaidFrameSettings_Module_Selection_Tab", self:GetModuleSelectionOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_AddOn_Colors_Tab", self:GetAddOnColorOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_General_Options_Tab", self:GetGeneralOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Font_Options_Tab", self:GetFontOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Defensive_Overlay_Options_Tab", self:GetDefensiveOverlayOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Buff_Frame_Options_Tab", self:GetBuffFrameOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Debuff_Frame_Options_Tab", self:GetDebuffFrameOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Profiles_Options_Tab", self:GetProfileTabOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Aura_Group_Options_Tab", self:GetAuraGroupOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Edit_Aura_Group_Options_PopUp", self:GetEditAuraGroupOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Buff_Highlight_Auras_Options_PopUp", self:GetBuffHighlightAuraOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Export_Profile_Options_PopUp", self:GetExportProfileOptions())
  AC:RegisterOptionsTable("RaidFrameSettings_Import_Profile_Options_PopUp", self:GetImportProfileOptions())
  -- Set the addon colors
  self:CreateOrUpdateClassColors()
  self:CreateOrUpdatePowerColors()
  self:CreateOrUpdateDispelTypeColors()
  -- Create or update the frame env
  self:CreateOrUpdateFrameEnv()
  -- GROUP_ROSTER_UPDATE gets spammed in certain scenarios (large groups with many people joining or leaving). -- Also this event seems to be bugged, it fires at times without any actual changes.
  -- Buffering greatly reduces CPU usage spikes in these scenarios.
  self:RegisterBucketEvent("GROUP_ROSTER_UPDATE", 1, "CreateOrUpdateFrameEnv")
  for _, module in self:IterateModules() do
    if self:IsModuleEnabled(module:GetName()) then
      module:Enable()
    end
  end
  self:OptimizeUnitAuraEventRegistration()
end

function addon:OnDisable()
  self:DisableHooks()
end

function addon:OptimizeUnitAuraEventRegistration()
  -- If those 3 modules are enabled the aura processing of the default frame is no longer necessary.
  if self:IsModuleEnabled("BuffFrame") and self:IsModuleEnabled("DebuffFrame") and self:IsModuleEnabled("DebuffHighlight") then
    self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateUnitEvents", function(cuf_frame)
      cuf_frame:UnregisterEvent("UNIT_AURA")
    end)
    self:IterateRoster(function(cuf_frame)
      cuf_frame:UnregisterEvent("UNIT_AURA")
    end, true)
  else
    self:Unhook("CompactUnitFrame_UpdateUnitEvents")
    self:IterateRoster(function(cuf_frame)
      local unit = cuf_frame.unit
      local displayedUnit
      if ( unit ~= cuf_frame.displayedUnit ) then
        displayedUnit = cuf_frame.displayedUnit
      end
      cuf_frame:RegisterUnitEvent("UNIT_AURA", unit, displayedUnit)
    end, true)
  end
end

function addon:SlashCommand()
  local options_frame = addon:GetOptionsFrame()
  if InCombatLockdown() then
    self:Print(L["option_open_after_combat_msg"])
    options_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    return
  end
  if not options_frame:IsShown() then
    options_frame:Show()
  else
    options_frame:Hide()
  end
end

function addon:ReloadConfig()
  self:Disable()
  self:Enable()
  self:OptionsFrame_UpdateTabs()
end

-- To not have a to convoluted Set/Get section.
local module_assoiaton = {
  ["NameFont"] = "Font",
  ["StatusFont"] = "Font",
  ["DefensiveOverlayDurationFont"] = "DefensiveOverlay",
  ["DefensiveOverlayStackFont"] = "DefensiveOverlay",
  ["BuffFrameDurationFont"] = "BuffFrame",
  ["BuffFrameStackFont"] = "BuffFrame",
  ["DebuffFrameDurationFont"] = "DebuffFrame",
  ["DebuffFrameStackFont"] = "DebuffFrame",
  ["AuraGroupsDurationFont"] = "AuraGroups",
  ["AuraGroupsStackFont"] = "AuraGroups",
}

function addon:ReloadModule(name)
  local module_name = module_assoiaton[name] or name
  self:DisableModule(module_name)
  self:EnableModule(module_name)
end

function addon:IsModuleEnabled(name)
  return self.db.profile[name].enabled
end

function RaidFrameSettings_AddOnCompartmentEntry()
  addon:SlashCommand()
end
