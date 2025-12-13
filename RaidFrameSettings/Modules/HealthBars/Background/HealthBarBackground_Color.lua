--[[
  Color options:
  1 = Class colored.
  2 = Gradient class colored.
  3 = Static color.
  4 = Static gradient color.
--]]

-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("HealthBarBackground_Color")

-- Libs & Utils.
local UnitCache = private.UnitCache


-- Setup the module.
function module:OnEnable()
  -- Get the data.
  local db_obj = addon.db.profile.health_bars.bg
  local color_mode = db_obj.color_mode

  local update_color = function() end
  module.update_function = update_color

  local darkened_class_colors  = {}
  if color_mode == 1 or color_mode == 2 then
    for class, color in pairs(addon.db.profile.colors.class) do
      darkened_class_colors[class] = {
        normal_color = {color.normal_color[1] * db_obj.darkening_factor, color.normal_color[2] * db_obj.darkening_factor, color.normal_color[3] * db_obj.darkening_factor, 1}
      }
      if color_mode == 2 then
        local r, g, b, a = unpack(color.gradient_start)
        darkened_class_colors[class].gradient_start = CreateColor(r * db_obj.darkening_factor, g * db_obj.darkening_factor, b * db_obj.darkening_factor, a)
        r, g, b, a = unpack(color.gradient_end)
        darkened_class_colors[class].gradient_end = CreateColor(r * db_obj.darkening_factor, g * db_obj.darkening_factor, b * db_obj.darkening_factor, a)
      end
    end
  end
  if color_mode == 1 then -- Class
    update_color = function (cuf_frame)
      local guid = UnitGUID(cuf_frame.unit)
      local unit_cache = UnitCache:Get(guid)
      cuf_frame.background:SetVertexColor(unpack(darkened_class_colors[unit_cache.class].normal_color))
    end
    self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", update_color)
  elseif color_mode == 2 then -- Class Gradient
    local orientation = "HORIZONTAL" -- @TODO Add orientation based on orientation and fill style.
    update_color = function (cuf_frame)
      local guid = UnitGUID(cuf_frame.unit)
      local unit_cache = UnitCache:Get(guid)
      cuf_frame.background:SetGradient(orientation, darkened_class_colors[unit_cache.class].gradient_start, darkened_class_colors[unit_cache.class].gradient_end)
    end
    self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", update_color)
  elseif color_mode == 3 then -- Static
    local color = db_obj.static_color
    update_color = function (cuf_frame)
      cuf_frame.background:SetVertexColor(unpack(color))
    end
    self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", update_color)
  elseif color_mode == 4 then -- Static Gradient
    local gradient_start = CreateColor(unpack(db_obj.gradient_start))
    local gradient_end = CreateColor(unpack(db_obj.gradient_end))
    local orientation = "HORIZONTAL" -- @TODO Add orientation based on orientation and fill style.
    local function update_color(cuf_frame)
      cuf_frame.background:SetGradient(orientation, gradient_start, gradient_end)
    end
    self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateHealthColor", update_color)
  end

  -- Apply the changes.
  private.IterateRoster(update_color)
end

function module:OnDisable()

end
