--[[
    Created by Slothpala 
    Setup the AddOn. I.e load the db (saved variables), load modules and set up the GUI as well as profile management
--]]
local addonName, addonTable = ...
addonTable.RaidFrameSettings = LibStub("AceAddon-3.0"):NewAddon("RaidFrameSettings", "AceConsole-3.0", "AceEvent-3.0", "AceSerializer-3.0")
local RaidFrameSettings = addonTable.RaidFrameSettings
RaidFrameSettings:SetDefaultModuleLibraries("AceEvent-3.0")
RaidFrameSettings:SetDefaultModuleState(false)

local AC         = LibStub("AceConfig-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")

function RaidFrameSettings:OnInitialize()
    self:LoadDataBase()
    self:RegisterChatCommand("rfs", "SlashCommand")
    self:RegisterChatCommand("raidframesettings", "SlashCommand")
end

function RaidFrameSettings:OnEnable()
    --load options table
    self:LoadUserInputEntrys()
    local options = self:GetOptionsTable()
    --create option table based on database structure and add them to options
    options.args.PorfileManagement.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db) 
    options.args.PorfileManagement.args.profile.order = 1
    --register options as option table to create a gui based on it
    AC:RegisterOptionsTable("RaidFrameSettings_options", options) 
    self:GetProfiles()
    self:LoadGroupBasedProfile()
    self:LoadConfig()
end

function RaidFrameSettings:SlashCommand()
    local frame = RaidFrameSettings:GetOptionsFrame()
    if not frame:IsShown() then
        frame:Show()
    else
        frame:Hide()
    end
end

function RaidFrameSettings:LoadConfig()  
    for _, module in self:IterateModules() do
        if self.db.profile.Module[module:GetName()] then 
            module:Enable()
        end
    end
end

function RaidFrameSettings:UpdateAfterCombat()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:ReloadConfig()
end

local updateQueued = nil
function RaidFrameSettings:ReloadConfig()
    if not updateQueued then
        updateQueued = true
        C_Timer.After(0.25, function()
            if InCombatLockdown() then 
                RaidFrameSettings:RegisterEvent("PLAYER_REGEN_ENABLED","UpdateAfterCombat") 
                RaidFrameSettings:Print("Settings will apply after combat")
            else
                for _, module in RaidFrameSettings:IterateModules() do
                    module:Disable()
                end
                RaidFrameSettings:GetProfiles()
                RaidFrameSettings:WipeAllCallbacks()
                RaidFrameSettings:LoadConfig()
                RaidFrameSettings:UpdateAllFrames()
            end
            updateQueued = false
        end)
    end
end

--group type profiles
local groupType = IsInRaid() and "raid" or IsInGroup() and "party" or ""

RaidFrameSettings:RegisterEvent("GROUP_ROSTER_UPDATE",function(event)
    local newgroupType = IsInRaid() and "raid" or IsInGroup() and "party" or ""
    if (newgroupType ~= groupType) then
        groupType = newgroupType
        RaidFrameSettings:LoadGroupBasedProfile()
    end
end)

function RaidFrameSettings:LoadGroupBasedProfile()
    local groupProfileName = groupType == "raid" and RaidFrameSettingsDBRP or RaidFrameSettingsDBPP or "Default"
    local currentProfile = self.db:GetCurrentProfile()
    if currentProfile ~= groupProfileName then
        self.db:SetProfile(groupProfileName) 
        RaidFrameSettings:Print("Profile set to: "..groupProfileName)
    end
end

--profile import / export functions
--[[
    the method to share and import profiles is based on:
    https://github.com/brittyazel/EnhancedRaidFrames/blob/main/EnhancedRaidFrames.lua
--]]
function RaidFrameSettings:ShareProfile()
    --AceSerialize
	local serialized_profile = self:Serialize(self.db.profile) 
    --LibDeflate
	local compressed_profile = LibDeflate:CompressZlib(serialized_profile) 
	local encoded_profile    = LibDeflate:EncodeForPrint(compressed_profile)
	return encoded_profile
end

function RaidFrameSettings:ImportProfile(input)
    --validate input
    --empty?
    if input == "" then
        self:Print("No import string provided. Abort")
        return
    end
    --LibDeflate decode
    local decoded_profile = LibDeflate:DecodeForPrint(input)
    if decoded_profile == nil then
        self:Print("Decoding failed. Abort")
        return
    end
    --LibDefalte uncompress
    local uncompressed_profile = LibDeflate:DecompressZlib(decoded_profile)
    if uncompressed_profile == nil then
        self:Print("Uncompressing failed. Abort")
        return
    end
    --AceSerialize
    --deserialize the profile and overwirte the current values
    local valid, imported_Profile = self:Deserialize(uncompressed_profile)
    if valid and imported_Profile then
		for i,v in pairs(imported_Profile) do
			self.db.profile[i] = CopyTable(v)
		end
    else
        self:Print("Invalid profile. Abort")
    end
end

--Addon compartment 
_G.RaidFrameSettings_AddOnCompartmentClick = function()
    RaidFrameSettings:SlashCommand()
end



