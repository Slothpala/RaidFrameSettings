--[[
    Created by Slothpala 
    Options:
    Create an options table for the GUI
    I know it's a bit messy, but I'm planning to create a new, more intuitive UI for The War Within, so I won't be spending any time cleaning this up.
    The same goes for localisation. I don't want to waste people's time translating it, only to have to redo it a few months later.
--]]
local _, addonTable = ...
local isVanilla, isWrath, isClassic, isRetail = addonTable.isVanilla, addonTable.isWrath, addonTable.isClassic, addonTable.isRetail
local RaidFrameSettings = addonTable.RaidFrameSettings
local Media = LibStub("LibSharedMedia-3.0")
local lastEntry = 10
local HealthBars_disabled  = function() return not RaidFrameSettings.db.profile.Module.HealthBars end
local Fonts_disabled       = function() return not RaidFrameSettings.db.profile.Module.Fonts end
local RoleIcon_disabled    = function() return not RaidFrameSettings.db.profile.Module.RoleIcon end
local Range_disabled       = function() return not RaidFrameSettings.db.profile.Module.Range end
local Buffs_disabled       = function() return not RaidFrameSettings.db.profile.Module.Buffs end
local Debuffs_disabled     = function() return not RaidFrameSettings.db.profile.Module.Debuffs end
local AuraHighlight_disabled = function() return not RaidFrameSettings.db.profile.Module.AuraHighlight end
local CustomScale_disabled = function() return not RaidFrameSettings.db.profile.Module.CustomScale end
local Overabsorb_disabled = function() return not RaidFrameSettings.db.profile.Module.Overabsorb end
local Blacklist_disabled = function() return not RaidFrameSettings.db.profile.Module.Blacklist end
local Watchlist_disabled = function() return not RaidFrameSettings.db.profile.Module.Watchlist end
--LibDDI-1.0
local statusbars =  LibStub("LibSharedMedia-3.0"):List("statusbar")

--[[
    tmp locals
]]

local function getFontOptions()
    local font_options = {
        font = {
            order = 1,
            type = "select",
            dialogControl = "LSM30_Font", 
            name = "Font",
            values = Media:HashTable("font"), 
            get = "GetStatus",
            set = "SetStatus",
        },
        outlinemode = {
            order = 2,
            name = "Outlinemode",
            type = "select",
            values = {"None", "Outline", "Thick Outline", "Monochrome", "Monochrome Outline", "Monochrome Thick Outline"},
            sorting = {1,2,3,4,5,6},
            get = "GetStatus",
            set = "SetStatus",
        },
        newline = {
            order = 3,
            type = "description",
            name = "",
        },
        fontSize = {
            order = 4,
            name = "Font Size",
            type = "range",
            get = "GetStatus",
            set = "SetStatus",
            min = 1,
            max = 40,
            step = 1,
        },
        fontColor = {
            order = 5,
            type = "color",
            name = "Font Color", 
            get = "GetColor",
            set = "SetColor",
            width = 0.8,
        },
        shadowColor = {
            order = 6,
            type = "color",
            name = "Shadow Color", 
            get = "GetColor",
            set = "SetColor",
            hasAlpha = true,
            width = 0.8,
        },
        xOffsetShadow = {
            order = 7,
            name = "Shadow x-offset",
            type = "range",
            get = "GetStatus",
            set = "SetStatus",
            softMin = -4,
            softMax = 4,
            step = 0.1,
            width = 0.8,
        },
        yOffsetShadow = {
            order = 8,
            name = "Shadow y-offset",
            type = "range",
            get = "GetStatus",
            set = "SetStatus",
            softMin = -4,
            softMax = 4,
            step = 0.1,
            width = 0.8,
        },
        newline2 = {
            order = 9,
            type = "description",
            name = "",
        },
        point = {
            order = 10,
            name = "Anchor",
            type = "select",
            values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
            sorting = {1,2,3,4,5,6,7,8,9},
            get = "GetStatus",
            set = "SetStatus",
        },
        relativePoint = {
            order = 11,
            name = "to Frames",
            type = "select",
            values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
            sorting = {1,2,3,4,5,6,7,8,9},
            get = "GetStatus",
            set = "SetStatus",
        },
        xOffsetFont = {
            order = 12,
            name = "x - offset",
            type = "range",
            get = "GetStatus",
            set = "SetStatus",
            softMin = -25,
            softMax = 25,
            step = 1,
            width = 0.8,
        },
        yOffsetFont = {
            order = 13,
            name = "y - offset",
            type = "range",
            get = "GetStatus",
            set = "SetStatus",
            softMin = -25,
            softMax = 25,
            step = 1,
            width = 0.8,
        },
        newline3 = {
            order = 14,
            type = "description",
            name = "",
        },
    }
    return font_options
end

local function getDebuffDurationOptions()
    local font_options = getFontOptions()
    font_options.durationByDebuffColor = {
        order = 15,
        name = "Color timer by debuff color.",
        type = "toggle",
        get = "GetStatus",
        set = "SetStatus",
        width = 1.5,
    }
    return font_options
end

local profiles = {}
local options = {
    name = "Raid Frame Settings",
    handler = RaidFrameSettings,
    type = "group",
    childGroups = "tree",
    args = {
        Version = {
            order = 0,
            name = "@project-version@",
            type = "group",
            disabled = true,
            args = {},
        },
        Config = {
            order = lastEntry-1,
            name = "Enabled Modules",
            type = "group",
            args = {
                Modules = {
                    order = 1,
                    name = "Modules",
                    type = "group",
                    inline = true,
                    args = {
                        HealthBars = {
                            order = 1,
                            type = "toggle",
                            name = "Health Bars",
                            desc = "Choose colors and textures for Health Bars.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r to |cffFFFF00MEDIUM|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Fonts = {
                            order = 2,
                            type = "toggle",
                            name = "Fonts",
                            desc = "Adjust the Font, Font Size, Font Color as well as the position for the Names and Status Texts.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r to |cffFFFF00MEDIUM|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        RoleIcon = {
                            hidden = isVanilla,
                            order = 3,
                            type = "toggle",
                            name = "Role Icon",
                            desc = "Position the Role Icon.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        RangeAlpha = {
                            order = 4,
                            type = "toggle",
                            name = "Range",
                            desc = "Use custom alpha values for out of range units.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r to |r|cffFFFF00MEDIUM|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Buffs = {
                            order = 5,
                            type = "toggle",
                            name = "Buffs",
                            desc = "Adjust the position, orientation and size of buffs.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r to |r|cffFFFF00MEDIUM|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Debuffs = {
                            order = 6,
                            type = "toggle",
                            name = "Debuffs",
                            desc = "Adjust the position, orientation and size of debuffs.\n|cffF4A460CPU Impact: |r|cffFFFF00MEDIUM|r to |r|cffFF474DHIGH|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Overabsorb = {
                            hidden = not isRetail,
                            order = 7,
                            type = "toggle",
                            name = "Overabsorb",
                            desc = "Show absorbs above the units max hp.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        AuraHighlight = {
                            hidden = not isRetail,
                            order = 8,
                            type = "toggle",
                            name = "Aura Highlight",
                            desc = "Recolor unit health bars based on debuff type.\n|cffF4A460CPU Impact: |r|cffFFFF00MEDIUM|r to |r|cffFF474DHIGH|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        CustomScale = {
                            hidden = not isRetail,
                            order = 9,
                            type = "toggle",
                            name = "Custom Scale",
                            desc = "Set a scaling factor for raid and party frames.\n|cffF4A460CPU Impact: |r|cff90EE90NEGLIGIBLE|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Blacklist = {
                            order = 10,
                            type = "toggle",
                            name = "Blacklist",
                            desc = "Exclude specific buffs and debuffs from being displayed.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Watchlist = {
                            order = 11,
                            type = "toggle",
                            name = "Watchlist",
                            desc = "Configure raid frames to show auras that are not shown by default (e.g. defensive cooldowns). Additionally, track auras from other healers or players, and choose whether to display these auras only when they originate from you or set them to only be shown out of combat.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        MinimapButton = {
                            order = 12,
                            type = "toggle",
                            name = "Minimap Icon",
                            desc = "Toggle the minimap icon on or off.",
                            get = function()
                                return RaidFrameSettings.db.global.MinimapButton.enabled 
                            end,
                            set = function(_, value)
                                RaidFrameSettings.db.global.MinimapButton.enabled = value
                                RaidFrameSettings:UpdateModule("MinimapButton")
                            end,
                        },  
                    },
                },
                DescriptionBox = {
                    order = 2,
                    name = "Hints:",
                    type = "group",
                    inline = true,
                    args = {
                        description = {
                            order = 1,
                            name = "The default UI links the name text to the right of the role icon, so in some cases you will need to use both modules if you want to use either one.",
                            fontSize = "medium",
                            type = "description",
                        },
                        newline1 = {
                            order = 1.1,
                            name = " ",
                            fontSize = "medium",
                            type = "description",
                        },
                        performanceNote = {
                            order = 2,
                            name = "About |cffF4A460CPU Impact:|r The first value means small 5 man groups, the last value massive 40 man raids. As more frames are added, the addon must do more work. The addon runs very efficiently when the frames are set up, but you can get spikes when people spam leave and/or join the group, such as at the end of a battleground or in massive open world farm groups. The blizzard frames update very often in these scenarios and the addon needs to follow this.",
                            fontSize = "medium",
                            type = "description",
                        },
                        newline2 = {
                            order = 2.1,
                            name = " ",
                            fontSize = "medium",
                            type = "description",
                        },
                        auralistnote = {
                            order = 3,
                            name = "Watchlist and Blacklist rely on the Buffs (for buff spellIds) and Debuffs (for debuff spellIds) modules to work.",
                            fontSize = "medium",
                            type = "description",
                        },
                    },
                },
            },
        },
        HealthBars = {
            order = 2,
            name = "Health Bars",
            type = "group",
            hidden = HealthBars_disabled,
            args = {
                Textures = {
                    order = 1,
                    name = " ",
                    type = "group",
                    inline = true,
                    args = {
                        Header = {
                            order = 1,
                            type = "header",
                            name = "Textures",
                        },
                        statusbar = {
                            order = 2,
                            type = "select",
                            name = "Health Bar",
                            values = statusbars,
                            get = function()
                                for i, v in next, statusbars do
                                    if v == RaidFrameSettings.db.profile.HealthBars.Textures.statusbar then return i end
                                end
                            end,
                            set = function(_, value)
                                RaidFrameSettings.db.profile.HealthBars.Textures.statusbar  = statusbars[value]
                                RaidFrameSettings:ReloadConfig()
                            end,
                          itemControl = "DDI-Statusbar",
                          width = 1.6,
                        },
                        background = {
                            order = 3,
                            type = "select",
                            name = "Health Bar Background",
                            values = statusbars,
                            get = function()
                                for i, v in next, statusbars do
                                    if v == RaidFrameSettings.db.profile.HealthBars.Textures.background then return i end
                                end
                            end,
                            set = function(_, value)
                                RaidFrameSettings.db.profile.HealthBars.Textures.background  = statusbars[value]
                                RaidFrameSettings:ReloadConfig()
                            end,
                          itemControl = "DDI-Statusbar",
                          width = 1.6,
                        },
                        newline = {
                            order = 4,
                            type = "description",
                            name = "",
                        },
                        powerbar = {
                            order = 5,
                            type = "select",
                            name = "Power Bar",
                            values = statusbars,
                            get = function()
                                for i, v in next, statusbars do
                                    if v == RaidFrameSettings.db.profile.HealthBars.Textures.powerbar then return i end
                                end
                            end,
                            set = function(_, value)
                                RaidFrameSettings.db.profile.HealthBars.Textures.powerbar  = statusbars[value]
                                RaidFrameSettings:ReloadConfig()
                            end,
                          itemControl = "DDI-Statusbar",
                          width = 1.6,
                        },
                        border = {
                            guiHidden = true,
                            order = 6,
                            type = "select",
                            dialogControl = "LSM30_Border", 
                            name = "Border", 
                            values = Media:HashTable("statusbar"), 
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 1.6,
                        },
                    },
                },
                Colors = {
                    order = 2,
                    name = " ",
                    type = "group",
                    inline = true,
                    args = {
                        Header = {
                            order = 1,
                            type = "header",
                            name = "Colors",
                        },
                        statusbarmode = {
                            order = 2,
                            name = "Health Bar",
                            desc = "1. - Blizzards setting for Class Colors. \n2. - Blizzards setting for a unified green color. \n3. - AddOns setting for a customizable unified color.",
                            type = "select",
                            values = {"Blizzard - Class Color", "Blizzard - Green Color", "AddOn - Static Color"},
                            sorting = {1,2,3},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        statusbar = {
                            order = 2.1,
                            type = "color",
                            name = "Health Bar", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 1,
                            hidden = function() if RaidFrameSettings.db.profile.HealthBars.Colors.statusbarmode == 3 then return false end; return true end
                        },
                        newline = {
                            order = 3,
                            type = "description",
                            name = "",
                        },
                        background = {
                            order = 4,
                            type = "color",
                            name = "Health Bar Background", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 1,
                        },
                        newline2 = {
                            order = 5,
                            type = "description",
                            name = "",
                        },
                        border = {
                            order = 6,
                            type = "color",
                            name = "Border", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 1,
                        },
                    },
                },
            },
        },
        Fonts = {
            order = 3,
            name = "Fonts",
            type = "group",
            childGroups = "tab",
            hidden = Fonts_disabled,
            args = {
                Name = {
                    order = 1,
                    name = "Name",
                    type = "group",
                    args = {
                        font = {
                            order = 2,
                            type = "select",
                            dialogControl = "LSM30_Font", 
                            name = "Font",
                            values = Media:HashTable("font"), 
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        outline = {
                            order = 3,
                            name = "OUTLINE",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                        thick = {
                            disabled = function() return not RaidFrameSettings.db.profile.Fonts.Name.outline end,
                            order = 3.1,
                            name = "THICK",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.4,
                        },
                        monochrome = {
                            order = 3.2,
                            name = "MONOCHROME",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.8,
                        },
                        newline = {
                            order = 3.3,
                            type = "description",
                            name = "",
                        },
                        fontsize = {
                            order = 4,
                            name = "Font size",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 1,
                            max = 40,
                            step = 1,
                        },
                        useclasscolor = {
                            order = 5,
                            name = "Class Colored",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.8,
                        },
                        fontcolor = {
                            order = 6,
                            type = "color",
                            name = "Name color", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.8,
                            disabled = function() return RaidFrameSettings.db.profile.Fonts.Name.useclasscolor end,
                        },
                        newline2 = {
                            order = 6.1,
                            type = "description",
                            name = "",
                        },
                        position = {
                            order = 7,
                            name = "Position",
                            type = "select",
                            values = {"TOPLEFT", "CENTER", "TOP", "BOTTOM"},
                            sorting = {1,2,3,4},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        x_offset = {
                            order = 8,
                            name = "x - offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -25,
                            softMax = 25,
                            step = 1,
                            width = 0.8,
                        },
                        y_offset = {
                            order = 9,
                            name = "y - offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -25,
                            softMax = 25,
                            step = 1,
                            width = 0.8,
                        },
                    },
                },
                Status = {
                    order = 2,
                    name = "Status",
                    type = "group",
                    args = {
                        font = {
                            order = 2,
                            type = "select",
                            dialogControl = "LSM30_Font", 
                            name = "Font",
                            values = Media:HashTable("font"), 
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        outline = {
                            order = 3,
                            name = "OUTLINE",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                        thick = {
                            disabled = function() return not RaidFrameSettings.db.profile.Fonts.Status.outline end,
                            order = 3.1,
                            name = "THICK",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.4,
                        },
                        monochrome = {
                            order = 3.2,
                            name = "MONOCHROME",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.8,
                        },
                        newline = {
                            order = 3.3,
                            type = "description",
                            name = "",
                        },
                        fontsize = {
                            order = 4,
                            name = "Font size",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 1,
                            max = 40,
                            step = 1,
                        },
                        fontcolor = {
                            order = 6,
                            type = "color",
                            name = "Status color", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.8,
                        },
                        newline2 = {
                            order = 6.1,
                            type = "description",
                            name = "",
                        },
                        position = {
                            order = 7,
                            name = "Position",
                            type = "select",
                            values = {"TOPLEFT", "CENTER", "TOP", "BOTTOM"},
                            sorting = {1,2,3,4},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        x_offset = {
                            order = 8,
                            name = "x - offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -25,
                            softMax = 25,
                            step = 1,
                            width = 0.8,
                        },
                        y_offset = {
                            order = 9,
                            name = "y - offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -25,
                            softMax = 25,
                            step = 1,
                            width = 0.8,
                        },
                    },
                },
                Advanced = {
                    order = 3,
                    name = "Advanced",
                    type = "group",
                    args = {
                        shadowColor = {
                            order = 2,
                            type = "color",
                            name = "Shadow color", 
                            get = "GetColor",
                            set = "SetColor",
                            hasAlpha = true,
                            width = 0.8,
                        },
                        x_offset = {
                            order = 3,
                            name = "Shadow x-offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -4,
                            softMax = 4,
                            step = 0.1,
                            width = 0.8,
                        },
                        y_offset = {
                            order = 4,
                            name = "Shadow y-offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -4,
                            softMax = 4,
                            step = 0.1,
                            width = 0.8,
                        },
                    },
                },
            },
        },
        Blacklist = {
            order = 4,
            hidden = Blacklist_disabled,
            name = "Blacklist",
            type = "group",
            args = {
                addAura = {
                    order = 1,
                    name = "Enter spellId:",
                    type = "input",
                    pattern = "^%d+$",
                    usage = "please enter a number",
                    set = function(_, value)
                        RaidFrameSettings.db.profile.Blacklist[value] = true
                        RaidFrameSettings:CreateBlacklistEntry(value)
                        RaidFrameSettings:UpdateModule("Blacklist")
                    end,
                },
                auraList = {
                    order = 2,
                    name = "Blacklisted auras:",
                    type = "group",
                    inline = true,
                    args = {

                    },
                },
            },
        },
        Watchlist = {
            order = 5,
            hidden = Watchlist_disabled,
            name = "Watchlist",
            type = "group",
            args = {
                addAura = {
                    order = 1,
                    name = "Enter a spellId:",
                    type = "input",
                    pattern = "^%d+$",
                    usage = "please enter a number",
                    set = function(_, value)
                        RaidFrameSettings.db.profile.Watchlist[value] = {}
                        RaidFrameSettings:CreateWatchlistEntry(value)
                        RaidFrameSettings:UpdateModule("Watchlist")
                    end,
                },
                --[[
                addDebuff = {
                    order = 2,
                    name = "Enter a |cffFF474Ddebuff|r spellId:",
                    type = "input",
                    pattern = "^%d+$",
                    usage = "please enter a number",
                    set = function(_, value)
                        RaidFrameSettings.db.profile.Watchlist[value] = {
                            spellIsDebuff = true,
                        }
                        RaidFrameSettings:CreateWatchlistEntry(value)
                        RaidFrameSettings:UpdateModule("Watchlist")
                    end,
                },
                ]]
                importOptions = {
                    order = 3,
                    name = "Import presets:",
                    type = "group",
                    inline = true,
                    args = {
                        retailDefensiveCooldowns = {
                            order = 1,
                            hidden = not isRetail,
                            name = "Personal Defs",
                            desc = "Import the most imporant personal defensive cooldowns for all classes.",
                            type = "execute",
                            func = function()
                                local defensives = RaidFrameSettings:GetPersonalCooldowns()
                                for i=1, #defensives do 
                                    local spellId = defensives[i] 
                                    if not RaidFrameSettings.db.profile.Watchlist[spellId] then
                                        RaidFrameSettings.db.profile.Watchlist[spellId] = {}
                                        RaidFrameSettings:CreateWatchlistEntry(spellId)
                                    end
                                end
                                RaidFrameSettings:UpdateModule("Watchlist")
                            end,
                            width = 0.8,
                        },
                    },
                },
                auraList = {
                    order = 4,
                    name = "Auras:",
                    type = "group",
                    inline = true,
                    args = {

                    },
                },
            },
        },
        Auras = {
            order = 6,
            name = "Auraframe Settings",
            desc = "Buff & Debuff Frames",
            type = "group",
            childGroups = "select",
            hidden = function()
                return not RaidFrameSettings.db.profile.Module.Buffs and not RaidFrameSettings.db.profile.Module.Debuffs 
            end,
            args = {
                Buffs = {
                    hidden = Buffs_disabled,
                    order = 1,
                    name = "Buffs",
                    type = "group",
                    childGroups = "tab",
                    args = {
                        Buffs = { --name of the group is a workaround to not have several Set/Get functions just for that
                            order = 1,
                            name = "Display",
                            type = "group",
                            childGroups = "tab",
                            args = {
                                BuffFramesDisplay = {
                                    order = 1,
                                    name = "Buff Frames",
                                    type = "group",
                                    args = {
                                        width = {
                                            order = 1,
                                            name = "width",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 1,
                                            max = 50,
                                            step = 1,
                                            width = 1,
                                        },
                                        height = {
                                            order = 2,
                                            name = "height",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 1,
                                            max = 50,
                                            step = 1,
                                            width = 1,
                                        },
                                        cleanIcons = {
                                            order = 2.1,
                                            type = "toggle",
                                            name = "Clean Icons",
                                            -- and replace it with a 1pixel border #later
                                            desc = "Crop the border. Keep the aspect ratio of icons when width is not equal to height.",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                        },
                                        newline = {
                                            order = 3,
                                            name = "",
                                            type = "description",
                                        },
                                        point = {
                                            order = 4,
                                            name = "Buffframe anchor",
                                            type = "select",
                                            values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
                                            sorting = {1,2,3,4,5,6,7,8,9},
                                            get = "GetStatus",
                                            set = "SetStatus",
                                        },
                                        relativePoint = {
                                            order = 5,
                                            name = "to Frames",
                                            type = "select",
                                            values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
                                            sorting = {1,2,3,4,5,6,7,8,9},
                                            get = "GetStatus",
                                            set = "SetStatus",
                                        },
                                        orientation = {
                                            order = 6,
                                            name = "direction of growth",
                                            type = "select",
                                            values = {"Left", "Right", "Up", "Down"},
                                            sorting = {1,2,3,4},
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.8,
                                        },
                                        newline2 = {
                                            order = 7,
                                            name = "",
                                            type = "description",
                                        },
                                        xOffset = {
                                            order = 8,
                                            name = "x - offset",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            softMin = -100,
                                            softMax = 100,
                                            step = 1,
                                            width = 1.4,
                                        },
                                        yOffset = {
                                            order = 9,
                                            name = "y - offset",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            softMin = -100,
                                            softMax = 100,
                                            step = 1,
                                            width = 1.4,
                                        },
                                        gap = {
                                            order = 9.1,
                                            name = "Gap",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            softMin = -10,
                                            softMax = 10,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        newline3 = {
                                            order = 10,
                                            name = "",
                                            type = "description",
                                        },
                                        swipe = {
                                            order = 11,
                                            type = "toggle",
                                            name = "Show \"Swipe\"", 
                                            desc = "Show the swipe radial overlay",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.8,
                                        },
                                        edge = {
                                            order = 12,
                                            type = "toggle",
                                            name = "Show \"Edge\"", 
                                            desc = "Show the glowing edge at the end of the radial overlay",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.8,
                                        },
                                        inverse = {
                                            order = 13,
                                            type = "toggle",
                                            name = "Inverse", 
                                            desc = "Invert the direction of the radial overlay",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.6,
                                        },
                                        timerText = {
                                            order = 14,
                                            type = "toggle",
                                            name = "Show Duration Timer Text", 
                                            desc = "Enabling this will display an aura duration timer. When the OmniCC add-on is loaded, it's cooldown timer will be hidden.",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 1.2,
                                        },
                                        newline4 = {
                                            order = 15,
                                            name = "",
                                            type = "description",
                                        },
                                        numBuffFrames = {
                                            order = 17,
                                            name = "number of icons",
                                            desc = "Adjust the number of buff icons in the dynamic buff icon frame. Auras set under \"Aura Position\" will exceed this limit and will always be displayed.",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 0,
                                            max = 10,
                                            step = 1,
                                            width = 1.4,
                                        },
                                    },
                                },
                                DurationDisplay = {
                                    order = 2,
                                    name = "Duration",
                                    type = "group",
                                    args = getFontOptions()
                                },
                                StacksDisplay = {
                                    order = 3,
                                    name = "Stacks",
                                    type = "group",
                                    args = getFontOptions()
                                },
                            },
                        },
                        AuraPosition = {
                            order = 4,
                            name = "Aura Position",
                            type = "group",
                            args = {
                                addAura = {
                                    order = 1,
                                    name = "Enter spellId:",
                                    type = "input",
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(_, value)
                                        RaidFrameSettings.db.profile.Buffs.AuraPosition[value] = {
                                            ["spellId"] = tonumber(value),
                                            point = 1,
                                            relativePoint = 1,
                                            xOffset = 0,
                                            yOffset = 0,
                                            scale = 1,
                                        }
                                        RaidFrameSettings:CreateAuraPositionEntry(value, "Buffs")
                                        RaidFrameSettings:UpdateModule("Buffs")
                                    end
                                },
                                auraList = {
                                    order = 2,
                                    name = "Auras:",
                                    type = "group",
                                    inline = true,
                                    args = {

                                    },
                                },
                            },
                        },
                    },  
                },
                Debuffs = {
                    hidden = Debuffs_disabled,
                    order = 2,
                    name = "Debuffs",
                    type = "group",
                    childGroups = "tab",
                    args = {
                        Debuffs = {
                            order = 1,
                            name = "Display",
                            type = "group",
                            childGroups = "tab",
                            args = {
                                DebuffFramesDisplay = {
                                    order = 1,
                                    name = "Debuff Frames",
                                    type = "group",
                                    args = {
                                        width = {
                                            order = 1,
                                            name = "width",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 1,
                                            max = 50,
                                            step = 1,
                                            width = 1,
                                        },
                                        height = {
                                            order = 2,
                                            name = "height",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 1,
                                            max = 50,
                                            step = 1,
                                            width = 1,
                                        },
                                        increase = {
                                            order = 2.1,
                                            name = "Aura increase",
                                            desc = "This will increase the size of \34Boss Auras\34 and the auras added in the \34Increase\34 section. Boss Auras are auras that the game deems to be more important by default.",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 1,
                                            max = 2,
                                            step = 0.1,
                                            width = 1,
                                            isPercent = true,
                                        },
                                        cleanIcons = {
                                            order = 2.2,
                                            type = "toggle",
                                            name = "Clean Icons",
                                            desc = "Crop the border. Keep the aspect ratio of icons when width is not equal to height.",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                        },
                                        newline = {
                                            order = 3,
                                            name = "",
                                            type = "description",
                                        },
                                        point = {
                                            order = 4,
                                            name = "Debuffframe anchor",
                                            type = "select",
                                            values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
                                            sorting = {1,2,3,4,5,6,7,8,9},
                                            get = "GetStatus",
                                            set = "SetStatus",
                                        },
                                        relativePoint = {
                                            order = 5,
                                            name = "to Frames",
                                            type = "select",
                                            values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
                                            sorting = {1,2,3,4,5,6,7,8,9},
                                            get = "GetStatus",
                                            set = "SetStatus",
                                        },
                                        orientation = {
                                            order = 6,
                                            name = "direction of growth",
                                            type = "select",
                                            values = {"Left", "Right", "Up", "Down"},
                                            sorting = {1,2,3,4},
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.8,
                                        },
                                        newline2 = {
                                            order = 7,
                                            name = "",
                                            type = "description",
                                        },
                                        xOffset = {
                                            order = 8,
                                            name = "x - offset",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            softMin = -100,
                                            softMax = 100,
                                            step = 1,
                                            width = 1.4,
                                        },
                                        yOffset = {
                                            order = 9,
                                            name = "y - offset",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            softMin = -100,
                                            softMax = 100,
                                            step = 1,
                                            width = 1.4,
                                        },
                                        gap = {
                                            order = 9.1,
                                            name = "Gap",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            softMin = -10,
                                            softMax = 10,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        newline3 = {
                                            order = 10,
                                            name = "",
                                            type = "description",
                                        },
                                        swipe = {
                                            order = 11,
                                            type = "toggle",
                                            name = "Show \"Swipe\"", 
                                            desc = "Show the swipe radial overlay",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.8,
                                        },
                                        edge = {
                                            order = 12,
                                            type = "toggle",
                                            name = "Show \"Edge\"", 
                                            desc = "Show the glowing edge at the end of the radial overlay",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.8,
                                        },
                                        inverse = {
                                            order = 13,
                                            type = "toggle",
                                            name = "Inverse", 
                                            desc = "Invert the direction of the radial overlay",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 0.6,
                                        },
                                        timerText = {
                                            order = 14,
                                            type = "toggle",
                                            name = "Show Duration Timer Text", 
                                            desc = "Enabling this will display an aura duration timer. When the OmniCC add-on is loaded, it's cooldown timer will be hidden.",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            width = 1.2,
                                        },
                                        newline4 = {
                                            order = 15,
                                            name = "",
                                            type = "description",
                                        },
                                        numFrames = {
                                            order = 17,
                                            name = "number of icons",
                                            desc = "Adjust the number of debuff icons in the dynamic debuff icon frame. Auras set under \"Aura Position\" will exceed this limit and will always be displayed.",
                                            type = "range",
                                            get = "GetStatus",
                                            set = "SetStatus",
                                            min = 0,
                                            max = 10,
                                            step = 1,
                                            width = 1.4,
                                        },
                                    },
                                },
                                DurationDisplay = {
                                    order = 2,
                                    name = "Duration",
                                    type = "group",
                                    args = getDebuffDurationOptions()
                                },
                                StacksDisplay = {
                                    order = 3,
                                    name = "Stacks",
                                    type = "group",
                                    args = getFontOptions()
                                },
                            },
                        },
						Increase = {
                            order = 2,
                            name = "Increase",
                            desc = "Set up auras to have the same size increase as boss auras.",
                            type = "group",
                            args = {
                                addAura = {
                                    order = 1,
                                    name = "Enter spellId:",
                                    desc = "",
                                    type = "input",
                                    width = 1.5,
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(_, value)
                                        RaidFrameSettings.db.profile.Debuffs.Increase[value] = true
                                        RaidFrameSettings:CreateIncreaseEntry(value, "Debuffs")
                                        RaidFrameSettings:UpdateModule("Debuffs")
                                    end,
                                },
                                IncreasedAuras = {
                                    order = 4,
                                    name = "Increase:",
                                    type = "group",
                                    inline = true,
                                    args = {

                                    },
                                },                           
                            },
                        },
                        AuraPosition = {
                            order = 3,
                            name = "Aura Position",
                            type = "group",
                            args = {
                                addAura = {
                                    order = 1,
                                    name = "Enter spellId:",
                                    type = "input",
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(_, value)
                                        RaidFrameSettings.db.profile.Debuffs.AuraPosition[value] = {
                                            ["spellId"] = tonumber(value),
                                            point = 1,
                                            relativePoint = 1,
                                            xOffset = 0,
                                            yOffset = 0,
                                            scale = 1,
                                        }
                                        RaidFrameSettings:CreateAuraPositionEntry(value, "Debuffs")
                                        RaidFrameSettings:UpdateModule("Debuffs")
                                    end
                                },
                                auraList = {
                                    order = 2,
                                    name = "Auras:",
                                    type = "group",
                                    inline = true,
                                    args = {

                                    },
                                },
                            },
                        },
                    },  
                },
            },
        },
        AuraHighlight = {
            order = 7,
            name = "Aura Highlight",
            type = "group",
            hidden = not isRetail or AuraHighlight_disabled,
            args = {
                Config = {
                    order = 1,
                    name = "Config",
                    type = "group",
                    inline = true,
                    args = {
                        operation_mode = {
                            order = 1,
                            name = "Operation mode",
                            desc = "Smart - The add-on will determine which debuffs you can dispel based on your talents and class, and will only highlight those debuffs. \nManual - You choose which debuff types you want to see.",
                            type = "select",
                            values = {"Smart", "Manual"},
                            sorting = {1,2},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        Curse = {
                            hidden = function() return RaidFrameSettings.db.profile.AuraHighlight.Config.operation_mode == 1 and true or false end,
                            order = 2,
                            name = "Curse",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                        Disease = {
                            hidden = function() return RaidFrameSettings.db.profile.AuraHighlight.Config.operation_mode == 1 and true or false end,
                            order = 3,
                            name = "Disease",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                        Magic = {
                            hidden = function() return RaidFrameSettings.db.profile.AuraHighlight.Config.operation_mode == 1 and true or false end,
                            order = 4,
                            name = "Magic",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                        Poison = {
                            hidden = function() return RaidFrameSettings.db.profile.AuraHighlight.Config.operation_mode == 1 and true or false end,
                            order = 5,
                            name = "Poison",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                        Bleed = {
                            hidden = function() return RaidFrameSettings.db.profile.AuraHighlight.Config.operation_mode == 1 and true or false end,
                            order = 6,
                            name = "Bleed",
                            type = "toggle",
                            get = "GetStatus",
                            set = "SetStatus",
                            width = 0.5,
                        },
                    },
                },
                DebuffColors = {
                    order = 2,
                    name = "Debuff colors",
                    type = "group",
                    inline = true,
                    args = {
                        Curse = {
                            order = 1,
                            type = "color",
                            name = "Curse", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        Disease  = {
                            order = 2,
                            type = "color",
                            name = "Disease", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        Magic = {
                            order = 3,
                            type = "color",
                            name = "Magic",
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        Poison = {
                            order = 4,
                            type = "color",
                            name = "Poison", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        Bleed = {
                            order = 5,
                            type = "color",
                            name = "Bleed", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        newline = {
                            order = 6,
                            type = "description",
                            name = "",
                        },
                        ResetColors = {
                            order = 7,
                            name = "reset",
                            desc = "to default",
                            type = "execute",
                            width = 0.4,
                            confirm = true,
                            func = 
                            function() 
                                RaidFrameSettings.db.profile.AuraHighlight.DebuffColors.Curse   = {r=0.6,g=0.0,b=1.0}
                                RaidFrameSettings.db.profile.AuraHighlight.DebuffColors.Disease = {r=0.6,g=0.4,b=0.0}
                                RaidFrameSettings.db.profile.AuraHighlight.DebuffColors.Magic   = {r=0.2,g=0.6,b=1.0}
                                RaidFrameSettings.db.profile.AuraHighlight.DebuffColors.Poison  = {r=0.0,g=0.6,b=0.0}
                                RaidFrameSettings.db.profile.AuraHighlight.DebuffColors.Bleed   = {r=0.8,g=0.0,b=0.0}
                                RaidFrameSettings:ReloadConfig()
                            end,
                        },
                    },
                },
                MissingAura = {
                    order = 3,
                    name = "Missing Aura",
                    type = "group",
                    inline = true,
                    args = {
                        classSelection = {
                            order = 1,
                            name = "Class:",
                            type = "select",
                            values = addonTable.playableHealerClasses,
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        missingAuraColor = {
                            order = 2,
                            name = "Missing Aura Color",
                            type = "color",
                            get = "GetColor",
                            set = "SetColor",
                        },
                        input_field = {
                            order = 3,
                            name = "Enter spellIDs",
                            desc = "enter spellIDs seperated by a semicolon or comma\nExample: 12345; 123; 456;",
                            type = "input",
                            width = "full",
                            multiline = 5,
                            set = function(self, input)
                                local dbObj = RaidFrameSettings.db.profile.AuraHighlight.MissingAura
                                local class = addonTable.playableHealerClasses[dbObj.classSelection]
                                dbObj[class].input_field = input
                                --transform string to a list of spellIDs:
                                local tbl = {}
                                for word in string.gmatch(input, "([^;,%s]+)") do
                                    local name = GetSpellInfo(word)
                                    if name then
                                        tbl[tonumber(word)] = name
                                    end
                                end
                                dbObj[class].spellIDs = tbl
                                RaidFrameSettings:UpdateModule("AuraHighlight")
                            end,
                            get = function() 
                                local dbObj = RaidFrameSettings.db.profile.AuraHighlight.MissingAura
                                local class = addonTable.playableHealerClasses[dbObj.classSelection]
                                return dbObj[class].input_field
                            end,
                        },
                    },
                },
            },
        },
        MinorModules = {
            order = 8,
            name = "Module Settings",
            type = "group",
            args = {
                RoleIcon = {
                    hidden = isVanilla or RoleIcon_disabled,
                    order = 1,
                    name = "Role Icon",
                    type = "group",
                    inline = true,
                    args = {
                        position = {
                            order = 1,
                            name = "Position",
                            type = "select",
                            values = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},
                            sorting = {1,2,3,4},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        x_offset = {
                            order = 2,
                            name = "x - offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -25,
                            softMax = 25,
                            step = 1,
                            width = 0.8,
                        },
                        y_offset = {
                            order = 3,
                            name = "y - offset",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            softMin = -25,
                            softMax = 25,
                            step = 1,
                            width = 0.8,
                        },
                        scaleFactor = {
                            order = 4,
                            name = "scale",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0.1,
                            softMax = 3,
                            step = 0.1,
                            width = 0.8,
                        },
                    },
                },
                RangeAlpha = {
                    hidden = Range_disabled,
                    order = 2,
                    name = "Range Alpha",
                    type = "group",
                    inline = true,
                    args = {
                        statusbar = {
                            order = 1,
                            name = "Foreground",
                            desc = "the foreground alpha level when a target is out of range",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0,
                            max = 1,
                            step = 0.01,
                            width = 1.2,
                            isPercent = true,
                        },
                        background = {
                            order = 2,
                            name = "Background",
                            desc = "the background alpha level when a target is out of range",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0,
                            max = 1,
                            step = 0.01,
                            width = 1.2,
                            isPercent = true,
                        },
                    },
                },
                CustomScale = {
                    hidden = isClassic or CustomScale_disabled,
                    order = 6,
                    name = "Custom Scale",
                    type = "group",
                    inline = true,
                    args = {
                        Party = {
                            order = 1,
                            name = "Party",
                            desc = "",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0.5,
                            max = 3,
                            step = 0.1,
                            width = 1.2,
                            isPercent = true,
                        },
                        Arena = {
                            order = 2,
                            name = "Arena",
                            desc = "",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0.5,
                            max = 3,
                            step = 0.1,
                            width = 1.2,
                            isPercent = true,
                        },
                        Raid = {
                            order = 3,
                            name = "Raid",
                            desc = "",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0.5,
                            max = 3,
                            step = 0.1,
                            width = 1.2,
                            isPercent = true,
                        },
                    },
                },
                Overabsorb = {
                    hidden = isClassic or Overabsorb_disabled,
                    order = 7,
                    name = "Overabsorb",
                    type = "group",
                    inline = true,
                    args = {
                        glowAlpha = {
                            order = 1,
                            name = "Glow intensity",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 0,
                            max = 1,
                            step = 0.1,
                            isPercent = true,
                        },
                    },
                },
            },
        },
        PorfileManagement = {
            order = lastEntry,
            name = "Profiles",
            type = "group",
            childGroups = "tab",
            args = {
                --order 1 is the ace profile tab
                GroupProfiles = {
                    order = 2,
                    name = "Raid/Party Profile",
                    type = "group",
                    inline = true,
                    args = {
                        party = {
                            order = 1,
                            name = "Party",
                            type = "select",
                            values = profiles,
                            get = function() 
                                for i,value in pairs(profiles) do
                                    if value == RaidFrameSettings.db.global.GroupProfiles.party then
                                        return i
                                    end
                                end
                            end,
                            set = function(info,value) 
                                RaidFrameSettings.db.global.GroupProfiles.party = profiles[value]
                                RaidFrameSettings:LoadGroupBasedProfile()
                            end,
                        },
                        raid = {
                            order = 2,
                            name = "Raid",
                            type = "select",
                            values = profiles,
                            get = function() 
                                for i,value in pairs(profiles) do
                                    if value == RaidFrameSettings.db.global.GroupProfiles.raid then
                                        return i
                                    end
                                end
                            end,
                            set = function(info,value) 
                                RaidFrameSettings.db.global.GroupProfiles.raid = profiles[value]
                                RaidFrameSettings:LoadGroupBasedProfile()
                            end,
                        },
                        arena = {
                            order = 3,
                            name = "Arena",
                            type = "select",
                            values = profiles,
                            get = function() 
                                for i,value in pairs(profiles) do
                                    if value == RaidFrameSettings.db.global.GroupProfiles.arena then
                                        return i
                                    end
                                end
                            end,
                            set = function(info,value) 
                                RaidFrameSettings.db.global.GroupProfiles.arena = profiles[value]
                                RaidFrameSettings:LoadGroupBasedProfile()
                            end,
                        },
                        battleground = {
                            order = 4,
                            name = "Battleground",
                            type = "select",
                            values = profiles,
                            get = function() 
                                for i,value in pairs(profiles) do
                                    if value == RaidFrameSettings.db.global.GroupProfiles.battleground then
                                        return i
                                    end
                                end
                            end,
                            set = function(info,value) 
                                RaidFrameSettings.db.global.GroupProfiles.battleground = profiles[value]
                                RaidFrameSettings:LoadGroupBasedProfile()
                            end,
                        },
                        description = {
                            order = 5,
                            name = "The profiles you select above will be loaded based on the type of group you are in, if you want to use the same profile for all cases select it for all cases.",
                            fontSize = "medium",
                            type = "description",
                        },
                    },
                },
                ImportExportPofile = {
                    order = 3,
                    name = "Import/Export Profile",
                    type = "group",
                    args = {
                        Header = {
                            order = 1,
                            name = "Share your profile or import one",
                            type = "header",
                        },
                        Desc = {
                            order = 2,
                            name = "To export your current profile copy the code below.\nTo import a profile replace the code below and press Accept",
                            fontSize = "medium",
                            type = "description",
                        },
                        Textfield = {
                            order = 3,
                            name = "import/export from or to your current profile",
                            desc = "|cffFF0000Caution|r: Importing a profile will overwrite your current profile.",
                            type = "input",
                            multiline = 18,
                            width = "full",
                            confirm = function() return "Caution: Importing a profile will overwrite your current profile." end,
                            get = function() return RaidFrameSettings:ShareProfile() end,
                            set = function(self, input) RaidFrameSettings:ImportProfile(input); ReloadUI() end, 
                        },
                    },
                },
            },
        },
    },
}


function RaidFrameSettings:GetProfiles()
    RaidFrameSettings.db:GetProfiles(profiles)
end


function RaidFrameSettings:GetOptionsTable()
    return options
end

function RaidFrameSettings:CreateBlacklistEntry(spellId, pos)
    local dbObj = self.db.profile.Blacklist
    local optionsPos = options.args.Blacklist.args.auraList.args
    local spellName, _, icon 
    --TODO crate function that returns relevant information to not do it in every entry function
    if  #spellId <= 10 then --passing more than 10 characters to GetSpellInfo cause an stackoverflow
        spellName, _, icon = GetSpellInfo(spellId)
    end
    local blacklist_entry = {
        order = pos or 1,
        name = "",
        type = "group",
        inline = true,
        args = {
            auraInfo = {
                order = 1,
                image = icon,
                imageCoords = {0.1,0.9,0.1,0.9},
                name = (spellName or "|cffff0000aura not found|r") .. " (" .. spellId .. ")",
                type = "description",
                width = 1.5,
            },
            remove = {
                order = 2,
                name = "remove",
                type = "execute",
                func = function()
                    self.db.profile.Blacklist[spellId] = nil
                    optionsPos[spellId] = nil
                    RaidFrameSettings:UpdateModule("Blacklist")
                end,
                width = 0.5,
            },  
        },
    }
    optionsPos[spellId] = blacklist_entry
end

function RaidFrameSettings:CreateWatchlistEntry(spellId, pos)
    local dbObj = self.db.profile.Watchlist
    local optionsPos = options.args.Watchlist.args.auraList.args
    local spellName, _, icon 
    if  #spellId <= 10 then --passing more than 10 characters to GetSpellInfo cause an stackoverflow
        spellName, _, icon = GetSpellInfo(spellId)
    end
    local spellIdColorCode = dbObj[spellId].spellIsDebuff and "cffFF474D" or "cff00ff00"
    local auraName = spellName or "|cffff0000aura not found|r"
    local Watchlist_entry = {
        order = pos or 1,
        name = "",
        type = "group",
        inline = true,
        args = {
            auraInfo = {
                order = 1,
                image = icon,
                imageWidth = 25,
                imageHeight = 25,
                imageCoords = {0.1,0.9,0.1,0.9},
                name = auraName .. " (|" .. spellIdColorCode .. spellId .. "|r)",
                type = "description",
                width = 1.5,
            },
            ownOnly = {
                order = 2,
                type = "toggle",
                name = "Mine only",
                desc = "Only display " .. auraName ..  " if the player (you) is the source unit.",
                get = function()
                    return dbObj[spellId].ownOnly 
                end,
                set = function(_, value)
                    dbObj[spellId].ownOnly = value
                    RaidFrameSettings:UpdateModule("Watchlist")
                end,
            },
            glow = {
                order = 3,
                type = "toggle",
                name = "Glow",
                desc = "Glow the icon while " .. auraName ..  " is applied.",
                get = function()
                    return dbObj[spellId].glow 
                end,
                set = function(_, value)
                    dbObj[spellId].glow = value
                    RaidFrameSettings:UpdateModule("Watchlist")
                end,
            },
            remove = {
                order = 5,
                name = "remove",
                desc = "Remove " .. auraName .. " from the watchlist.", 
                type = "execute",
                func = function()
                    self.db.profile.Watchlist[spellId] = nil
                    optionsPos[spellId] = nil
                    RaidFrameSettings:UpdateModule("Watchlist")
                end,
                width = 0.5,
            },  
        },
    }
    optionsPos[spellId] = Watchlist_entry
end

function RaidFrameSettings:CreateIncreaseEntry(spellId)
    local dbObj = self.db.profile.Debuffs.Increase
    local optionsPos = options.args.Auras.args.Debuffs.args.Increase.args.IncreasedAuras.args
    local spellName, _, icon 
    if  #spellId <= 10 then --passing more than 10 characters to GetSpellInfo cause an stackoverflow
        spellName, _, icon = GetSpellInfo(spellId)
    end
    local increase_entry = {
        order = 1,
        name = "",
        type = "group",
        inline = true,
        args = {
            auraInfo = {
                order = 1,
                image = icon,
                imageCoords = {0.1,0.9,0.1,0.9},
                name = (spellName or "|cffff0000aura not found|r") .. " (" .. spellId .. ")",
                type = "description",
                width = 1.5,
            },
            remove = {
                order = 2,
                name = "remove",
                type = "execute",
                func = function()
                    self.db.profile.Debuffs.Increase[spellId] = nil
                    optionsPos[spellId] = nil
                    RaidFrameSettings:UpdateModule("Debuffs")
                end,
                width = 0.5,
            },  
        },
    }
    optionsPos[spellId] = increase_entry
end


function RaidFrameSettings:CreateAuraPositionEntry(spellId, category)
    local dbObj = self.db.profile[category].AuraPosition[spellId]
    local optionsPos = options.args.Auras.args[category].args.AuraPosition.args.auraList.args
    local spellName, _, icon 
    if  #spellId <= 10 then --passing more than 10 characters to GetSpellInfo cause an stackoverflow
        spellName, _, icon = GetSpellInfo(spellId)
    end
    local aura_entry = {
        order = 1,
        name = "|cffFFFFFF" .. (spellName or "|cffff0000aura not found|r") .. " (" .. spellId .. ") |r",
        type = "group",
        inline = true,
        args = {
            auraInfo = {
                order = 1,
                name = "",
                image = icon,
                imageCoords = {0.1,0.9,0.1,0.9},
                imageWidth = 28,
                imageHeight = 28,
                type = "description",
                width = 0.5,
            },
            point = {
                order = 3,
                name = "anchor",
                type = "select",
                values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
                sorting = {1,2,3,4,5,6,7,8,9},
                get = function()
                    return dbObj.point
                end,
                set = function(_, value)
                    dbObj.point = value
                    RaidFrameSettings:UpdateModule(category)
                end,
                width = 0.6,
            },
            relativePoint = {
                order = 4,
                name = "to Frames",
                type = "select",
                values = {"Top Left", "Top", "Top Right", "Left", "Center", "Right", "Bottom Left", "Bottom", "Bottom Right"},
                sorting = {1,2,3,4,5,6,7,8,9},
                get = function()
                    return dbObj.relativePoint
                end,
                set = function(_, value)
                    dbObj.relativePoint = value
                    RaidFrameSettings:UpdateModule(category)
                end,
                width = 0.6,
            },
            xOffset = {
                order = 5,
                name = "x - offset",
                type = "range",
                get = function()
                    return dbObj.xOffset
                end,
                set = function(_, value)
                    dbObj.xOffset = value
                    RaidFrameSettings:UpdateModule(category)
                end,
                softMin = -100,
                softMax = 100,
                step = 1,
                width = 0.8,
            },
            yOffset = {
                order = 6,
                name = "y - offset",
                type = "range",
                get = function()
                    return dbObj.yOffset
                end,
                set = function(_, value)
                    dbObj.yOffset = value
                    RaidFrameSettings:UpdateModule(category)
                end,
                softMin = -100,
                softMax = 100,
                step = 1,
                width = 0.8,
            },
            scale = {
                order = 7,
                name = "scale",
                type = "range",
                get = function()
                    return dbObj.scale
                end,
                set = function(_, value)
                    dbObj.scale = value
                    RaidFrameSettings:UpdateModule(category)
                end,
                min = 0.1,
                max = 3,
                isPercent = true,
                step = 0.1,
                width = 0.8,
            },
            remove = {
                order = 8,
                name = "remove",
                type = "execute",
                func = function()
                    self.db.profile[category].AuraPosition[spellId] = nil
                    optionsPos[spellId] = nil
                    RaidFrameSettings:UpdateModule(category)
                end,
                width = 0.5,
            },
        },
    }
    optionsPos[spellId] = aura_entry
end

function RaidFrameSettings:LoadUserInputEntrys()
    --blacklists
    --import old blacklist
    --TODO remove after a few updates
    if not self.db.profile.oldBlacklistsImported then
        for _, category in pairs({
            "Buffs",
            "Debuffs",
        }) do
            for spellId in pairs(self.db.profile[category].Blacklist) do
                self.db.profile.Blacklist[spellId] = true
            end
        end
        self.db.profile.oldBlacklistsImported = true
    end
    options.args.Blacklist.args.auraList.args = {} --dump to not have entrys left on profile swap or reset
    for spellId in pairs(self.db.profile.Blacklist) do
        self:CreateBlacklistEntry(spellId)
    end
    --watchlist
    options.args.Watchlist.args.auraList.args = {}
    for spellId, _ in pairs(self.db.profile.Watchlist) do
        self:CreateWatchlistEntry(spellId)
    end
    --aura increase
    options.args.Auras.args.Debuffs.args.Increase.args.IncreasedAuras.args = {}
    for spellId in pairs(self.db.profile.Debuffs.Increase) do
        self:CreateIncreaseEntry(spellId)
    end
    --aura positions
    for _, category in pairs({
        "Buffs",
        "Debuffs",
    }) do
        options.args.Auras.args[category].args.AuraPosition.args.auraList.args = {}
        for aura in pairs(self.db.profile[category].AuraPosition) do 
            self:CreateAuraPositionEntry(aura, category)
        end
    end
end