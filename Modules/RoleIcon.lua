--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("RoleIcon")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)

------------------------
--- Speed references ---
------------------------

-- WoW Api
local UnitGroupRolesAssigned = UnitGroupRolesAssigned


function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.RoleIcon)
  -- Callback
  local function update_role_icon_position_and_visibility(cuf_frame)
    if not cuf_frame.roleIcon then
      return
    end
    -- The unit and the displayedUnit differ, for example, when a unit is in a vehicle, as in Wintergrasp BG.
    local role = UnitGroupRolesAssigned(cuf_frame.displayedUnit)
    local should_hide_icon = ( role == "DAMAGER" and not db_obj.show_for_dps ) or ( role == "HEALER" and not db_obj.show_for_heal ) or ( role == "TANK" and not db_obj.show_for_tank )
    if should_hide_icon then
      cuf_frame.roleIcon:Hide()
      return
    end

    cuf_frame.roleIcon:ClearAllPoints()
    cuf_frame.roleIcon:SetPoint(db_obj.point, cuf_frame, db_obj.relative_point, db_obj.offset_x, db_obj.offset_y)
    cuf_frame.roleIcon:SetScale(db_obj.scale_factor)
  end
  --Hook
  self:HookFunc("CompactUnitFrame_UpdateRoleIcon", update_role_icon_position_and_visibility)
  addon:IterateRoster(update_role_icon_position_and_visibility)
end

function module:OnDisable()
  self:DisableHooks()
  local function restore_role_icon_position_and_visibility(cuf_frame)
    if not cuf_frame.roleIcon then
      return
    end

    cuf_frame.roleIcon:ClearAllPoints()
    cuf_frame.roleIcon:SetPoint("TOPLEFT", 3, -2)
    cuf_frame.roleIcon:SetSize(12, 12)
    cuf_frame.roleIcon:SetScale(1)
    cuf_frame.roleIcon:Show()
  end
  addon:IterateRoster(restore_role_icon_position_and_visibility)
end
