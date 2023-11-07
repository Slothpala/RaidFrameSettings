local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local module = RaidFrameSettings:NewModule("DebuffHighlight")
Mixin(module, addonTable.hooks)