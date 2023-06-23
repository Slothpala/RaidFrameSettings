--[[
    Created by Slothpala 
    Options:
    Create an options table that we use to create the GUI
--]]
local Media = LibStub("LibSharedMedia-3.0")
local lastEntry = 10
local HealthBars_disabled  = function() return not RaidFrameSettings.db.profile.Module.HealthBars end
local Fonts_disabled       = function() return not RaidFrameSettings.db.profile.Module.Fonts end
local RoleIcon_disabled    = function() return not RaidFrameSettings.db.profile.Module.RoleIcon end
local Range_disabled       = function() return not RaidFrameSettings.db.profile.Module.Range end
local BuffSize_disabled    = function() return not RaidFrameSettings.db.profile.Module.BuffSize end
local DebuffSize_disabled  = function() return not RaidFrameSettings.db.profile.Module.DebuffSize end
local DispelColor_disabled = function() return not RaidFrameSettings.db.profile.Module.DispelColor end
--LibDDI-1.0
local statusbars =  LibStub("LibSharedMedia-3.0"):List("statusbar")

local options = {
    name = "Raid Frame Settings",
    handler = RaidFrameSettings,
    type = "group",
    childGroups = "tree",
    args = {
        Config = {
            order = lastEntry-1,
            name = "Config",
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
                            order = 3,
                            type = "toggle",
                            name = "Role Icon",
                            desc = "Position the Role Icon.\n|cffF4A460CPU Impact: |r|cff90EE90VERY LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Range = {
                            order = 4,
                            type = "toggle",
                            name = "Range",
                            desc = "Use custom alpha values for out of range units.\n|cffF4A460CPU Impact: |r|cffFF0000HIGH|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        BuffSize = {
                            order = 5,
                            type = "toggle",
                            name = "Buff Size",
                            desc = "Adjust the buff size.\n|cffF4A460CPU Impact: |r|cff90EE90VERY LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        DebuffSize = {
                            order = 6,
                            type = "toggle",
                            name = "Debuff Size",
                            desc = "Adjust the debuff size.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        Overabsorb = {
                            order = 7,
                            type = "toggle",
                            name = "Overabsorb",
                            desc = "Show absorbs above the units max hp.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
                        },
                        DispelColor = {
                            order = 8,
                            type = "toggle",
                            name = "Dispel Color",
                            desc = "Recolor Health Bars based on their debuff color if your class could dispel them.\n|cffF4A460CPU Impact: |r|cff00ff00LOW|r to |r|cffFFFF00MEDIUM|r",
                            get = "GetModuleStatus",
                            set = "SetModuleStatus",
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
            hidden = Fonts_disabled,
            args = {
                Name = {
                    order = 1,
                    name = " ",
                    type = "group",
                    inline = true,
                    args = {
                        Header = {
                            order = 1,
                            type = "header",
                            name = "Name",
                        },
                        font = {
                            order = 2,
                            type = "select",
                            dialogControl = "LSM30_Font", 
                            name = "Font",
                            values = Media:HashTable("font"), 
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        outlinemode = {
                            order = 3,
                            name = "Outline",
                            type = "select",
                            values = {"OUTLINE", "THICKOUTLINE", "MONOCHROME", "NONE"},
                            sorting = {1,2,3,4},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        newline = {
                            order = 3.1,
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
                    name = " ",
                    type = "group",
                    inline = true,
                    args = {
                        Header = {
                            order = 1,
                            type = "header",
                            name = "Status Text",
                        },
                        font = {
                            order = 2,
                            type = "select",
                            dialogControl = "LSM30_Font", 
                            name = "Font",
                            values = Media:HashTable("font"), 
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        outlinemode = {
                            order = 3,
                            name = "Outline",
                            type = "select",
                            values = {"OUTLINE", "THICKOUTLINE", "MONOCHROME", "NONE"},
                            sorting = {1,2,3,4},
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                        newline = {
                            order = 3.1,
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
                            disabled = function() return RaidFrameSettings.db.profile.Fonts.Status.useclasscolor end,
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
            },
        },
        MinorModules = {
            order = 3,
            name = "Minor Modules",
            type = "group",
            args = {
                RoleIcon = {
                    hidden = RoleIcon_disabled,
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
                BuffSize = {
                    hidden = BuffSize_disabled,
                    order = 3,
                    name = "Buff Size",
                    type = "group",
                    inline = true,
                    args = {
                        width = {
                            order = 1,
                            name = "x-axis",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 1,
                            max = 30,
                            step = 1,
                            width = 1.2,
                        },
                        height = {
                            order = 2,
                            name = "y-axis",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 1,
                            max = 30,
                            step = 1,
                            width = 1.2,
                        },
                        clean_icons = {
                            order = 3,
                            type = "toggle",
                            name = "use clean icons",
                            -- and replace it with a 1pixel border #later
                            desc = "Crop the border. Keep the aspect ratio of icons when width is not equal to height.",
                            get = "GetStatus",
                            set = "SetStatus",
                        },
                    },
                },
                DebuffSize = {
                    hidden = DebuffSize_disabled,
                    order = 4,
                    name = "Debuff Size",
                    type = "group",
                    inline = true,
                    args = {
                        width = {
                            order = 1,
                            name = "x-axis",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 1,
                            max = 30,
                            step = 1,
                            width = 1.2,
                        },
                        height = {
                            order = 2,
                            name = "y-axis",
                            type = "range",
                            get = "GetStatus",
                            set = "SetStatus",
                            min = 1,
                            max = 30,
                            step = 1,
                            width = 1.2,
                        },
                    },
                },
                DispelColor = {
                    hidden = DispelColor_disabled,
                    order = 5,
                    name = "Dispel Color",
                    type = "group",
                    inline = true,
                    args = {
                        curse = {
                            order = 1,
                            type = "color",
                            name = "Curse", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        disease  = {
                            order = 2,
                            type = "color",
                            name = "Disease", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        magic = {
                            order = 3,
                            type = "color",
                            name = "Magic",
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        poison = {
                            order = 4,
                            type = "color",
                            name = "Poison", 
                            get = "GetColor",
                            set = "SetColor",
                            width = 0.5,
                        },
                        newline = {
                            order = 5,
                            type = "description",
                            name = "",
                        },
                        ResetColors = {
                            order = 6,
                            name = "reset",
                            desc = "to default",
                            type = "execute",
                            width = 0.4,
                            confirm = true,
                            func = 
                            function() 
                                RaidFrameSettings.db.profile.MinorModules.DispelColor.curse   = {r=0.6,g=0.0,b=1.0}
                                RaidFrameSettings.db.profile.MinorModules.DispelColor.disease = {r=0.6,g=0.4,b=0.0}
                                RaidFrameSettings.db.profile.MinorModules.DispelColor.magic   = {r=0.2,g=0.6,b=1.0}
                                RaidFrameSettings.db.profile.MinorModules.DispelColor.poison  = {r=0.0,g=0.6,b=0.0}
                            end,
                        },
                    },
                },
            },
        },
        ImportExportPofile = {
            order = lastEntry,
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
}


function RaidFrameSettings:GetOptionsTable()
    return options
end

