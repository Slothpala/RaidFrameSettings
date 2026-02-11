local addon_name, private = ...
local addon = _G[addon_name]

local module = addon:CreateModule("Range")

function module:OnEnable()
  local db_obj = CopyTable(addon.db.profile.module_data.Range)

  local oor_alpha = db_obj.out_of_range_alpha

  local function update_in_range(cuf_frame)
    local is_oor = cuf_frame.outOfRange
    if is_oor == nil then
      return
    end

    cuf_frame:SetAlphaFromBoolean(is_oor, oor_alpha, 1)
  end

  module.update_function = update_in_range

  self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateInRange", update_in_range)

  private.IterateRoster(update_in_range)
  private.IterateMiniRoster(update_in_range)
end

function module:OnDisable()

end
