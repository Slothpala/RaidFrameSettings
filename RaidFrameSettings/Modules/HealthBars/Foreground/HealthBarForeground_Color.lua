--[[
  Color options:
  1 = Class colored.
  2 = Gradient class colored.
  3 = Static color.
  4 = Static gradient color.
  5 = Health value color.
--]]

-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("HealthBarForeground_Color")

-- Libs & Utils.
local UnitCache = private.UnitCache

-- We just do the same checks blizzard does and only overwrite it if needed.
local function should_skip_update(cuf_frame)
	local unit_is_connected = UnitIsConnected(cuf_frame.unit)
	local unit_is_dead = unit_is_connected and UnitIsDead(cuf_frame.unit)
	local unit_is_player = UnitIsPlayer(cuf_frame.unit) or UnitIsPlayer(cuf_frame.displayedUnit)
	local unit_is_active_player = UnitIsUnit(cuf_frame.unit, "player") or UnitIsUnit(cuf_frame.displayedUnit, "player")

  if ( not unit_is_connected or (unit_is_dead and not unit_is_player) ) then
    return true
  else
    -- @TODO add all the exceptions.
  end
  return false
end

-- Setup the module.
function module:OnEnable()
  -- Get the data.
  local db_obj = addon.db.profile.health_bars.fg
  local color_mode = db_obj.color_mode

  if color_mode == 1 then -- Class
    -- For static class colors, simply set the default settings and let the game handle the rest.
    if C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" then
      C_CVar.SetCVar("raidFramesDisplayClassColor", "0")
    end
    C_CVar.SetCVar("raidFramesDisplayClassColor", "1")
  elseif color_mode == 2 then -- Class Gradient
    local orientation = "HORIZONTAL" -- @TODO Add orientation based on orientation and fill style.
    local function update_color(cuf_frame)
      if should_skip_update(cuf_frame) then
        return
      end
      local guid = UnitGUID(cuf_frame.unit)
      local unit_cache = UnitCache:Get(guid)
      local color = addon:GetColor(unit_cache.class)
      local texture = cuf_frame.healthBar:GetStatusBarTexture()
      texture:SetGradient(orientation, color.gradient_start, color.gradient_end)
    end
      self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateHealthColor", update_color)
      private.IterateRoster(update_color)
  elseif color_mode == 3 then -- Static
    -- For static colors, we can also rely on the Blizzard setting. Since Midnight, you can now set the color via a new CVar.
    -- Disable class color first, otherwise raidFramesHealthBarColor will be ignored.
    if C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" then
      C_CVar.SetCVar("raidFramesDisplayClassColor", "0")
    end
    local color = CreateColor(unpack(db_obj.static_color))
    local hex_color = color:GenerateHexColor()
    -- When changing from gradient static to static color, the CVar may not trigger an update.
    -- To ensure the frames refresh correctly, we temporarily set the color to white.
    if C_CVar.GetCVar("raidFramesHealthBarColor") == hex_color then
      C_CVar.SetCVar("raidFramesHealthBarColor", "ffffffff")
    end
    C_CVar.SetCVar("raidFramesHealthBarColor", hex_color)
  elseif color_mode == 4 then -- Static Gradient
    local gradient_start = CreateColor(unpack(db_obj.gradient_start))
    local gradient_end = CreateColor(unpack(db_obj.gradient_end))
    local orientation = "HORIZONTAL" -- @TODO Add orientation based on orientation and fill style.
    local function update_color(cuf_frame)
      if should_skip_update(cuf_frame) then
        return
      end
      local texture = cuf_frame.healthBar:GetStatusBarTexture()
      texture:SetGradient(orientation, gradient_start, gradient_end)
    end
    self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateHealthColor", update_color)
    private.IterateRoster(update_color)
  elseif color_mode == 5 then
    -- coming soon.
  end

end

function module:OnDisable()

end
