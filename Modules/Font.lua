--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("Font")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)
local Media = LibStub("LibSharedMedia-3.0")
local UnitCache = addonTable.UnitCache

------------------------
--- Speed references ---
------------------------

-- Lua

-- WoW Api
local UnitIsPlayer = UnitIsPlayer
local UnitGUID = UnitGUID

function module:OnEnable()
  addon:UpdateNicknames()
  -- Get the database object
  local db_obj_name = CopyTable(addon.db.profile.NameFont)
  local db_obj_status = CopyTable(addon.db.profile.StatusFont)
  -- Fetch the actual data
  local path_to_name_font = Media:Fetch("font", db_obj_name.font)
  local path_to_status_font = Media:Fetch("font", db_obj_status.font)

  local function on_frame_setup(cuf_frame)
    -- Name
    local name_text = cuf_frame.name
    name_text:ClearAllPoints()
    name_text:SetPoint(db_obj_name.point, cuf_frame, db_obj_name.relative_point, db_obj_name.offset_x, db_obj_name.offset_y)
    name_text:SetFont(path_to_name_font, db_obj_name.font_size, db_obj_name.font_outlinemode)
    name_text:SetJustifyH(db_obj_name.horizontal_justification)
    name_text:SetJustifyV(db_obj_name.vertical_justification)
    name_text:SetShadowColor(db_obj_name.shadow_color[1], db_obj_name.shadow_color[2], db_obj_name.shadow_color[3], db_obj_name.shadow_color[4])
    name_text:SetShadowOffset(db_obj_name.shadow_offset_x, db_obj_name.shadow_offset_y)
    -- Status
    local status_text = cuf_frame.statusText
    status_text:ClearAllPoints()
    status_text:SetPoint(db_obj_status.point, cuf_frame, db_obj_status.relative_point, db_obj_status.offset_x, db_obj_status.offset_y)
    status_text:SetFont(path_to_status_font, db_obj_status.font_size, db_obj_status.font_outlinemode)
    status_text:SetJustifyH(db_obj_status.horizontal_justification)
    status_text:SetJustifyV(db_obj_status.vertical_justification)
    status_text:SetShadowColor(db_obj_status.shadow_color[1], db_obj_status.shadow_color[2], db_obj_status.shadow_color[3], db_obj_status.shadow_color[4])
    status_text:SetShadowOffset(db_obj_status.shadow_offset_x, db_obj_status.shadow_offset_y)
    local staus_text_color
    if db_obj_status.class_colored then
      local guid = UnitGUID(cuf_frame.unit)
      local unit_cache = UnitCache:Get(guid)
      staus_text_color = addonTable.colors.class_colors[unit_cache.class].normal_color
    else
      staus_text_color = db_obj_status.text_color
    end
    status_text:SetTextColor(staus_text_color[1], staus_text_color[2], staus_text_color[3])
  end

  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", on_frame_setup)

  local function on_update_name(cuf_frame)
    local is_player = UnitIsPlayer(cuf_frame.unit) or UnitInPartyIsAI(cuf_frame.unit)
    if not is_player then
      return
    end
    local guid = UnitGUID(cuf_frame.unit)
    local unit_cache = UnitCache:Get(guid)
    local name_text = cuf_frame.name
    name_text:SetText(unit_cache.nickname) -- nickname defaults to name if not set.
    if db_obj_name.class_colored then
      local class_color = addonTable.colors.class_colors[unit_cache.class].normal_color
      name_text:SetTextColor(class_color[1], class_color[2], class_color[3])
    else
      name_text:SetTextColor(db_obj_name.text_color[1], db_obj_name.text_color[2], db_obj_name.text_color[3])
    end
  end

  self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateName", on_update_name)

  addon:IterateRoster(function(cuf_frame)
    if cuf_frame.unit then
      on_frame_setup(cuf_frame)
      on_update_name(cuf_frame)
    end
  end)
end

--- The values are from CompactUnitFrame.lua > DefaultCompactUnitFrameSetup()
function module:OnDisable()
  self:DisableHooks()
  local function restore_fonts(cuf_frame)
    if not cuf_frame.unit then
      return
    end
    local guid = UnitGUID(cuf_frame.unit)
    local unit_cache = UnitCache:Get(guid)
    -- Name
    local name_text = cuf_frame.name
    name_text:ClearAllPoints()
    name_text:SetPoint("TOPLEFT", cuf_frame.roleIcon, "TOPRIGHT", 0, -1)
    name_text:SetFont("Fonts\\FRIZQT__.TTF", 10,"NONE")
    name_text:SetJustifyH("LEFT")
    name_text:SetJustifyV("MIDDLE")
    name_text:SetShadowColor(0, 0, 0, 1)
    name_text:SetShadowOffset(1, -1)
    name_text:SetTextColor(1, 1, 1, 1)
    local realm_name = GetRealmName()
    if unit_cache.realm == realm_name then
      name_text:SetText(unit_cache.name)
    else
      name_text:SetText(unit_cache.name_and_realm_name)
    end
    -- Status
    local status_text = cuf_frame.statusText
    local frame_height = EditModeManagerFrame:GetRaidFrameHeight(cuf_frame.groupType)
    local frame_width = EditModeManagerFrame:GetRaidFrameWidth(cuf_frame.groupType)
    local component_scale = min(frame_height / NATIVE_UNIT_FRAME_HEIGHT, frame_width / NATIVE_UNIT_FRAME_WIDTH)
    status_text:ClearAllPoints()
    status_text:SetPoint("BOTTOMLEFT", cuf_frame, "BOTTOMLEFT", 3, frame_height / 3 - 2)
    status_text:SetPoint("BOTTOMRIGHT", cuf_frame, "BOTTOMRIGHT", -3, frame_height / 3 - 2)
    status_text:SetFont("Fonts\\FRIZQT__.TTF", 12 * component_scale, "NONE")
    status_text:SetJustifyH("CENTER")
    status_text:SetJustifyV("MIDDLE")
    status_text:SetShadowColor(0, 0, 0, 1)
    status_text:SetShadowOffset(1, -1)
    status_text:SetTextColor(0.5, 0.5, 0.5, 1)
    status_text:SetHeight(12 * component_scale)
  end
  addon:IterateRoster(restore_fonts)
end

