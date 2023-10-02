--[[
    Created by Slothpala 
    DB:
    Setup the default database structure for the user settings.
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local defaults = {
    profile = {
        Module = {
            ["*"]   = true,
            Buffs   = false,
            Debuffs = false,
            DispelColor = false,
            CustomScale = false,
        },
        HealthBars = { 
            Textures = { 
                statusbar  = "Solid",
                powerbar   = "Solid",
                background = "Solid",
                border     = "Solid",
            },
            Colors = { 
                statusbarmode = 1,
                statusbar     = {r=1,g=1,b=1,a=1},
                background    = {r=0.2,g=0.2,b=0.2,a=1},
                border        = {r=0,g=0,b=0,a=1},
            },
        },
        Fonts = { 
            Name = { 
                font          = "Friz Quadrata TT",
                fontsize      = 12,
                fontcolor     = {r=1,g=1,b=1,a=1},
                useclasscolor = true,
                outlinemode   = 1,
                position      = 3,
                x_offset      = 0,
                y_offset      = -5,
            },
            Status = { 
                font          = "Friz Quadrata TT",
                fontsize      = 14,
                fontcolor     = {r=1,g=1,b=1,a=1},
                useclasscolor = false,
                outlinemode   = 1,
                position      = 2,
                x_offset      = 0,
                y_offset      = -5,
            },
            Advanced = {
                shadowColor = {r=0,g=0,b=0,a=1},
                x_offset = 0,
                y_offset = 0,
            },
        },
        Debuffs = {
            Display = {
                width         = 18,
                height        = 18,
                increase      = 5,
                point         = 3,
                relativePoint = 3,
                x_offset      = 0,
                y_offset      = 0,
                orientation   = 2,
            },
            Blacklist = {
                --[[spellID = name                ]]--
            },
        },
        Buffs = {
            Display = {
                width  = 18,
                height = 18,
                clean_icons = true,
                point         = 4,
                relativePoint = 4,
                x_offset      = -4,
                y_offset      = 4,
                orientation   = 1,
            },
            Blacklist = {
                --spellID = true
            },
        },
        MinorModules = {
            RoleIcon = {
                position    = 1,
                x_offset    = 0,
                y_offset    = 0,
                scaleFactor = 1,
            },
            RangeAlpha = {
                statusbar  = 0.3,
                background = 0.2,
            },
            DispelColor = {
                curse   = {r=0.6,g=0.0,b=1.0},
                disease = {r=0.6,g=0.4,b=0.0},
                magic   = {r=0.2,g=0.6,b=1.0},
                poison  = {r=0.0,g=0.6,b=0.0},
            },
            CustomScale = {
                Party = 1,
                Raid  = 1,
                Arena = 1,
            },
        },
        PorfileManagement = {
            GroupProfiles = {
                partyprofile = "Default",
                raidprofile  = "Default",
            },
        },
    }
}

function RaidFrameSettings:LoadDataBase()
    self.db = LibStub("AceDB-3.0"):New("RaidFrameSettingsDB", defaults, true) 
    --db callbacks
    self.db.RegisterCallback(self, "OnNewProfile", "ReloadConfig")
    self.db.RegisterCallback(self, "OnProfileDeleted", "ReloadConfig")
    self.db.RegisterCallback(self, "OnProfileChanged", "ReloadConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "ReloadConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "ReloadConfig")
end

--for modules having this seperated makes it easier to iterate modules 
function RaidFrameSettings:GetModuleStatus(info)
    return self.db.profile.Module[info[#info]]
end

function RaidFrameSettings:SetModuleStatus(info,value)
    self.db.profile.Module[info[#info]] = value
    --will reload the config each time the settings have been adjusted
    self:ReloadConfig()
end

--status
function RaidFrameSettings:GetStatus(info)
    return self.db.profile[info[#info-2]][info[#info-1]][info[#info]]
end

function RaidFrameSettings:SetStatus(info,value)
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]] = value
    --will reload the config each time the settings have been adjusted
    self:ReloadConfig()
end

--color
function RaidFrameSettings:GetColor(info)
    return self.db.profile[info[#info-2]][info[#info-1]][info[#info]].r, self.db.profile[info[#info-2]][info[#info-1]][info[#info]].g, self.db.profile[info[#info-2]][info[#info-1]][info[#info]].b, self.db.profile[info[#info-2]][info[#info-1]][info[#info]].a
end

function RaidFrameSettings:SetColor(info, r,g,b,a)
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]].r = r 
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]].g = g
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]].b = b
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]].a = a
    self:ReloadConfig()
end

