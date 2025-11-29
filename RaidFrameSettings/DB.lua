local addon_name, private = ...

local defaults = {
  profile = {
    ["*"] = {
      enabled = true,
      ["*"] = {
        gradient_start = {0,0,0,1},
        gradient_end = {1,1,1,1},
      },
    },
    modules = {
      ["*"] = true,
    },
    health_bars = {
      fg = {
        color_mode = 1,
        static_color = {0,0,0,1},
        gradient_start = {0,0,0,1},
        gradient_end = {1,1,1,1},
        texture = "Blizzard",
      },
      bg = {
        color_mode = 3,
        static_color = {0,0,0,1},
        gradient_start = {0,0,0,1},
        gradient_end = {1,1,1,1},
        texture = "Blizzard",
      },
    },
    power_bars = {
      fg = {
        color_mode = 6,
        static_color = {0,0,0,1},
        gradient_start = {0,0,0,1},
        gradient_end = {1,1,1,1},
        texture = "Blizzard",
      },
      bg = {
        color_mode = 3,
        static_color = {0,0,0,1},
        gradient_start = {0,0,0,1},
        gradient_end = {1,1,1,1},
        texture = "Blizzard",
      },
    },
    fonts = {
      name = {
        color_mode = 2,
        static_color = {0,0,0,1},
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
        color_mode = 2,
        static_color = {0,0,0,1},
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
  },
}

function private:InitDatabase()
  _G[addon_name].db= LibStub("AceDB-3.0"):New(addon_name .. "DB", defaults)
end

