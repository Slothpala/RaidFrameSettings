--[[
    Created by Slothpala 
    Setup the AddOn. I.e load the db (saved variables), load modules and set up the GUI as well as profile management
--]]
RaidFrameSettings = LibStub("AceAddon-3.0"):NewAddon("RaidFrameSettings", "AceConsole-3.0", "AceEvent-3.0", "AceSerializer-3.0")
RaidFrameSettings:SetDefaultModuleLibraries("AceEvent-3.0")
RaidFrameSettings:SetDefaultModuleState(false)

local AC         = LibStub("AceConfig-3.0")
local ACD        = LibStub("AceConfigDialog-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LGF        = LibStub("LibGetFrame-1.0")
local AceGUI     = LibStub("AceGUI-3.0")

--GUI Shared xml template with AceGUI widgets 
local OptionsFrame = CreateFrame("Frame", "RaidFrameSettingsOptions", UIParent, "PortraitFrameTemplate")
tinsert(UISpecialFrames, OptionsFrame:GetName())
OptionsFrame:SetFrameStrata("DIALOG")
OptionsFrame:SetSize(800,550)
OptionsFrame:SetPoint("CENTER", UIparent, "CENTER")
OptionsFrame:EnableMouse(true)
OptionsFrame:SetMovable(true)
OptionsFrame:SetResizable(true)
OptionsFrame:SetResizeBounds(300,200)
OptionsFrame:SetClampedToScreen(true)
OptionsFrame:RegisterForDrag("LeftButton")
OptionsFrame:SetScript("OnDragStart", OptionsFrame.StartMoving)
OptionsFrame:SetScript("OnDragStop", OptionsFrame.StopMovingOrSizing)
OptionsFrame:Hide()
RaidFrameSettingsOptionsPortrait:SetTexture("Interface\\AddOns\\RaidFrameSettings\\Textures\\Icon\\Icon.tga")

local resizeButton = CreateFrame("Button", "RaidFrameSettingsOptionsResizeButton", OptionsFrame)
resizeButton:SetPoint("BOTTOMRIGHT", -5, 7)
resizeButton:SetSize(14, 14)
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
resizeButton:SetScript("OnMouseDown", function(_, button) 
    if button == "LeftButton" then
        OptionsFrame:StartSizing("BOTTOMRIGHT")
    end
end)
resizeButton:SetScript("OnMouseUp", function()
    OptionsFrame:StopMovingOrSizing("BOTTOMRIGHT")
end)

local container = AceGUI:Create("SimpleGroup")
container.frame:SetParent(OptionsFrame)
container.frame:SetPoint("TOPLEFT", OptionsFrame, "TOPLEFT", 2, -22)
container.frame:SetPoint("BOTTOMRIGHT", OptionsFrame, "BOTTOMRIGHT", -2, 3)
OptionsFrame.container = container

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
    OptionsFrame:Show()
    RaidFrameSettingsOptionsTitleText:SetText("RaidFrameSettings")
    --open the addon settings
    ACD:Open("RaidFrameSettings_options",OptionsFrame.container)
end

function RaidFrameSettings:LoadConfig()  
    for _, module in self:IterateModules() do
        if self.db.profile.Module[module:GetName()] then 
            module:Enable()
        end
    end
end

local update_queued = nil
function RaidFrameSettings:UpdateAfterCombat()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:ReloadConfig()
    update_queued = false
end

function RaidFrameSettings:ReloadConfig()
    if InCombatLockdown() then 
        if update_queued then return end
        self:RegisterEvent("PLAYER_REGEN_ENABLED","UpdateAfterCombat") 
        self:Print("Settings will apply after combat")
        update_queued = true
        return 
    end
    for _, module in self:IterateModules() do
        module:Disable()
    end
    self:GetProfiles()
    self:WipeAllCallbacks()
    self:LoadConfig()
    self:UpdateAllFrames()
end

--group type profiles
local groupType = IsInRaid() and "raid" or IsInGroup() and "party" or ""

RaidFrameSettings:RegisterEvent("GROUP_ROSTER_UPDATE",function(event)
    local newgroupType = IsInRaid() and "raid" or IsInGroup() and "party" or ""
    if (newgroupType ~= groupType) then
        groupType = newgroupType
        C_Timer.After(2, function() 
            RaidFrameSettings:LoadGroupBasedProfile()
        end)
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



