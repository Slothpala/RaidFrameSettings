--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("RaidMark")

--------------------
--- Libs & Utils ---
--------------------
local CR = addonTable.CallbackRegistry

------------------------
--- Speed references ---
------------------------

-- WoW Api
local GetRaidTargetIndex = GetRaidTargetIndex

local update_frame_env_callback_id
function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.RaidMark)

  local function create_or_update_raid_marker(cuf_frame)
    -- Create the raid marker frame
    if not cuf_frame.RFS_FrameEnvironment.raid_marker_frame then
      local raid_marker_frame = CreateFrame("Frame")
      raid_marker_frame:SetParent(cuf_frame)
      raid_marker_frame:SetSize(28, 28)
      raid_marker_frame:SetPoint(db_obj.point, cuf_frame, db_obj.relative_point, db_obj.offset_x, db_obj.offset_y)
      raid_marker_frame:SetScale(db_obj.scale_factor)
      local texture = raid_marker_frame:CreateTexture()
      texture:SetAllPoints(raid_marker_frame)
      texture:SetDrawLayer("OVERLAY")
      raid_marker_frame.texture = texture
      cuf_frame.RFS_FrameEnvironment.raid_marker_frame = raid_marker_frame
    end
    -- Function to update the raid marker
    local function update_raid_marker()
      local unit = cuf_frame.unit
      if not UnitExists(unit) then
        return
      end
      local raid_target_index = GetRaidTargetIndex(unit)
      local texture = cuf_frame.RFS_FrameEnvironment.raid_marker_frame.texture
      if raid_target_index then
        local texture_path = "Interface\\TargetingFrame\\UI-RaidTargetingIcons"
        local left, right, top, bottom = _G["UnitPopupRaidTarget" .. raid_target_index .. "ButtonMixin"]:GetTextureCoords()
        texture:SetTexture(texture_path, nil, nil, "TRILINEAR")
        texture:SetTexCoord(left, right, top, bottom)
        texture:Show()
      else
        texture:Hide()
      end
    end
    -- Register the update event.
    local raid_marker_frame = cuf_frame.RFS_FrameEnvironment.raid_marker_frame
    raid_marker_frame:Show() -- In case it was disabled before.
    raid_marker_frame:UnregisterAllEvents()
    raid_marker_frame:SetScript("OnEvent", update_raid_marker)
    raid_marker_frame:RegisterEvent("RAID_TARGET_UPDATE")
    -- Update immediately
    update_raid_marker()
  end

  -- Place the callback in the callback table.
  addonTable.on_create_frame_env_callbacks["RaidMark"] = create_or_update_raid_marker
  update_frame_env_callback_id = CR:RegisterCallback("FRAME_ENV_UPDATED", create_or_update_raid_marker)

  addon:IterateRoster(function(cuf_frame)
    create_or_update_raid_marker(cuf_frame)
    -- This is needed when updating it through the menu.
    local raid_marker_frame = cuf_frame.RFS_FrameEnvironment.raid_marker_frame
    raid_marker_frame:ClearAllPoints()
    raid_marker_frame:SetPoint(db_obj.point, cuf_frame, db_obj.relative_point, db_obj.offset_x, db_obj.offset_y)
    raid_marker_frame:SetScale(db_obj.scale_factor)
  end, true)

end

function module:OnDisable()
  -- Remove the callback in the callback table.
  addonTable.on_create_frame_env_callbacks["RaidMark"] = nil
  -- Unregister the callback
  CR:UnregisterCallback("FRAME_ENV_UPDATED", update_frame_env_callback_id)
  -- Hide all raid marker frames
  local function disable_raid_marker(cuf_frame)
    local raid_marker_frame = cuf_frame.RFS_FrameEnvironment.raid_marker_frame
    if not raid_marker_frame then
      -- skip
    else
      raid_marker_frame:UnregisterAllEvents()
      raid_marker_frame:Hide()
    end
  end
  addon:IterateRoster(disable_raid_marker, true)
end
