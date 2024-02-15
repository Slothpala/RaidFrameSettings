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
            CustomScale = false,
            AuraHighlight = false,
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
            ["**"] = {
                font          = "Friz Quadrata TT",
                fontcolor     = {r=1,g=1,b=1,a=1},
                outline       = true,
                thick         = false,
                monochrome    = false,
            },
            Name = { 
                fontsize      = 12,
                useclasscolor = true,
                position      = 3,
                x_offset      = 0,
                y_offset      = -5,
            },
            Status = { 
                fontsize      = 14,
                useclasscolor = false,
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
            DebuffFramesDisplay = {
                width = 24,
                height = 22,
                cleanIcons = true,
                increase = 1.2,
                point = 1,
                relativePoint = 1,
                xOffset = 4,
                yOffset = -4,
                orientation = 2,
                gap = 0,
                swipe = true,
                edge = true,
                inverse = false,
                timerText = true,
            },
            DurationDisplay = {
                font = "Friz Quadrata TT",
                outlinemode = 2,
                fontSize = 14,
                fontColor = {r=1,g=1,b=1,a=1},
                shadowColor = {r=0,g=0,b=0,a=1},
                xOffsetShadow = 0,
                yOffsetShadow = 0,
                point = 1,
                relativePoint = 1,
                xOffsetFont = -4,
                yOffsetFont = 4,
            },
            StacksDisplay = {
                font = "Friz Quadrata TT",
                outlinemode = 2,
                fontSize = 12,
                fontColor = {r=1,g=1,b=0,a=1},
                shadowColor = {r=0,g=0,b=0,a=1},
                xOffsetShadow = 0,
                yOffsetShadow = 0,
                point = 9,
                relativePoint = 9,
                xOffsetFont = 0,
                yOffsetFont = 0,
            },
			Increase = {
                --[[spellID = name                ]]--
            },
            AuraFilter = {

            },
        },
        Buffs = {
            BuffFramesDisplay = {
                width = 28,
                height = 24,
                cleanIcons = true,
                point = 9,
                relativePoint = 9,
                xOffset = -4,
                yOffset = 4,
                orientation = 1,
                gap = 0,
                swipe = true,
                edge = true,
                inverse = true,
                timerText = true,
            },
            DurationDisplay = {
                font = "Friz Quadrata TT",
                outlinemode = 2,
                fontSize = 14,
                fontColor = {r=1,g=1,b=1,a=1},
                shadowColor = {r=0,g=0,b=0,a=1},
                xOffsetShadow = 0,
                yOffsetShadow = 0,
                point = 1,
                relativePoint = 1,
                xOffsetFont = -4,
                yOffsetFont = 4,
            },
            StacksDisplay = {
                font = "Friz Quadrata TT",
                outlinemode = 2,
                fontSize = 12,
                fontColor = {r=1,g=1,b=0,a=1},
                shadowColor = {r=0,g=0,b=0,a=1},
                xOffsetShadow = 0,
                yOffsetShadow = 0,
                point = 9,
                relativePoint = 9,
                xOffsetFont = 0,
                yOffsetFont = 0,
            },
            AuraPosition = {

            },
            AuraFilter = {

            },
        },
        AuraHighlight = {
            Config = {
                operation_mode = 1,
                Curse = false,
                Disease = false,
                Magic = false,
                Poison = false,
                Bleed = false,
            },
            DebuffColors = {
                Curse   = {r=0.6,g=0.0,b=1.0},
                Disease = {r=0.6,g=0.4,b=0.0},
                Magic   = {r=0.2,g=0.6,b=1.0},
                Poison  = {r=0.0,g=0.6,b=0.0},
                Bleed   = {r=0.8,g=0.0,b=0.0},
            },
            MissingAura = {
                classSelection = 1,
                missingAuraColor = {r=0.8156863451004028,g=0.5803921818733215,b=0.658823549747467}, 
                ["*"] = {
                    input_field = "",
                    spellIDs = {},
                },
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
            Overabsorb = {
                glowAlpha = 1,
            },
        },
        PorfileManagement = {
            GroupProfiles = {
                partyprofile = "Default",
                raidprofile  = "Default",
            },
        },
    },
    global = {
        GroupProfiles = {
            party = "Default",
            raid = "Default",
            arena = "Default",
            battleground = "Default",
        },
    },
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

function RaidFrameSettings:SetModuleStatus(info, value)
    self.db.profile.Module[info[#info]] = value
    --will reload the config each time the settings have been adjusted
    self:ReloadConfig()
end

--status
function RaidFrameSettings:GetStatus(info)
    return self.db.profile[info[#info-2]][info[#info-1]][info[#info]]
end

function RaidFrameSettings:SetStatus(info, value)
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]] = value
    --will reload the config each time the settings have been adjusted
    local module_name = info[#info-2] == "MinorModules" and info[#info-1] or info[#info-2]
    self:UpdateModule(module_name)
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
    local module_name = info[#info-2] == "MinorModules" and info[#info-1] or info[#info-2]
    self:UpdateModule(module_name)
end

function RaidFrameSettings:GetGlobal(info)
    return self.db.profile[info[#info-2]][info[#info-1]][info[#info]]
end

function RaidFrameSettings:SetGlobal(info, value)
    self.db.profile[info[#info-2]][info[#info-1]][info[#info]] = value
end