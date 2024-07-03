local addonName, addonTable = ...
addonTable.addon = LibStub("AceAddon-3.0"):NewAddon("RaidFrameSettings", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0", "AceSerializer-3.0")
local addon = addonTable.addon
addon:SetDefaultModuleLibraries("AceEvent-3.0")
addon:SetDefaultModuleState(false)
local AC = LibStub("AceConfig-3.0")


function addon:OnInitialize()
  -- Create/Load the Data Base
  self:LoadDataBase()
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
  for _, module in self:IterateModules() do
    if self:IsModuleEnabled(module:GetName()) then
      module:Enable()
    end
  end
  self:CreateOrUpdateFrameEnv()
end

function addon:OnDisable()

end

function addon:SlashCommand()
  local options_frame = addon:GetOptionsFrame()
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
