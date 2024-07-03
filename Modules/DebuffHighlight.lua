local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("DebuffHighlight")

--------------------
--- Libs & Utils ---
--------------------

local HealthColor = addonTable.HealthColor
local CR = addonTable.CallbackRegistry
local LCD = LibStub("LibCanDispel-1.0")

------------------------
--- Speed references ---
------------------------

-- Lua
local next = next
-- WoW Api
local C_UnitAuras_GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID


local callback_id
function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.DebuffHighlight)
  -- Specify the aura colors to be displayed.
  local should_color_in_dispel_color = db_obj.operation_mode == 1 and LCD.CanDispel or function(dispelName)
    if db_obj[dispelName] then
      return true
    end
    return false
  end

  local function set_statusbar_to_dispel_color(statusbar, dispel_type)
    local color = addonTable.colors.dispel_type_colors[dispel_type].normal_color
    statusbar:SetStatusBarColor(color[1], color[2], color[3])
  end

  local function on_dispel_type_changed(cuf_frame)
    local is_dispel_type = false
    -- Iterate the disple_types aura table. See TableUtil.CreatePriorityTable.
    cuf_frame.RFS_FrameEnvironment.dispel_types:Iterate(function(auraInstanceID, aura)
      -- Check if the health bar should be recolored to match the dispel type color.
      if should_color_in_dispel_color(aura.dispelName) then
        --[[
          I called it other_cuf_frame to indicate that it does not have to be the same unit as the one passed to on_dispel_type_changed.
          This callback is used to get a definitive answer if the aura that caused the recoloring of the healthbar is an aura of frame.unit, which is sometimes not the case when frames are rearranged.
          Without this check, the frame could be stuck in that color.
        --]]
        cuf_frame.RFS_FrameEnvironment.debuff_color_override = function(other_cuf_frame)
          local checked_aura = C_UnitAuras_GetAuraDataByAuraInstanceID(other_cuf_frame.unit, auraInstanceID)
          if checked_aura then
            set_statusbar_to_dispel_color(other_cuf_frame.healthBar, checked_aura.dispelName)
            return true
          end
        end
        -- The health bar will change color to match the dispel colour.
        set_statusbar_to_dispel_color(cuf_frame.healthBar, aura.dispelName)

        is_dispel_type = true
        -- Stop iterating because the healthbar can only have one colour at a time. :P
        return true
      end
      -- Continue the iteration.
      return false
    end)

    if is_dispel_type then
      return
    end
    -- If no dispel type is found, update the health color. UpdateColor is the same function that is securehooked to CompactUnitFrame_UpdateHealthColor.
    HealthColor:UpdateColor(cuf_frame)
  end

  addon:IterateRoster(on_dispel_type_changed, true)

  callback_id = CR:RegisterCallback("DISPEL_TYPE_CHANGED", on_dispel_type_changed)
end

function module:OnDisable()
  CR:UnregisterCallback("DISPEL_TYPE_CHANGED", callback_id)
  local function restore_color(cuf_frame)
    cuf_frame.RFS_FrameEnvironment.debuff_color_override = nil
    HealthColor:UpdateColor(cuf_frame)
  end
  addon:IterateRoster(restore_color, true)
end
