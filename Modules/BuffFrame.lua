--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("BuffFrame")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)
local Media = LibStub("LibSharedMedia-3.0")
local CR = addonTable.CallbackRegistry

local hidden_frame = CreateFrame("Frame")
local callback_id
function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.BuffFrame)
  local db_obj_font_duration = CopyTable(addon.db.profile.BuffFrameDurationFont)
  local db_obj_font_stack = CopyTable(addon.db.profile.BuffFrameStackFont)
  -- Fetch DB values
  local path_to_duration_font = Media:Fetch("font", db_obj_font_duration.font)
  local path_to_stack_font = Media:Fetch("font", db_obj_font_stack.font)

  -- AuraFrame options
  local aura_frame_options = {
    -- Position
    anchor_point = db_obj.point,
    relative_point = db_obj.relative_point,
    offset_x = db_obj.offset_x,
    offset_y = db_obj.offset_y,
    -- Num indicators row*column
    num_indicators_per_row = db_obj.num_indicators_per_row,
    num_indicators_per_column = db_obj.num_indicators_per_column,
    -- Orientation
    direction_of_growth_vertical = db_obj.direction_of_growth_vertical,
    vertical_padding = db_obj.vertical_padding,
    direction_of_growth_horizontal = db_obj.direction_of_growth_horizontal,
    horizontal_padding = db_obj.horizontal_padding,
    -- Indicator size
    indicator_width = db_obj.indicator_width,
    indicator_height = db_obj.indicator_height,
    -- Indicator border
    indicator_border_thickness = db_obj.indicator_border_thickness,
    indicator_border_color = db_obj.indicator_border_color,
    -- Font: Duration
    path_to_duration_font = path_to_duration_font,
    duration_font_size = db_obj_font_duration.font_size,
    duration_font_outlinemode = db_obj_font_duration.font_outlinemode,
    duration_font_color = db_obj_font_duration.text_color,
    duration_font_point = db_obj_font_duration.point,
    duration_font_relative_point = db_obj_font_duration.relative_point,
    duration_font_offset_x = db_obj_font_duration.offset_x,
    duration_font_offset_y = db_obj_font_duration.offset_y,
    duration_font_shadow_color =  db_obj_font_duration.shadow_color,
    duration_font_shadow_offset_x = db_obj_font_duration.shadow_offset_x,
    duration_font_shadow_offset_y = db_obj_font_duration.shadow_offset_y,
    duration_font_horizontal_justification = db_obj_font_duration.horizontal_justification,
    duration_font_vertical_justification = db_obj_font_duration.vertical_justification,
    -- Font: Stack
    path_to_stack_font = path_to_stack_font,
    stack_font_size = db_obj_font_stack.font_size,
    stack_font_outlinemode = db_obj_font_stack.font_outlinemode,
    stack_font_color = db_obj_font_stack.text_color,
    stack_font_point = db_obj_font_stack.point,
    stack_font_relative_point = db_obj_font_stack.relative_point,
    stack_font_offset_x = db_obj_font_stack.offset_x,
    stack_font_offset_y = db_obj_font_stack.offset_y,
    stack_font_shadow_color =  db_obj_font_stack.shadow_color,
    stack_font_shadow_offset_x = db_obj_font_stack.shadow_offset_x,
    stack_font_shadow_offset_y = db_obj_font_stack.shadow_offset_y,
    stack_font_horizontal_justification = db_obj_font_stack.horizontal_justification,
    stack_font_vertical_justification = db_obj_font_stack.vertical_justification,
    -- Cooldown
    show_swipe = db_obj.show_swipe,
    reverse_swipe = db_obj.reverse_swipe,
    show_edge = db_obj.show_edge,
    show_cooldown_numbers = db_obj.show_cooldown_numbers,
    -- Tooltip
    show_tooltip = db_obj.show_tooltip
  }

  -- Create a callback to create an aura frame when a new frame env is created.
  local function create_or_update_buff_frame(cuf_frame)
    if not cuf_frame.RFS_FrameEnvironment.aura_frames["BuffFrame"] then
      cuf_frame.RFS_FrameEnvironment.aura_frames["BuffFrame"] = addon:NewAuraFrame(cuf_frame)
    end
    cuf_frame.RFS_FrameEnvironment.aura_frames["BuffFrame"]:Enable(aura_frame_options)
  end
  -- Place the callback in the callback table.
  addonTable.on_create_frame_env_callbacks["BuffFrame"] = create_or_update_buff_frame

  -- Handle buff changes
  -- The buffs table contains all buffs that are not placed in an aura group.
  local function on_buffs_changed(cuf_frame)
    cuf_frame.RFS_FrameEnvironment.aura_frames["BuffFrame"]:Update(cuf_frame.RFS_FrameEnvironment.grouped_auras["BuffFrame"])
  end
  -- Update the lists
  addon:UpdateBuffBlacklist()
  addon:UpdateGlowAuraList()
  addon:UpdateWhitelist()
  -- Register the BUFFS_CHANGED callback
  callback_id = CR:RegisterCallback("BuffFrame", on_buffs_changed)

  -- Hide the default buff frame.
  local function hide_default_buff_frame(cuf_frame)
    --[[
      ClearAllPoints will not work once the frame is anchored and set up.
      Since this addon supports profiles, proper enabling and disabling is crucial for it to work.
      This workaround is much more efficient than hiding all individual frames on each SetBuff.
    ]]
    cuf_frame.buffFrames[1]:ClearAllPoints()
    cuf_frame.buffFrames[1]:SetAllPoints(hidden_frame)
  end
  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", hide_default_buff_frame)

  -- Apply the changes to all frames currently displayed.
  addon:IterateRoster(function(cuf_frame)
    create_or_update_buff_frame(cuf_frame)
    if cuf_frame.unit and cuf_frame:IsVisible() then
      addon:CreateOrUpdateAuraScanner(cuf_frame)
    end
    hide_default_buff_frame(cuf_frame)
    --[[
      The buffFrame cooldown frame would sometimes leave visual artifacts on the frame even when the buffFrame was not visible.
      This workaround prevents the cooldown from drawing a swipe texture in the first place.
    ]]
    for i=1, #cuf_frame.buffFrames do
      cuf_frame.buffFrames[i].cooldown:SetDrawSwipe(false)
    end
    on_buffs_changed(cuf_frame)
  end, true)
end

function module:OnDisable()
  self:DisableHooks()
  -- Remove the callback in the callback table.
  addonTable.on_create_frame_env_callbacks["BuffFrame"] = nil
  -- Unregister the callback
  CR:UnregisterCallback("BuffFrame", callback_id)
  -- Update the lists
  addon:UpdateBuffBlacklist()
  addon:UpdateGlowAuraList()
  addon:UpdateWhitelist()
  -- Hide the addons buff frames and show blizzards default buff frame.
  local function show_default_buff_frame(cuf_frame)
    local is_power_bar_showing = cuf_frame.powerBar and cuf_frame.powerBar:IsShown()
    local power_bar_used_height = is_power_bar_showing and 8 or 0
    cuf_frame.buffFrames[1]:ClearAllPoints()
    cuf_frame.buffFrames[1]:SetPoint("BOTTOMRIGHT", cuf_frame, "BOTTOMRIGHT", -3, CUF_AURA_BOTTOM_OFFSET + power_bar_used_height)
    for i=1, #cuf_frame.buffFrames do
      cuf_frame.buffFrames[i].cooldown:SetDrawSwipe(true)
    end
  end
  -- Apply the changes to all frames currently displayed.
  addon:IterateRoster(function(cuf_frame)
    show_default_buff_frame(cuf_frame)
    cuf_frame.RFS_FrameEnvironment.aura_frames["BuffFrame"]:Disable()
  end, true)
end

