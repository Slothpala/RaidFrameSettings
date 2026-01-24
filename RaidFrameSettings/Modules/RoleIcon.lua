-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("RoleIcon")

-- Setup the module.
function module:OnEnable()
  local db_obj = CopyTable(addon.db.profile.module_data.RoleIcon)

  local function update_pos(cuf_frame)
    local role_icon = cuf_frame.roleIcon
    if not role_icon then
      return
    end
    role_icon:ClearAllPoints()
    role_icon:SetPoint(db_obj.point, cuf_frame, db_obj.relative_point, db_obj.offset_x, db_obj.offset_y)
  end
  module.update_function = update_pos

  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", update_pos)
  private.IterateRoster(update_pos)
end

function module:OnDisable()

end
