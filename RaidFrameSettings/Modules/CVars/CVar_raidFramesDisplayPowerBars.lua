-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Libs & Utils.
local CR = private.CallbackRegistry

-- Create a module.
local module = addon:CreateModule("CVar_raidFramesDisplayPowerBars")


-- Setup the module.
function module:OnEnable()
  C_CVar.SetCVar("raidFramesDisplayPowerBars", addon.db.profile.cvars.raidFramesDisplayPowerBars and "1" or "0")
end

