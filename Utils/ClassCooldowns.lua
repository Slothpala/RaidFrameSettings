local _, addonTable = ...
local addon = addonTable.addon

local class_cooldowns = {
  --[[
  CLASS = {
    category = {
      spell = {
        relatives' spell_ids/auras, Basically, all spell_ids that belong to that spell are grouped together.
        ...,
        ...,
      }
    }
  }
  --]]
  DEATHKNIGHT = {
    offensive = {

    },
    defensive = {
      [48707] = { -- [[ Anti Magic Shell ]]
        auras = {
          48707, -- Base
          410358, -- Spellwarden @PVP
        },
      },
      [48792] = { -- [[ Icebound Fortitude ]]
        auras = {
          48792, -- Base
        },
      },
      [55233] = { -- [[ Vampiric Blood ]]
        auras = {
          55233, -- Base
        },
      },
      [49028] = { -- [[ Dancing Rune Weapon ]]
        auras = {
          81256, -- Base
        },
      },
      [51052] = { -- [[ Dancing Rune Weapon ]]
        auras = {
          145629, -- Base
        },
      },
    },
  },
  DEMONHUNTER = {
    offensive = {
    },
    defensive = {
      [198589] = { -- [[ Blur ]]
        auras = {
          212800, -- Base
        },
      },
      [196555] = { -- [[ Netherwalk ]]
        auras = {
          196555, -- Base
        },
      },
      [187827] = { -- [[ Metamorphosis ]]
        auras = {
          187827, -- Base
        },
      },
      [196718] = { -- [[ Darkness ]]
        auras = {
          209426, -- Base
        },
      },
    },
  },
  DRUID = {
    offensive = {
    },
    defensive = {
      [22812] = { -- [[ Barkskin ]]
        auras = {
          22812, -- Base
        },
      },
      [200851] = { -- [[ Rage of the Sleeper ]]
        auras = {
          200851, -- Base
        },
      },
      [61336] = { -- [[ Survival Instincts ]]
        auras = {
          61336, -- Base
        },
      },
      [102342] = { -- [[ Ironbark ]]
        auras = {
          102342, -- Base
        },
      },
    },
  },
  EVOKER = {
    offensive = {
    },
    defensive = {
      [363916] = { -- [[ Obsidian Scales ]]
        auras = {
          363916, -- Base
        },
      },
      [374348] = { -- [[ Renewing Blaze ]]
        auras = {
          374348, -- Base
        },
      },
      [378464] = { -- [[ Nullifying Shroud ]] --@PVP
        auras = {
          378464, -- Base
        },
      },
      [357170] = { -- [[ Time Dilation ]] --@PVP
        auras = {
          357170, -- Base
        },
      },
    },
  },
  HUNTER = {
    offensive = {
    },
    defensive = {
      [186265] = { -- [[ Aspect of the Turtle ]]
        auras = {
          186265, -- Base
        },
      },
      [264735] = { -- [[ Survival of the Fittest ]]
        auras = {
          264735, -- Base
        },
      },
    },
  },
  MAGE = {
    offensive = {
    },
    defensive = {
      [45438] = { -- [[ Ice Block ]]
        auras = {
          45438, -- Base
        },
      },
      [342245] = { -- [[ Alter Time ]]
        auras = {
          342246, -- Base
        },
      },
      [110959] = { -- [[ Greater Invisibilit ]]
        auras = {
          113862, -- Base
        },
      },
      [414658] = { -- [[ Ice Cold ]]
        auras = {
          414658, -- Base
        },
      },
      [55342] = { -- [[ Mirror Image ]]
        auras = {
          55342, -- Base
        },
      },
    },
  },
  MONK = {
    offensive = {
    },
    defensive = {
      [122470] = { -- [[ Touch of Karma ]]
        auras = {
          125174, -- Base
        },
      },
      [122278] = { -- [[ Dampen Harm ]]
        auras = {
          122278, -- Base
        },
      },
      [122783] = { -- [[ Diffuse Magic ]]
        auras = {
          122783, -- Base
        },
      },
      [120954] = { -- [[ Fortifying Brew ]]
        auras = {
          120954, -- Base
        },
      },
      [116849] = { -- [[ Life Cocoon ]]
        auras = {
          116849, -- Base
        },
      },
    },
  },
  PALADIN = {
    offensive = {
    },
    defensive = {
      [642] = { -- [[ Divine Shield ]]
        auras = {
          642, -- Base
        },
      },
      [31850] = { -- [[ Ardent Defender ]]
        auras = {
          31850, -- Base
        },
      },
      [403876] = { -- [[ Divine Protection Retri ]]
        auras = {
          403876, -- Retri
          498, -- Holy
        },
      },
      [86659] = { -- [[ Guardian of Ancient King ]]
        auras = {
          86659, -- Base
          212641, -- Glyph of Queens
        },
      },
      [184662] = { -- [[ Shield of Vengance ]]
        auras = {
          184662, -- Base
        },
      },
      [389539] = { -- [[ Sentinel ]]
        auras = {
          389539, -- Base
        },
      },
      [1022] = { -- [[ Blessing of Protection ]]
        auras = {
          1022, -- Base
        },
      },
      [6940] = { -- [[ Blessing of Sacrifice ]]
        auras = {
          6940, -- Base
        },
      },
    },
  },
  PRIEST = {
    offensive = {
    },
    defensive = {
      [19236] = { -- [[ Desperate Prayer ]]
        auras = {
          19236, -- Base
        },
      },
      [47585] = { -- [[ Dispersion ]]
        auras = {
          47585, -- Base
        },
      },
      [62618] = { -- [[ Power Word: Barrrier ]]
        auras = {
          81782, -- Base
        },
      },
      [33206] = { -- [[ Pain Suppression ]]
        auras = {
          33206, -- Base
        },
      },
      [47788] = { -- [[ Guardian Spirit ]]
        auras = {
          47788, -- Base
        },
      },
    },
  },
  ROGUE = {
    offensive = {
    },
    defensive = {
      [31224] = { -- [[ Cloak of Shadows ]]
        auras = {
          31224, -- Base
        },
      },
      [5277] = { -- [[ Evasion ]]
        auras = {
          5277, -- Base
        },
      },
      [1966] = { -- [[ Feint ]]
        auras = {
          1966, -- Base
        },
      },
    },
  },
  SHAMAN = {
    offensive = {
    },
    defensive = {
      [108271] = { -- [[ Astral Shift ]]
        auras = {
          108271, -- Base
        },
      },
      [98008] = { -- [[ Spirit Link Totem ]]
        auras = {
          325174, -- Base
        },
      },
      [198103] = { -- [[ Earth Elemental ]]
        auras = {
          381755, -- Base
        },
      },
    },
  },
  WARLOCK = {
    offensive = {
    },
    defensive = {
      [108416] = { -- [[ Dark Pact ]]
        auras = {
          108416, -- Base
        },
      },
      [104773] = { -- [[ Unending Resolve ]]
        auras = {
          104773, -- Base
        },
      },
    },
  },
  WARRIOR = {
    offensive = {
    },
    defensive = {
      [118038] = { -- [[ Die by the Sword ]]
        auras = {
          118038, -- Base
        },
      },
      [184364] = { -- [[ Enraged Regeneration ]]
        auras = {
          184364, -- Base
        },
      },
      [12975] = { -- [[ Last Stand ]]
        auras = {
          12975, -- Base
        },
      },
      [871] = { -- [[ Shield Wall ]]
        auras = {
          871, -- Base
        },
      },
      [23920] = { -- [[ Spell Reflection ]]
        auras = {
          23920, -- Base
        },
      },
    },
  },
}

function addon:ClassCooldowns_GetDB()
  return class_cooldowns
end

function addon:ClassCooldowns_GetDefensiveCooldowns()

end
