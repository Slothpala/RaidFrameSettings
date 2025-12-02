local addon_name, private = ...

local defaults = {
  profile = {
    ["*"] = {
      enabled = true,
      ["*"] = {
        gradient_start = {0, 0, 0, 1},
        gradient_end = {1, 1, 1, 1},
        normal_color   = {0, 0, 0, 1},
      },
    },
    modules = {
      ["*"] = true,
    },
    health_bars = {
      fg = {
        color_mode = 1,
        static_color = {0, 0, 0, 1},
        gradient_start = {0, 0, 0, 1},
        gradient_end = {1, 1, 1, 1},
        texture = "Blizzard",
      },
      bg = {
        color_mode = 3,
        static_color = {0, 0, 0, 1},
        gradient_start = {0, 0, 0, 1},
        gradient_end = {1, 1, 1, 1},
        texture = "Blizzard",
      },
    },
    power_bars = {
      fg = {
        color_mode = 6,
        static_color = {0, 0, 0, 1},
        gradient_start = {0, 0, 0, 1},
        gradient_end = {1,1,1,1},
        texture = "Blizzard",
      },
      bg = {
        color_mode = 3,
        static_color = {0, 0, 0, 1},
        gradient_start = {0, 0, 0, 1},
        gradient_end = {1, 1, 1, 1},
        texture = "Blizzard",
      },
    },
    fonts = {
      name = {
        color_mode = 3,
        static_color = {1, 1, 1, 1},
        npc_color = {1, 1, 1, 1},
        font = "",
        height = 12,
        flags = {
          OUTLINE = "OUTLINE",
          THICK = "THICK",
          MONOCHROME = "MONOCHROME",
        },
        point = "TOPLEFT",
        relative_point = "TOPLEFT",
        offset_x = 2,
        offset_y = 2,
      },
      status = {
        color_mode = 3,
        static_color = {1, 1, 1, 1},
        npc_color = {1, 1, 1, 1},
        font = "",
        height = 12,
        flags = {
          OUTLINE = "OUTLINE",
          THICK = "THICK",
          MONOCHROME = "MONOCHROME",
        },
        point = "CENTER",
        relative_point = "CENTER",
        offset_x = 0,
        offset_y = 0,
      },
    },
    cvars = {
      raidOptionDisplayPets = true,
    },
    colors = {
      DEATHKNIGHT = {
        gradient_start = {0.77, 0.12, 0.23},
        gradient_end   = {0.616, 0.096, 0.184},
        normal_color   = {0.77, 0.12, 0.23},
      },
      DEMONHUNTER = {
        gradient_start = {0.64, 0.19, 0.79},
        gradient_end   = {0.512, 0.152, 0.632},
        normal_color   = {0.64, 0.19, 0.79},
      },
      DRUID = {
        gradient_start = {1, 0.49, 0.04},
        gradient_end   = {0.8, 0.392, 0.032},
        normal_color   = {1, 0.49, 0.04},
      },
      EVOKER = {
        gradient_start = {0.2, 0.58, 0.50},
        gradient_end   = {0.16, 0.464, 0.40},
        normal_color   = {0.2, 0.58, 0.50},
      },
      HUNTER = {
        gradient_start = {0.67, 0.83, 0.45},
        gradient_end   = {0.536, 0.664, 0.36},
        normal_color   = {0.67, 0.83, 0.45},
      },
      MAGE = {
        gradient_start = {0.25, 0.78, 0.92},
        gradient_end   = {0.20, 0.624, 0.736},
        normal_color   = {0.25, 0.78, 0.92},
      },
      MONK = {
        gradient_start = {0, 1, 0.60},
        gradient_end   = {0, 0.8, 0.48},
        normal_color   = {0, 1, 0.60},
      },
      PALADIN = {
        gradient_start = {0.96, 0.55, 0.73},
        gradient_end   = {0.768, 0.44, 0.584},
        normal_color   = {0.96, 0.55, 0.73},
      },
      PRIEST = {
        gradient_start = {1, 1, 1},
        gradient_end   = {0.8, 0.8, 0.8},
        normal_color   = {1, 1, 1},
      },
      ROGUE = {
        gradient_start = {1, 0.96, 0.41},
        gradient_end   = {0.8, 0.768, 0.328},
        normal_color   = {1, 0.96, 0.41},
      },
      SHAMAN = {
        gradient_start = {0, 0.44, 0.87},
        gradient_end   = {0, 0.352, 0.696},
        normal_color   = {0, 0.44, 0.87},
      },
      WARLOCK = {
        gradient_start = {0.53, 0.53, 0.93},
        gradient_end   = {0.424, 0.424, 0.744},
        normal_color   = {0.53, 0.53, 0.93},
      },
      WARRIOR = {
        gradient_start = {0.78, 0.61, 0.43},
        gradient_end   = {0.624, 0.488, 0.344},
        normal_color   = {0.78, 0.61, 0.43},
      },
    },
  },
}

function private:InitDatabase()
  _G[addon_name].db= LibStub("AceDB-3.0"):New(addon_name .. "DB", defaults)
end

