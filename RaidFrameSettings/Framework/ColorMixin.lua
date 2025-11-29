local addon_name, private = ...
private.Mixins.ColorMixin = {}
local color_mixin = private.Mixins.ColorMixin

-- ColorMixin object that can be shared between modules.
local color_cache = {}

local function create_colors(key)
  local db_obj = _G[addon_name].db.profile.colors[key]
  color_cache[key] = {
    gradient_start = CreateColor(unpack(db_obj["gradient_start"])),
    gradient_end = CreateColor(unpack(db_obj["gradient_end"])),
    normal_color = db_obj.normal_color,
  }
end

function color_mixin:GetColor(key)
  if not color_cache[key] then
    create_colors(key)
  end
  return color_cache[key]
end

function color_mixin:UpdateColorCache()
  for k, _ in pairs(color_cache) do
    create_colors(k)
  end
end
