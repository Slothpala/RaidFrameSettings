--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("Range")

--------------------
--- Libs & Utils ---
--------------------

local HealthColor = addonTable.HealthColor
Mixin(module, addonTable.HookRegistryMixin)

------------------------
--- Speed references ---
------------------------

-- WoW Api
local UnitInRange = UnitInRange


function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.Range)
  -- Fetch DB values
  local out_of_range_foregorund_alpha = db_obj.out_of_range_foregorund_alpha
  local out_of_range_background_alpha = db_obj.out_of_range_background_alpha
  -- Set the callback
  local update_alpha
  if db_obj.use_out_of_range_background_color then
    local oor_color = db_obj.out_of_range_background_color
    local min_color = CreateColor(oor_color[1], oor_color[2], oor_color[3], out_of_range_background_alpha)
    local max_color = CreateColor(oor_color[1], oor_color[2], oor_color[3], out_of_range_background_alpha)
    update_alpha = function (cuf_frame)
      local in_range, checked_range = UnitInRange(cuf_frame.displayedUnit)
      if ( checked_range and not in_range ) then
        cuf_frame:SetAlpha(out_of_range_foregorund_alpha)
        -- The background alpha is part of the gradient color.
        cuf_frame.background:SetGradient("HORIZONTAL", min_color, max_color)
      else
        HealthColor:SetBackgroundColor(cuf_frame)
      end
    end
  else
    update_alpha = function(cuf_frame)
      local in_range, checked_range = UnitInRange(cuf_frame.displayedUnit)
      if ( checked_range and not in_range ) then
        cuf_frame:SetAlpha(out_of_range_foregorund_alpha)
        cuf_frame.background:SetAlpha(out_of_range_background_alpha)
      else
        cuf_frame.background:SetAlpha(1)
      end
    end
  end

  self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateInRange", update_alpha)
  addon:IterateRoster(function(cuf_frame)
    if cuf_frame.displayedUnit then
      update_alpha(cuf_frame)
    end
  end)
end

function module:OnDisable()
  self:DisableHooks()
  addon:IterateRoster(function(cuf_frame)
    HealthColor:SetBackgroundColor(cuf_frame)
    if cuf_frame.displayedUnit then
      CompactUnitFrame_UpdateInRange(cuf_frame)
    end
  end)
end
