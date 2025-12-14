-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Libs & Utils.
local CR = private.CallbackRegistry

-- Create a module.
local module = addon:CreateModule("CVar_raidFramesDisplayOnlyHealerPowerBars")


-- Setup the module.
function module:OnEnable()
  C_CVar.SetCVar("raidFramesDisplayOnlyHealerPowerBars", addon.db.profile.cvars.raidFramesDisplayOnlyHealerPowerBars and "1" or "0")
end


