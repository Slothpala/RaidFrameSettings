--[[Created by Slothpala]]--
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
        prio = 5,
        auras = {
          48707, -- Base
          410358, -- Spellwarden @PVP
        },
      },
      [48792] = { -- [[ Icebound Fortitude ]]
        prio = 4,
        auras = {
          48792, -- Base
        },
      },
      [55233] = { -- [[ Vampiric Blood ]]
        prio = 5,
        auras = {
          55233, -- Base
        },
      },
      [49028] = { -- [[ Dancing Rune Weapon ]]
        prio = 4,
        auras = {
          81256, -- Base
        },
      },
      [51052] = { -- [[ Anti-Magic Zone ]]
        prio = 2,
        auras = {
          145629, -- Base
        },
      },
      [49039] = { -- [[ Lichborne ]]
        prio = 5,
        auras = {
          49039, -- Base
        },
      },
    },
  },
  DEMONHUNTER = {
    offensive = {
    },
    defensive = {
      [198589] = { -- [[ Blur ]]
        prio = 5,
        auras = {
          212800, -- Base
        },
      },
      [196555] = { -- [[ Netherwalk ]]
        prio = 4,
        auras = {
          196555, -- Base
        },
      },
      [187827] = { -- [[ Metamorphosis ]]
        prio = 5,
        auras = {
          187827, -- Base
        },
      },
      [196718] = { -- [[ Darkness ]]
        prio = 2,
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
        prio = 5,
        auras = {
          22812, -- Base
        },
      },
      [200851] = { -- [[ Rage of the Sleeper ]]
        prio = 5,
        auras = {
          200851, -- Base
        },
      },
      [61336] = { -- [[ Survival Instincts ]]
        prio = 4,
        auras = {
          61336, -- Base
        },
      },
      [102342] = { -- [[ Ironbark ]]
        prio = 1,
        auras = {
          102342, -- Base
        },
      },
      [5487] = { -- [[ Bear Form ]]
        prio = 8,
        auras = {
          5487, -- Base
        },
      },
    },
  },
  EVOKER = {
    offensive = {
    },
    defensive = {
      [363916] = { -- [[ Obsidian Scales ]]
        prio = 4,
        auras = {
          363916, -- Base
        },
      },
      [374348] = { -- [[ Renewing Blaze ]]
        prio = 5,
        auras = {
          374348, -- Base
        },
      },
      [378464] = { -- [[ Nullifying Shroud ]] --@PVP
        prio = 4,
        auras = {
          378464, -- Base
        },
      },
      [357170] = { -- [[ Time Dilation ]] --@PVP
        prio = 1,
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
        prio = 4,
        auras = {
          186265, -- Base
        },
      },
      [264735] = { -- [[ Survival of the Fittest ]]
        prio = 5,
        auras = {
          264735, -- Base
        },
      },
      [202746] = { -- [[ Survival Tactics ]] --@PVP
        prio = 5,
        auras = {
          202748, -- Base
        },
      },
    },
  },
  MAGE = {
    offensive = {
    },
    defensive = {
      [45438] = { -- [[ Ice Block ]]
        prio = 4,
        auras = {
          45438, -- Base
          414658, -- Ice Cold
        },
      },
      [342245] = { -- [[ Alter Time ]]
        prio = 5,
        auras = {
          342246, -- Base
        },
      },
      [110959] = { -- [[ Greater Invisibility ]]
        prio = 5,
        auras = {
          113862, -- Base
        },
      },
      [55342] = { -- [[ Mirror Image ]]
        prio = 5,
        auras = {
          55342, -- Base
        },
      },
      [414660] = { -- [[ Mass Barrier ]]
        prio = 7,
        auras = {
          414663, -- Arcane / Prismatic Barrier
          414662, -- Fire / Blazing Barrier
          414661, -- Frost / Ice Barrier
        },
      },
      [235450] = { -- [[ Prismatic Barrier ]]
        prio = 7,
        auras = {
          235450, -- Base
        },
      },
      [235313] = { -- [[ Blazing Barrier ]]
        prio = 7,
        auras = {
          235313, -- Base
        },
      },
      [11426] = { -- [[ Ice Barrier ]]
        prio = 7,
        auras = {
          11426, -- Base
        },
      },
    },
  },
  MONK = {
    offensive = {
    },
    defensive = {
      [122470] = { -- [[ Touch of Karma ]]
        prio = 4,
        auras = {
          125174, -- Base
        },
      },
      [122278] = { -- [[ Dampen Harm ]]
        prio = 5,
        auras = {
          122278, -- Base
        },
      },
      [122783] = { -- [[ Diffuse Magic ]]
        prio = 5,
        auras = {
          122783, -- Base
        },
      },
      [120954] = { -- [[ Fortifying Brew ]]
        prio = 4,
        auras = {
          120954, -- Base
        },
      },
      [116849] = { -- [[ Life Cocoon ]]
        prio = 1,
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
      [204018] = { -- [[ Blessing of Spellwarding ]]
        prio = 1,
        auras = {
          204018, -- Base
        },
      },
      [642] = { -- [[ Divine Shield ]]
        prio = 4,
        auras = {
          642, -- Base
        },
      },
      [31850] = { -- [[ Ardent Defender ]]
        prio = 5,
        auras = {
          31850, -- Base
        },
      },
      [403876] = { -- [[ Divine Protection ]]
        prio = 5,
        auras = {
          403876, -- Retri
          498, -- Holy
        },
      },
      [86659] = { -- [[ Guardian of Ancient King ]]
        prio = 4,
        auras = {
          86659, -- Base
          212641, -- Glyph of Queens
        },
      },
      [184662] = { -- [[ Shield of Vengeance ]]
        prio = 5,
        auras = {
          184662, -- Base
        },
      },
      [389539] = { -- [[ Sentinel ]]
        prio = 5,
        auras = {
          389539, -- Base
        },
      },
      [1022] = { -- [[ Blessing of Protection ]]
        prio = 1,
        auras = {
          1022, -- Base
        },
      },
      [6940] = { -- [[ Blessing of Sacrifice ]]
        prio = 1,
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
        prio = 5,
        auras = {
          19236, -- Base
        },
      },
      [47585] = { -- [[ Dispersion ]]
        prio = 4,
        auras = {
          47585, -- Base
        },
      },
      [62618] = { -- [[ Power Word: Barrier ]]
        prio = 2,
        auras = {
          81782, -- Base
        },
      },
      [33206] = { -- [[ Pain Suppression ]]
        prio = 1,
        auras = {
          33206, -- Base
        },
      },
      [47788] = { -- [[ Guardian Spirit ]]
        prio = 1,
        auras = {
          47788, -- Base
        },
      },
      [586] = { -- [[ Fade ]]
        prio = 6,
        auras = {
          586, -- Base
        },
      },
      [193065] = { -- [[[ Protective Light]]]
        prio = 6,
        auras = {
          193065, -- Base
        },
      }
    },
  },
  ROGUE = {
    offensive = {
    },
    defensive = {
      [31224] = { -- [[ Cloak of Shadows ]]
        prio = 4,
        auras = {
          31224, -- Base
        },
      },
      [5277] = { -- [[ Evasion ]]
        prio = 4,
        auras = {
          5277, -- Base
        },
      },
      [1966] = { -- [[ Feint ]]
        prio = 5,
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
        prio = 4,
        auras = {
          108271, -- Base
        },
      },
      [98008] = { -- [[ Spirit Link Totem ]]
        prio = 2,
        auras = {
          325174, -- Base
        },
      },
      [198103] = { -- [[ Earth Elemental ]]
        prio = 6,
        auras = {
          381755, -- Base
        },
      },
      [260878] = { -- [[ Spirit Wolf ]]
        prio = 6,
        auras = {
          260881, -- Base
        },
      },
      [114893] = { -- [[ Stone Bulwark Totem ]]
        prio = 8,
        auras = {
          114893, -- Big Absorb
          462844, -- Small Absorb
        },
    },
    },
  },
  WARLOCK = {
    offensive = {
    },
    defensive = {
      [108416] = { -- [[ Dark Pact ]]
        prio = 5,
        auras = {
          108416, -- Base
        },
      },
      [104773] = { -- [[ Unending Resolve ]]
        prio = 4,
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
      [97462] = { -- [[ Rallying Cry ]]
        prio = 2,
        auras = {
          97463, -- Base
        },
      },
      [118038] = { -- [[ Die by the Sword ]]
        prio = 4,
        auras = {
          118038, -- Base
        },
      },
      [184364] = { -- [[ Enraged Regeneration ]]
        prio = 4,
        auras = {
          184364, -- Base
        },
      },
      [12975] = { -- [[ Last Stand ]]
        prio = 4,
        auras = {
          12975, -- Base
        },
      },
      [871] = { -- [[ Shield Wall ]]
        prio = 4,
        auras = {
          871, -- Base
        },
      },
      [23920] = { -- [[ Spell Reflection ]]
        prio = 5,
        auras = {
          23920, -- Base
        },
      },
      [386208] = { -- [[ Defensive Stance ]]
        prio = 6,
        auras = {
          386208, -- Base
        },
      },
      [132404] = { -- [[ Shield Block ]]
        prio = 6,
        auras = {
          132404, -- Base
        },
      },
      [190456] = { -- [[ Ignore Pain ]]
        prio = 6,
        auras = {
          190456, -- Base
        },
      },
    },
  },
  TRINKET = {
    offensive = {
    },
    defensive = {
      [345231] = { -- [[ Gladiator's Emblem ]] @PVP
        prio = 3,
        auras = {
          345231, -- Base
        },
      },
      [443381] = { -- [[ Cinderbrew Stein ]] @TWW
        prio = 3,
        auras = {
          443381, -- Base
        },
      },
      [435482] = { -- [[ Silken Chain Weaver ]] @TWW
        prio = 3,
        auras = {
          435482, -- Base
        },
      },
      [450551] = { -- [[ Mereldar's Toll ]] @TWW
        prio = 8, -- small versa buff
        auras = {
          450551, -- Base
        },
      },
      [451367] = { -- [[ Candle Comfort ]] @TWW
        prio = 8, -- small versa buff
        auras = {
          451367, -- Base
        },
      },
      [443529] = { -- [[ Burin of the Candle King ]] @TWW
        prio = 3,
        auras = {
          451924, -- Base
        },
      },
      [451568] = { -- [[ Refracting Resistance ]] @TWW
        prio = 3,
        auras = {
          451568, -- Base
        },
      },
      [455486] = { -- [[ Golden Glow ]] @TWW
        prio = 3,
        auras = {
          455486, -- Base
        },
      },
      [466810] = { -- [[ Chromebustible Bomb Suit ]] @TWW_Season_2
        prio = 3,
        auras = {
          466810, -- Base
        },
      },
      [1220488] = { -- [[ Darkfuse Medichopper ]] @TWW_Season_2
        prio = 3,
        auras = {
          1219104, -- Base
        },
      },
      [1216921] = { -- [[ Ominous Oil Residue ]] @TWW_Season_2
        prio = 3,
        auras = {
          1216921, -- Base
        },
      },
      [1219102] = { -- [[ Ringing Ritual Mud ]] @TWW_Season_2
        prio = 3,
        auras = {
          1219102, -- Base
        },
      },
      [466673] = { -- [[ Scrapfield 9001 ]] @TWW_Season_2
        prio = 3,
        auras = {
          466673, -- Base
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
