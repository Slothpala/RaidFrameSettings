--[[
    Created by Slothpala 
    Setup the AddOn. I.e load the db (saved variables), load modules and set up the GUI as well as profile management
--]]
local addonName, addonTable = ...
addonTable.RaidFrameSettings = LibStub("AceAddon-3.0"):NewAddon("RaidFrameSettings", "AceConsole-3.0", "AceEvent-3.0", "AceSerializer-3.0")
local RaidFrameSettings = addonTable.RaidFrameSettings
RaidFrameSettings:SetDefaultModuleLibraries("AceEvent-3.0")
RaidFrameSettings:SetDefaultModuleState(false)

local AC = LibStub("AceConfig-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local groupType

function RaidFrameSettings:OnInitialize()
    self:LoadDataBase()
    self:GetProfiles()
    groupType = self:GetGroupType()
    --load options table
    self:LoadUserInputEntrys()
    local options = self:GetOptionsTable()
    --create option table based on database structure and add them to options
    options.args.PorfileManagement.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db) 
    options.args.PorfileManagement.args.profile.order = 1
    --register options as option table to create a gui based on it
    AC:RegisterOptionsTable("RaidFrameSettings_options", options) 
    self:RegisterChatCommand("rfs", "SlashCommand")
    self:RegisterChatCommand("raidframesettings", "SlashCommand")
    self:RegisterEvent("PLAYER_LOGIN","LoadGroupBasedProfile")
end

function RaidFrameSettings:SlashCommand()
    if InCombatLockdown() then
        self:Print("Please leave combat and try again.")
        return
    end
    local frame = RaidFrameSettings:GetOptionsFrame()
    if not frame:IsShown() then
        frame:Show()
    else
        frame:Hide()
    end
end

function RaidFrameSettings:OnEnable()
    for _, module in self:IterateModules() do
        if self.db.profile.Module[module:GetName()] then 
            module:Enable()
        end
    end
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckGroupType") --GroupType.lua
end

function RaidFrameSettings:OnDisable()
    for name, module in self:IterateModules() do
        module:Disable()
    end
end

function RaidFrameSettings:UpdateModule(module_name)
    self:DisableModule(module_name)
    self:EnableModule(module_name)
end

function RaidFrameSettings:ReloadConfig()
    self:GetProfiles()
    self:LoadUserInputEntrys()
    self:Disable()
    self:Enable()
end

--Addon compartment 
_G.RaidFrameSettings_AddOnCompartmentClick = function()
    RaidFrameSettings:SlashCommand()
end



