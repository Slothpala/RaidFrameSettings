local _, addonTable = ...
addonTable.PowerColor = {}
local PowerColor = addonTable.PowerColor

------------------------
--- Speed references ---
------------------------
-- WoW Api
local UnitIsConnected = UnitIsConnected


local function set_power_color(cuf_frame)
  -- Function is controlled by RaidFrameColor.lua
end

local function update_power_color(cuf_frame)
	if not cuf_frame.powerBar then
		return
	end
  local is_connected = UnitIsConnected(cuf_frame.unit)
  if not is_connected then
    return
  else
    set_power_color(cuf_frame)
  end
end

hooksecurefunc("CompactUnitFrame_UpdatePowerColor", update_power_color)

--- Set the default color of player healthbars
---@param new_set_power_color function
function PowerColor:SetPowerColorFunction(new_set_power_color)
  set_power_color = new_set_power_color
end

function PowerColor:UpdateColor(cuf_frame)
  update_power_color(cuf_frame)
end
