--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("DebuffFrame")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)
local Media = LibStub("LibSharedMedia-3.0")
local CR = addonTable.CallbackRegistry

------------------------
--- Speed references ---
------------------------

-- Lua
local next = next
-- WoW Api
local AuraUtil_IsPriorityDebuff = AuraUtil.IsPriorityDebuff
local TableUtil_CreatePriorityTable = TableUtil.CreatePriorityTable
local AuraUtil_UnitFrameDebuffComparator = AuraUtil.UnitFrameDebuffComparator
local TableUtil_Constants_AssociativePriorityTable = TableUtil.Constants.AssociativePriorityTable
local C_UnitAuras_RemovePrivateAuraAnchor = C_UnitAuras.RemovePrivateAuraAnchor
local C_UnitAuras_AddPrivateAuraAnchor = C_UnitAuras.AddPrivateAuraAnchor

local hidden_frame = CreateFrame("Frame")
local callback_id
function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.DebuffFrame)
  local db_obj_font_duration = CopyTable(addon.db.profile.DebuffFrameDurationFont)
  local db_obj_font_stack = CopyTable(addon.db.profile.DebuffFrameStackFont)
  -- Fetch DB values
  local path_to_duration_font = Media:Fetch("font", db_obj_font_duration.font)
  local path_to_stack_font = Media:Fetch("font", db_obj_font_stack.font)

  -- Increased Auras
  local increased_auras = {}
  for spell_id, value in next, db_obj.increased_auras do
    if value == true then
      increased_auras[tonumber(spell_id)] = true
    end
  end

  local on_set_debuff = nil
  if db_obj.indicator_border_by_dispel_color and db_obj.duration_font_by_dispel_color then
    on_set_debuff = function(rfs_aura_indicator, aura)
      local border_color = aura.dispelName and addonTable.colors.dispel_type_colors[aura.dispelName].normal_color or db_obj.indicator_border_color
      rfs_aura_indicator:SetBorderColor(border_color[1], border_color[2], border_color[3])
      local duration_font_color = aura.dispelName and addonTable.colors.dispel_type_colors[aura.dispelName].normal_color or db_obj_font_duration.text_color
      rfs_aura_indicator:SetDurationColor(duration_font_color[1], duration_font_color[2], duration_font_color[3])
      if aura.isBossAura or increased_auras[aura.spellId] then
        rfs_aura_indicator:SetScale(db_obj.increase_factor)
      else
        rfs_aura_indicator:SetScale(1)
      end
    end
  elseif db_obj.indicator_border_by_dispel_color then
    on_set_debuff = function(rfs_aura_indicator, aura)
      local border_color = aura.dispelName and addonTable.colors.dispel_type_colors[aura.dispelName].normal_color or db_obj.indicator_border_color
      rfs_aura_indicator:SetBorderColor(border_color[1], border_color[2], border_color[3])
      if aura.isBossAura or increased_auras[aura.spellId] then
        rfs_aura_indicator:SetScale(db_obj.increase_factor)
      else
        rfs_aura_indicator:SetScale(1)
      end
    end
  elseif db_obj.duration_font_by_dispel_color then
    on_set_debuff = function(rfs_aura_indicator, aura)
      local duration_font_color = aura.dispelName and addonTable.colors.dispel_type_colors[aura.dispelName].normal_color or db_obj_font_duration.text_color
      rfs_aura_indicator:SetDurationColor(duration_font_color[1], duration_font_color[2], duration_font_color[3])
      if aura.isBossAura or increased_auras[aura.spellId] then
        rfs_aura_indicator:SetScale(db_obj.increase_factor)
      else
        rfs_aura_indicator:SetScale(1)
      end
    end
  end

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
    on_set_aura_callback = on_set_debuff,
    show_cooldown_numbers = db_obj.show_cooldown_numbers,
    -- Tooltip
    show_tooltip = db_obj.show_tooltip
  }

  -- Create a callback to create an aura frame when a new frame env is created.
  local function create_or_update_debuff_frame(cuf_frame)
    if not cuf_frame.RFS_FrameEnvironment.aura_frames["DebuffFrame"] then
      cuf_frame.RFS_FrameEnvironment.aura_frames["DebuffFrame"] = addon:NewAuraFrame(cuf_frame)
    end
    cuf_frame.RFS_FrameEnvironment.aura_frames["DebuffFrame"]:Enable(aura_frame_options)
    -- Private Aura Anchors
    for i, priv_indicator in next, cuf_frame.RFS_FrameEnvironment.private_aura_indicators do
      if priv_indicator.anchor_id then
        C_UnitAuras_RemovePrivateAuraAnchor(priv_indicator.anchor_id)
      end
      local anchor_options = {
        unitToken = cuf_frame.unit or "player", -- The function also applies to not cuf_frame:IsVisible() frames that do not have a unit. They get player as a placeholder.
        auraIndex = i,
        parent = cuf_frame,
        showCountdownFrame = db_obj.show_swipe,
        showCountdownNumbers = false,
        iconInfo = {
          iconWidth = db_obj.indicator_width - (2 * db_obj.indicator_border_thickness),
          iconHeight = db_obj.indicator_height - (2 * db_obj.indicator_border_thickness),
          iconAnchor = {
            point = "CENTER",
            relativeTo = priv_indicator,
            relativePoint = "CENTER",
            offsetX = 0,
            offsetY = 0,
          },
        },
        durationAnchor = {
          point = db_obj_font_duration.point,
          relativeTo = priv_indicator,
          relativePoint = db_obj_font_duration.relative_point,
          offsetX = db_obj_font_duration.offset_x,
          offsetY = db_obj_font_duration.offset_y,
        },
      }
      if i == 1 then
        priv_indicator:SetPoint(db_obj.priv_point, cuf_frame, db_obj.priv_relative_point)
      else
        priv_indicator:SetPoint("LEFT", cuf_frame.RFS_FrameEnvironment.private_aura_indicators[i-1], "RIGHT")
      end
      priv_indicator:SetSize(db_obj.indicator_width, db_obj.indicator_height)
      priv_indicator.border:SetAllPoints(priv_indicator)
      priv_indicator.border:SetVertexColor(db_obj.indicator_border_color[1], db_obj.indicator_border_color[2], db_obj.indicator_border_color[3])
      priv_indicator.anchor_id = C_UnitAuras_AddPrivateAuraAnchor(anchor_options)
    end

  end
  -- Place the callback in the callback table.
  addonTable.on_create_frame_env_callbacks["DebuffFrame"] = create_or_update_debuff_frame

  -- Handle debuff changes
  -- The debuff table contains all buffs that are not placed in an aura group.
  local on_debuffs_changed
  if db_obj.show_only_raid_auras then
    on_debuffs_changed = function(cuf_frame)
      local debuff_table = TableUtil_CreatePriorityTable(AuraUtil_UnitFrameDebuffComparator, TableUtil_Constants_AssociativePriorityTable)
      cuf_frame.RFS_FrameEnvironment.grouped_auras["DebuffFrame"]:Iterate(function(auraInstanceID, aura)
        if db_obj.watchlist[aura.spellId] or aura.isRaid or aura.isBossAura or AuraUtil_IsPriorityDebuff(aura.spellId) then
          debuff_table[auraInstanceID] = aura
        end
      end)
      cuf_frame.RFS_FrameEnvironment.aura_frames["DebuffFrame"]:Update(debuff_table)
    end
  else
    on_debuffs_changed = function(cuf_frame)
      cuf_frame.RFS_FrameEnvironment.aura_frames["DebuffFrame"]:Update(cuf_frame.RFS_FrameEnvironment.grouped_auras["DebuffFrame"])
    end
  end
  -- Update lists
  addon:UpdateDebuffBlacklist()
  addon:UpdateGlowAuraList()
  -- Register the DEBUFFS_CHANGED callback
  callback_id = CR:RegisterCallback("DebuffFrame", on_debuffs_changed)

  -- Hide the default debuff frame.
  local function hide_default_debuff_frame(cuf_frame)
    --[[
      ClearAllPoints will not work once the frame is anchored and set up.
      Since this addon supports profiles, proper enabling and disabling is crucial for it to work.
      This workaround is much more efficient than hiding all individual frames on each SetBuff.
    ]]
    cuf_frame.debuffFrames[1]:ClearAllPoints()
    cuf_frame.debuffFrames[1]:SetAllPoints(hidden_frame)
  end
  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", hide_default_debuff_frame)

  -- On reload this has to be done even before the frame_env exist.
  addon:IterateRoster(function(cuf_frame)
    --[[
      The debuffFrame cooldown frame would sometimes leave visual artifacts on the frame even when the debuffFrame was not visible.
      This workaround prevents the cooldown from drawing a swipe texture in the first place.
    ]]
    hide_default_debuff_frame(cuf_frame)
    for i=1, #cuf_frame.debuffFrames do
      cuf_frame.debuffFrames[i].cooldown:SetDrawSwipe(false)
    end
  end)

  -- Apply the changes to all frames currently displayed.
  addon:IterateRoster(function(cuf_frame)
    create_or_update_debuff_frame(cuf_frame)
    if cuf_frame.unit and cuf_frame:IsVisible() then
      addon:CreateOrUpdateAuraScanner(cuf_frame)
    end
    on_debuffs_changed(cuf_frame)
  end, true)
end

function module:OnDisable()
  self:DisableHooks()
  -- Remove the callback in the callback table.
  addonTable.on_create_frame_env_callbacks["DebuffFrame"] = nil
  -- Unregister the callback
  CR:UnregisterCallback("DebuffFrame", callback_id)
  -- Hide the addons buff frames and show blizzards default buff frame.
  local function show_default_debuff_frame(cuf_frame)
    local is_power_bar_showing = cuf_frame.powerBar and cuf_frame.powerBar:IsShown()
    local power_bar_used_height = is_power_bar_showing and 8 or 0
    cuf_frame.debuffFrames[1]:ClearAllPoints()
    cuf_frame.debuffFrames[1]:SetPoint("BOTTOMLEFT", cuf_frame, "BOTTOMLEFT", 3, CUF_AURA_BOTTOM_OFFSET + power_bar_used_height)
    for i=1, #cuf_frame.debuffFrames do
      cuf_frame.debuffFrames[i].cooldown:SetDrawSwipe(true)
    end
  end
  -- Apply the changes to all frames currently displayed.
  addon:IterateRoster(function(cuf_frame)
    show_default_debuff_frame(cuf_frame)
    cuf_frame.RFS_FrameEnvironment.aura_frames["DebuffFrame"]:Disable()
    -- Private Aura Anchors
    for _, priv_indicator in next, cuf_frame.RFS_FrameEnvironment.private_aura_indicators do
      if priv_indicator.anchor_id then
        C_UnitAuras_RemovePrivateAuraAnchor(priv_indicator.anchor_id)
      end
    end
  end, true)
end

