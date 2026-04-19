local addon_name, private = ...
local addon = _G[addon_name]

-- Healer and Augmentation Evoker spells that are no longer secret auras.
-- Grouped by class/spec for the spell picker UI.
-- Stored on the addon table so the Options addon can access it.
addon.AuraIndicatorSpells = {
  {
    class = "DRUID",
    category = "Restoration Druid",
    spells = {
      { id = 774 },    -- Rejuvenation
      { id = 8936 },   -- Regrowth
      { id = 33763 },  -- Lifebloom
      { id = 48438 },  -- Wild Growth
      { id = 155777 }, -- Germination
      { id = 1126 },   -- Mark of the Wild
    },
  },
  {
    class = "PRIEST",
    category = "Holy Priest",
    spells = {
      { id = 139 },   -- Renew
      { id = 41635 }, -- Prayer of Mending
      { id = 77489 }, -- Echo of Light
    },
  },
  {
    class = "PRIEST",
    category = "Discipline Priest",
    spells = {
      { id = 17 },      -- Power Word: Shield
      { id = 194384 },  -- Atonement
      { id = 1253593 }, -- Void Shield
    },
  },
  {
    class = "PALADIN",
    category = "Holy Paladin",
    spells = {
      { id = 53563 },   -- Beacon of Light
      { id = 156322 },  -- Eternal Flame
      { id = 156910 },  -- Beacon of Faith
      { id = 1244893 }, -- Beacon of the Savior
    },
  },
  {
    class = "SHAMAN",
    category = "Restoration Shaman",
    spells = {
      { id = 974 },    -- Earth Shield
      { id = 383648 }, -- Earth Shield (Elemental Orbit)
      { id = 61295 },  -- Riptide
    },
  },
  {
    class = "MONK",
    category = "Mistweaver Monk",
    spells = {
      { id = 115175 }, -- Soothing Mist
      { id = 119611 }, -- Renewing Mist
      { id = 124682 }, -- Enveloping Mist
      { id = 450769 }, -- Aspect of Harmony
    },
  },
  {
    class = "EVOKER",
    category = "Preservation Evoker",
    spells = {
      { id = 355941 }, -- Dream Breath
      { id = 363502 }, -- Dream Flight
      { id = 364343 }, -- Echo
      { id = 366155 }, -- Reversion
      { id = 367364 }, -- Echo Reversion
      { id = 373267 }, -- Lifebind
      { id = 376788 }, -- Echo Dream Breath
    },
  },
  {
    class = "EVOKER",
    category = "Augmentation Evoker",
    spells = {
      { id = 360827 }, -- Blistering Scales
      { id = 395152 }, -- Ebon Might
      { id = 410089 }, -- Prescience
      { id = 410263 }, -- Inferno's Blessing
      { id = 410686 }, -- Symbiotic Bloom
      { id = 413984 }, -- Shifting Sands
    },
  },
}
