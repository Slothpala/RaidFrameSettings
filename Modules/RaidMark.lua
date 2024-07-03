local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("RaidMark")

--------------------
--- Libs & Utils ---
--------------------


------------------------
--- Speed references ---
------------------------

-- WoW Api



function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.RaidMark)


end

function module:OnDisable()

end
