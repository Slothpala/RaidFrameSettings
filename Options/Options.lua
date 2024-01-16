--[[
    Created by Slothpala 
    Options:
    Create an options table for the GUI
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

--LibDDI-1.0
local statusbars =  LibStub("LibSharedMedia-3.0"):List("statusbar")

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
                            desc = "Choose colors and textures for Health Bars.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Fonts = {
                            order = 2,
                            type = "toggle",
                            name = "Fonts",
                            desc = "Adjust the Font, Font Size, Font Color as well as the position for the Names and Status Texts.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        RoleIcon = {
                            hidden = isVanilla,
                            order = 3,
                            type = "toggle",
                            name = "Role Icon",
                            desc = "Position the Role Icon.\n|cffF4A460CPU Impact: |r|cff90EE90VERY LOW|r",
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
                            hidden = not isRetail,
                            order = 5,
                            type = "toggle",
                            name = "Buffs",
                            desc = "Adjust the position, orientation and size of buffs.\n|cffF4A460CPU Impact: |r|cff90EE90VERY LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Debuffs = {
                            hidden = not isRetail,
                            order = 6,
                            type = "toggle",
                            name = "Debuffs",
                            desc = "Adjust the position, orientation and size of debuffs.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
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
                            desc = "Recolor unit health bars based on debuff type.\n|cffF4A460CPU Impact: |r|cffFFFF00MEDIUM|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        CustomScale = {
                            hidden = not isRetail,
                            order = 9,
                            type = "toggle",
                            name = "Custom Scale",
                            desc = "Set a scaling factor for raid and party frames.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                    },
                },
                DescriptionBox = {
                    order = 2,
                    name = "Hint",
                    type = "group",
                    inline = true,
                    args = {
                        description = {
                            order = 1,
                            name = "The default UI links the name text to the right of the role icon, so in some cases you will need to use both modules if you want to use either one.",
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
        Auras = {
            order = 4,
            name = "Auras",
            type = "group",
            childGroups = "tab",
            hidden = function()
                if not isRetail then
                    return false
                end
                if not RaidFrameSettings.db.profile.Module.Buffs and not RaidFrameSettings.db.profile.Module.Debuffs then
                    return true
                end
                return false
            end,
            args = {
                Buffs = {
                    hidden = Buffs_disabled,
                    order = 1,
                    name = "Buffs",
                    type = "group",
                    childGroups = "tab",
                    args = {
                        Display = {
                            order = 1,
                            name = "Display",
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
                                clean_icons = {
                                    order = 2.1,
                                    type = "toggle",
                                    name = "use clean icons",
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
                                    values = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},
                                    sorting = {1,2,3,4},
                                    get = "GetStatus",
                                    set = "SetStatus",
                                },
                                relativePoint = {
                                    order = 5,
                                    name = "to Frames",
                                    type = "select",
                                    values = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},
                                    sorting = {1,2,3,4},
                                    get = "GetStatus",
                                    set = "SetStatus",
                                },
                                orientation = {
                                    order = 6,
                                    name = "direction of growth",
                                    type = "select",
                                    values = {"LEFT", "RIGHT", "UP", "DOWN"},
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
                                x_offset = {
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
                                y_offset = {
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
                                newline3 = {
                                    order = 10,
                                    name = "",
                                    type = "description",
                                },
                                maxbuffs = {
                                    order = 11,
                                    name = "Max buffes",
                                    type = "range",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    min = 3,
                                    softMax = 10,
                                    step = 1,
                                    width = 1.4,
                                },
                                framestrata = {
                                    order = 12,
                                    name = "Frame Strata",
                                    type = "select",
                                    values = { "Inherited", "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP" },
                                    sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                                    get = "GetStatus",
                                    set = "SetStatus",
                                },
                                newline4 = {
                                    order = 13,
                                    name = "",
                                    type = "description",
                                },

                                edge = {
                                    order = 14,
                                    name = "Edge",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 0.5,
                                },
                                swipe = {
                                    order = 15,
                                    name = "Swipe",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 0.5,
                                },
                                reverse = {
                                    order = 16,
                                    name = "Reverse",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 0.5,
                                },
                                showCdnum = {
                                    order = 17,
                                    name = "Show Cooldown Numbers",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 1.2,
                                },

                                Duration = {
                                    order = 18,
                                    name = "Duration",
                                    type = "group",
                                    inline = true,
                                    disabled = function() return not RaidFrameSettings.db.profile.Buffs.Display.showCdnum end,
                                    args = {
                                        font = {
                                            order = 2,
                                            type = "select",
                                            dialogControl = "LSM30_Font",
                                            name = "Font",
                                            values = Media:HashTable("font"),
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        outline = {
                                            order = 3,
                                            name = "OUTLINE",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.5,
                                        },
                                        thick = {
                                            disabled = function() return not RaidFrameSettings.db.profile.Buffs.Display.showCdnum or not RaidFrameSettings.db.profile.Buffs.Display.Duration.outline end,
                                            order = 3.1,
                                            name = "THICK",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.4,
                                        },
                                        monochrome = {
                                            order = 3.2,
                                            name = "MONOCHROME",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
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
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            min = 1,
                                            max = 40,
                                            step = 1,
                                        },
                                        fontcolor = {
                                            order = 6,
                                            type = "color",
                                            name = "Duration color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            width = 0.8,
                                        },
                                        newline2 = {
                                            order = 6.1,
                                            type = "description",
                                            name = "",
                                        },
                                        shadowColor = {
                                            order = 6.2,
                                            type = "color",
                                            name = "Shadow color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            hasAlpha = true,
                                            width = 0.8,
                                        },
                                        shadow_x_offset = {
                                            order = 6.3,
                                            name = "Shadow x-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        shadow_y_offset = {
                                            order = 6.4,
                                            name = "Shadow y-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        newline2_1 = {
                                            order = 6.5,
                                            type = "description",
                                            name = "",
                                        },
                                        position = {
                                            order = 7,
                                            name = "Position",
                                            type = "select",
                                            values = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" },
                                            sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        x_offset = {
                                            order = 8,
                                            name = "x - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        y_offset = {
                                            order = 9,
                                            name = "y - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        newline3 = {
                                            order = 10,
                                            type = "description",
                                            name = "",
                                        },
                                        justifyH = {
                                            order = 11,
                                            name = "Horizontal alignment",
                                            type = "select",
                                            values = { "LEFT", "CENTER", "RIGHT" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        justifyV = {
                                            order = 12,
                                            name = "Vertical alignment",
                                            type = "select",
                                            values = { "TOP", "MIDDLE", "BOTTOM" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                    },
                                },
                                Stacks = {
                                    order = 19,
                                    name = "Stacks",
                                    type = "group",
                                    inline = true,
                                    args = {
                                        font = {
                                            order = 2,
                                            type = "select",
                                            dialogControl = "LSM30_Font",
                                            name = "Font",
                                            values = Media:HashTable("font"),
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        outline = {
                                            order = 3,
                                            name = "OUTLINE",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.5,
                                        },
                                        thick = {
                                            disabled = function() return not RaidFrameSettings.db.profile.Buffs.Display.Stacks.outline end,
                                            order = 3.1,
                                            name = "THICK",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.4,
                                        },
                                        monochrome = {
                                            order = 3.2,
                                            name = "MONOCHROME",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
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
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            min = 1,
                                            max = 40,
                                            step = 1,
                                        },
                                        fontcolor = {
                                            order = 6,
                                            type = "color",
                                            name = "Stack color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            width = 0.8,
                                        },
                                        newline2 = {
                                            order = 6.1,
                                            type = "description",
                                            name = "",
                                        },
                                        shadowColor = {
                                            order = 6.2,
                                            type = "color",
                                            name = "Shadow color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            hasAlpha = true,
                                            width = 0.8,
                                        },
                                        shadow_x_offset = {
                                            order = 6.3,
                                            name = "Shadow x-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        shadow_y_offset = {
                                            order = 6.4,
                                            name = "Shadow y-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        newline2_1 = {
                                            order = 6.5,
                                            type = "description",
                                            name = "",
                                        },
                                        position = {
                                            order = 7,
                                            name = "Position",
                                            type = "select",
                                            values = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" },
                                            sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        x_offset = {
                                            order = 8,
                                            name = "x - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        y_offset = {
                                            order = 9,
                                            name = "y - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        newline3 = {
                                            order = 10,
                                            type = "description",
                                            name = "",
                                        },
                                        justifyH = {
                                            order = 11,
                                            name = "Horizontal alignment",
                                            type = "select",
                                            values = { "LEFT", "CENTER", "RIGHT" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        justifyV = {
                                            order = 12,
                                            name = "Vertical alignment",
                                            type = "select",
                                            values = { "TOP", "MIDDLE", "BOTTOM" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                    },
                                },
                            },
                        },
                        Blacklist = {
                            order = 2,
                            name = "Blacklist",
                            type = "group",
                            args = {
                                add = {
                                    order = 1,
                                    name = "add aura by spellid to blacklist",
                                    desc = "",
                                    type = "input",
                                    width = 1.5,
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(info,spellID)
                                        local name = #spellID <= 10 and select(1,GetSpellInfo(spellID)) or "|cffff0000aura not found|r" 
                                        RaidFrameSettings.db.profile.Buffs.Blacklist[spellID] = name
                                        RaidFrameSettings:CreateBlacklistEntry("Buffs", name, spellID)
                                        RaidFrameSettings:Print(spellID.."("..name..") added to blacklist")
                                        RaidFrameSettings:ReloadConfig()
                                    end,
                                },
                                remove = {
                                    order = 2,
                                    name = "remove aura from blacklist",
                                    desc = "",
                                    type = "input",
                                    width = 1.5,
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(info,spellID)
                                        local name = RaidFrameSettings.db.profile.Buffs.Blacklist[spellID]
                                        if name then
                                            RaidFrameSettings.db.profile.Buffs.Blacklist[spellID] = nil
                                            RaidFrameSettings:RemoveBlacklistEntry("Buffs", name, spellID)
                                            RaidFrameSettings:Print(spellID.."("..name..") removed from blacklist")
                                        end
                                        RaidFrameSettings:ReloadConfig()
                                    end,
                                },
                                BlacklistedAuras = {
                                    order = 4,
                                    name = "Blacklisted Buffs",
                                    type = "group",
                                    inline = true,
                                    args = {
                                        --will be created based on blacklist entries in the db by LoadUserInputEntrys
                                    },
                                },                           
                            },
                        },
                        Position = {
                            order = 3,
                            name = "Position",
                            type = "group",
                            args = {
                                add = {
                                    order = 1,
                                    name = "add aura by spellid to positioned list",
                                    type = "input",
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(_, new_spellID)
                                        local position = {
                                            name     = "",
                                            point    = 1,
                                            x        = 0,
                                            y        = 0,
                                            x_offset = 0,
                                            y_offset = 0,
                                        }
                                        position.name = #new_spellID <= 10 and select(1, GetSpellInfo(new_spellID)) or "|cffff0000aura not found|r"
                                        RaidFrameSettings.db.profile.Buffs.Position[new_spellID] = position
                                        RaidFrameSettings:CreatePositionEntry(new_spellID, position)
                                        RaidFrameSettings:ReloadConfig()
                                    end,
                                    width = 1.5,
                                },
                                PositionedAuras = {
                                    order = 2,
                                    name = "Positioned Buffs",
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
                        Display = {
                            order = 1,
                            name = "Display",
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
                                    name = "boss aura increase",
                                    type = "range",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    min = 1,
                                    max = 2,
                                    step = 0.1,
                                    width = 0.8,
                                    isPercent = true,
                                },
                                clean_icons = {
                                    order = 2.2,
                                    type = "toggle",
                                    name = "use clean icons",
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
                                    name = "Debuffframe anchor",
                                    type = "select",
                                    values = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},
                                    sorting = {1,2,3,4},
                                    get = "GetStatus",
                                    set = "SetStatus",
                                },
                                relativePoint = {
                                    order = 5,
                                    name = "to Frames",
                                    type = "select",
                                    values = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},
                                    sorting = {1,2,3,4},
                                    get = "GetStatus",
                                    set = "SetStatus",
                                },
                                orientation = {
                                    order = 6,
                                    name = "direction of growth",
                                    type = "select",
                                    values = {"LEFT", "RIGHT", "UP", "DOWN"},
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
                                x_offset = {
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
                                y_offset = {
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
                                newline3 = {
                                    order = 10,
                                    name = "",
                                    type = "description",
                                },
                                maxdebuffs = {
                                    order = 11,
                                    name = "Max Debuffes",
                                    type = "range",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    min = 3,
                                    softMax = 10,
                                    step = 1,
                                    width = 1.4,
                                },
                                framestrata = {
                                    order = 12,
                                    name = "Frame Strata",
                                    type = "select",
                                    values = { "Inherited", "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP" },
                                    sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                                    get = "GetStatus",
                                    set = "SetStatus",
                                },
                                newline4 = {
                                    order = 13,
                                    name = "",
                                    type = "description",
                                },

                                edge = {
                                    order = 14,
                                    name = "Edge",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 0.5,
                                },
                                swipe = {
                                    order = 15,
                                    name = "Swipe",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 0.5,
                                },
                                reverse = {
                                    order = 16,
                                    name = "Reverse",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 0.5,
                                },
                                showCdnum = {
                                    order = 17,
                                    name = "Show Cooldown Numbers",
                                    type = "toggle",
                                    get = "GetStatus",
                                    set = "SetStatus",
                                    width = 1.2,
                                },

                                Duration = {
                                    order = 18,
                                    name = "Duration",
                                    type = "group",
                                    inline = true,
                                    disabled = function() return not RaidFrameSettings.db.profile.Debuffs.Display.showCdnum end,
                                    args = {
                                        font = {
                                            order = 2,
                                            type = "select",
                                            dialogControl = "LSM30_Font",
                                            name = "Font",
                                            values = Media:HashTable("font"),
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        outline = {
                                            order = 3,
                                            name = "OUTLINE",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.5,
                                        },
                                        thick = {
                                            disabled = function() return not RaidFrameSettings.db.profile.Debuffs.Display.showCdnum or not RaidFrameSettings.db.profile.Buffs.Display.Duration.outline end,
                                            order = 3.1,
                                            name = "THICK",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.4,
                                        },
                                        monochrome = {
                                            order = 3.2,
                                            name = "MONOCHROME",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
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
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            min = 1,
                                            max = 40,
                                            step = 1,
                                        },
                                        usedebuffcolor = {
                                            order = 5,
                                            name = "Debuff Colored",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.8,
                                        },
                                        fontcolor = {
                                            order = 6,
                                            type = "color",
                                            name = "Duration color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            width = 0.8,
                                        },
                                        newline2 = {
                                            order = 6.1,
                                            type = "description",
                                            name = "",
                                        },
                                        shadowColor = {
                                            order = 6.2,
                                            type = "color",
                                            name = "Shadow color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            hasAlpha = true,
                                            width = 0.8,
                                        },
                                        shadow_x_offset = {
                                            order = 6.3,
                                            name = "Shadow x-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        shadow_y_offset = {
                                            order = 6.4,
                                            name = "Shadow y-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        newline2_1 = {
                                            order = 6.5,
                                            type = "description",
                                            name = "",
                                        },
                                        position = {
                                            order = 7,
                                            name = "Position",
                                            type = "select",
                                            values = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" },
                                            sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        x_offset = {
                                            order = 8,
                                            name = "x - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        y_offset = {
                                            order = 9,
                                            name = "y - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        newline3 = {
                                            order = 10,
                                            type = "description",
                                            name = "",
                                        },
                                        justifyH = {
                                            order = 11,
                                            name = "Horizontal alignment",
                                            type = "select",
                                            values = { "LEFT", "CENTER", "RIGHT" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        justifyV = {
                                            order = 12,
                                            name = "Vertical alignment",
                                            type = "select",
                                            values = { "TOP", "MIDDLE", "BOTTOM" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                    },
                                },
                                Stacks = {
                                    order = 19,
                                    name = "Stacks",
                                    type = "group",
                                    inline = true,
                                    args = {
                                        font = {
                                            order = 2,
                                            type = "select",
                                            dialogControl = "LSM30_Font",
                                            name = "Font",
                                            values = Media:HashTable("font"),
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        outline = {
                                            order = 3,
                                            name = "OUTLINE",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.5,
                                        },
                                        thick = {
                                            disabled = function() return not RaidFrameSettings.db.profile.Debuffs.Display.Stacks.outline end,
                                            order = 3.1,
                                            name = "THICK",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.4,
                                        },
                                        monochrome = {
                                            order = 3.2,
                                            name = "MONOCHROME",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
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
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            min = 1,
                                            max = 40,
                                            step = 1,
                                        },
                                        usedebuffcolor = {
                                            order = 5,
                                            name = "Debuff Colored",
                                            type = "toggle",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            width = 0.8,
                                        },
                                        fontcolor = {
                                            order = 6,
                                            type = "color",
                                            name = "Stack color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            width = 0.8,
                                        },
                                        newline2 = {
                                            order = 6.1,
                                            type = "description",
                                            name = "",
                                        },
                                        shadowColor = {
                                            order = 6.2,
                                            type = "color",
                                            name = "Shadow color",
                                            get = "GetColor2",
                                            set = "SetColor2",
                                            hasAlpha = true,
                                            width = 0.8,
                                        },
                                        shadow_x_offset = {
                                            order = 6.3,
                                            name = "Shadow x-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        shadow_y_offset = {
                                            order = 6.4,
                                            name = "Shadow y-offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -4,
                                            softMax = 4,
                                            step = 0.1,
                                            width = 0.8,
                                        },
                                        newline2_1 = {
                                            order = 6.5,
                                            type = "description",
                                            name = "",
                                        },
                                        position = {
                                            order = 7,
                                            name = "Position",
                                            type = "select",
                                            values = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" },
                                            sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        x_offset = {
                                            order = 8,
                                            name = "x - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        y_offset = {
                                            order = 9,
                                            name = "y - offset",
                                            type = "range",
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                            softMin = -25,
                                            softMax = 25,
                                            step = 1,
                                            width = 0.8,
                                        },
                                        newline3 = {
                                            order = 10,
                                            type = "description",
                                            name = "",
                                        },
                                        justifyH = {
                                            order = 11,
                                            name = "Horizontal alignment",
                                            type = "select",
                                            values = { "LEFT", "CENTER", "RIGHT" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                        justifyV = {
                                            order = 12,
                                            name = "Vertical alignment",
                                            type = "select",
                                            values = { "TOP", "MIDDLE", "BOTTOM" },
                                            sorting = { 1, 2, 3 },
                                            get = "GetStatus2",
                                            set = "SetStatus2",
                                        },
                                    },
                                },
                            },
                        },
                        Blacklist = {
                            order = 2,
                            name = "Blacklist",
                            type = "group",
                            args = {
                                add = {
                                    order = 1,
                                    name = "add aura by spellid to blacklist",
                                    desc = "",
                                    type = "input",
                                    width = 1.5,
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(info,spellID)
                                        local name = #spellID <= 10 and select(1,GetSpellInfo(spellID)) or "|cffff0000aura not found|r" 
                                        RaidFrameSettings.db.profile.Debuffs.Blacklist[spellID] = name
                                        RaidFrameSettings:CreateBlacklistEntry("Debuffs", name, spellID)
                                        RaidFrameSettings:Print(spellID.."("..name..") added to blacklist")
                                        RaidFrameSettings:ReloadConfig()
                                    end,
                                },
                                remove = {
                                    order = 2,
                                    name = "remove aura from blacklist",
                                    desc = "",
                                    type = "input",
                                    width = 1.5,
                                    pattern = "^%d+$",
                                    usage = "please enter a number",
                                    set = function(info,spellID)
                                        local name = RaidFrameSettings.db.profile.Debuffs.Blacklist[spellID]
                                        if name then
                                            RaidFrameSettings.db.profile.Debuffs.Blacklist[spellID] = nil
                                            RaidFrameSettings:RemoveBlacklistEntry("Debuffs", name, spellID)
                                            RaidFrameSettings:Print(spellID.."("..name..") removed from blacklist")
                                        end
                                        RaidFrameSettings:ReloadConfig()
                                    end,
                                },
                                BlacklistedAuras = {
                                    order = 4,
                                    name = "Blacklisted Debuffs",
                                    type = "group",
                                    inline = true,
                                    args = {
                                        --will be created based on blacklist entries in the db by LoadUserInputEntrys
                                    },
                                },                           
                            },
                        },
                    },  
                },
            },
        },
        AuraHighlight = {
            order = 5,
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
            order = 5,
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
                        description = {
                            order = 3,
                            name = "The profiles you select above will load based on the type of group you are in (raid or party), if you want to use the same profile for all cases select it for both raid and party.",
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

function RaidFrameSettings:CreateBlacklistEntry(catergory, name, spellID)
    local newEntry = {
        type = "input",
        name = name,
        get = function() return spellID end,
        set = function() end,
        dialogControl = "SFX-Info-URL",
        width = full,
    }
    options.args.Auras.args[catergory].args.Blacklist.args.BlacklistedAuras.args[name..spellID] = newEntry
end

function RaidFrameSettings:RemoveBlacklistEntry(catergory, name, spellID)
    options.args.Auras.args[catergory].args.Blacklist.args.BlacklistedAuras.args[name..spellID] = nil
end

function RaidFrameSettings:CreatePositionEntry(spellID, pos)
    local newEntry = {
        type = "group",
        name = "",
        args = {
            spell = {
                order = 1,
                name = pos.name,
                type = "input",
                get = function() return spellID end,
                set = function(_, new_spellID)
                    if new_spellID == spellID then
                        return
                    end

                    RaidFrameSettings.db.profile.Buffs.Position[spellID] = nil
                    RaidFrameSettings:RemovePositionEntry(spellID)

                    pos.name = #new_spellID <= 10 and select(1, GetSpellInfo(new_spellID)) or "|cffff0000aura not found|r"
                    RaidFrameSettings.db.profile.Buffs.Position[new_spellID] = pos
                    RaidFrameSettings:CreatePositionEntry(new_spellID, pos)

                    RaidFrameSettings:ReloadConfig()
                end,
                width = 0.8,
            },
            point = {
                order = 2,
                name = "Point",
                type = "select",
                values = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" },
                sorting = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
                get = function() return pos.point end,
                set = function(_, point)
                    pos.point = point
                    RaidFrameSettings:ReloadConfig()
                end,
                width = 0.8,
            },
            x = {
                order = 3,
                name = "X",
                type = "input",
                pattern = "^[%d.]+$",
                usage = "please enter a number",
                get = function() return tostring(pos.x) end,
                set = function(_, x)
                    pos.x = tonumber(x)
                    RaidFrameSettings:ReloadConfig()
                end,
                width = 0.4,
            },
            y = {
                order = 4,
                name = "Y",
                type = "input",
                pattern = "^[%d.]+$",
                usage = "please enter a number",
                get = function() return tostring(pos.y) end,
                set = function(_, y)
                    pos.y = tonumber(y)
                    RaidFrameSettings:ReloadConfig()
                end,
                width = 0.4,
            },
            x_offset = {
                order = 5,
                name = "X Offset",
                type = "range",
                softMin = -100,
                softMax = 100,
                step = 1,
                get = function() return pos.x_offset end,
                set = function(_, x_offset)
                    pos.x_offset = x_offset
                    RaidFrameSettings:ReloadConfig()
                end,
                width = 0.8,
            },
            y_offset = {
                order = 6,
                name = "Y Offset",
                type = "range",
                softMin = -100,
                softMax = 100,
                step = 1,
                get = function() return pos.y_offset end,
                set = function(_, y_offset)
                    pos.y_offset = y_offset
                    RaidFrameSettings:ReloadConfig()
                end,
                width = 0.8,
            },
            remove = {
                order = 7,
                name = "Remove",
                desc = "",
                type = "execute",
                width = 0.5,
                func = function()
                    RaidFrameSettings.db.profile.Buffs.Position[spellID] = nil
                    RaidFrameSettings:RemovePositionEntry(spellID)
                    RaidFrameSettings:ReloadConfig()
                end,
            },
        },
        width = "full",
    }
    options.args.Auras.args.Buffs.args.Position.args.PositionedAuras.args[spellID] = newEntry
end

function RaidFrameSettings:RemovePositionEntry(spellID)
    options.args.Auras.args.Buffs.args.Position.args.PositionedAuras.args[spellID] = nil
end

function RaidFrameSettings:LoadUserInputEntrys()
    --debuff blacklist
    local blacklist = RaidFrameSettings.db.profile.Debuffs.Blacklist
    for spellID,name in pairs(blacklist) do
        local type = type(name)
        if type ~= "string" then
            local spellName = #spellID <= 10 and select(1,GetSpellInfo(spellID)) or "|cffff0000aura not found|r" 
            RaidFrameSettings.db.profile.Debuffs.Blacklist[spellID] = spellName
            RaidFrameSettings:CreateBlacklistEntry("Debuffs", spellName, spellID)
            return
        end
        RaidFrameSettings:CreateBlacklistEntry("Debuffs", name, spellID)       
    end
    --buff blacklist
    blacklist = RaidFrameSettings.db.profile.Buffs.Blacklist
    for spellID,name in pairs(blacklist) do
        RaidFrameSettings:CreateBlacklistEntry("Buffs", name, spellID)       
    end

    --buff position list
    local positionlist = RaidFrameSettings.db.profile.Buffs.Position
    for spellID, pos in pairs(positionlist) do
        RaidFrameSettings:CreatePositionEntry(spellID, pos)
    end
end