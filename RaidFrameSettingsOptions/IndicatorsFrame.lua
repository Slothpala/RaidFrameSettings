local addon_name, private = ...
local addon = _G["RaidFrameSettings"]
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Position data for the 8 indicator slots.
local INDICATOR_POSITIONS = {
  [1] = { point = "TOPLEFT",     label = L["indicator_position_topleft"],     x =  2, y = -2 },
  [2] = { point = "LEFT",        label = L["indicator_position_left"],        x =  2, y =  0 },
  [3] = { point = "BOTTOMLEFT",  label = L["indicator_position_bottomleft"],  x =  2, y =  2 },
  [4] = { point = "TOP",         label = L["indicator_position_top"],         x =  0, y = -2 },
  [5] = { point = "BOTTOM",      label = L["indicator_position_bottom"],      x =  0, y =  2 },
  [6] = { point = "TOPRIGHT",    label = L["indicator_position_topright"],    x = -2, y = -2 },
  [7] = { point = "RIGHT",       label = L["indicator_position_right"],       x = -2, y =  0 },
  [8] = { point = "BOTTOMRIGHT", label = L["indicator_position_bottomright"], x = -2, y =  2 },
}

-- Ordered class list for the dropdown.
local CLASS_ORDER = {
  "DRUID", "PRIEST", "PALADIN", "SHAMAN", "MONK", "EVOKER",
  "DEATHKNIGHT", "DEMONHUNTER", "HUNTER", "MAGE", "ROGUE", "WARLOCK", "WARRIOR",
}

-- Class color data (r, g, b) matching WoW class colors.
local CLASS_COLORS = {
  DEATHKNIGHT = { 0.77, 0.12, 0.23 },
  DEMONHUNTER = { 0.64, 0.19, 0.79 },
  DRUID       = { 1.00, 0.49, 0.04 },
  EVOKER      = { 0.20, 0.58, 0.50 },
  HUNTER      = { 0.67, 0.83, 0.45 },
  MAGE        = { 0.25, 0.78, 0.92 },
  MONK        = { 0.00, 1.00, 0.60 },
  PALADIN     = { 0.96, 0.55, 0.73 },
  PRIEST      = { 1.00, 1.00, 1.00 },
  ROGUE       = { 1.00, 0.96, 0.41 },
  SHAMAN      = { 0.00, 0.44, 0.87 },
  WARLOCK     = { 0.53, 0.53, 0.93 },
  WARRIOR     = { 0.78, 0.61, 0.43 },
}

-- The container frame for the Indicators tab content.
local indicators_frame = nil
local spell_popup = nil
local selected_class = select(2, UnitClass("player")) or "DRUID"
local DEFAULT_FRAME_SIZE = { width = 72, height = 36 }
local PREVIEW_FRAME_SIZE = { width = 216, height = 108 }

local CLASS_IDS = {
  WARRIOR = 1,
  PALADIN = 2,
  HUNTER = 3,
  ROGUE = 4,
  PRIEST = 5,
  DEATHKNIGHT = 6,
  SHAMAN = 7,
  MAGE = 8,
  WARLOCK = 9,
  MONK = 10,
  DRUID = 11,
  DEMONHUNTER = 12,
  EVOKER = 13,
}

-- ========================================
-- Helper: Get class indicators table for selected class
-- ========================================
local function get_class_indicators()
  return addon.db.profile.module_data.AuraIndicators.class_indicators[selected_class]
end

local function get_localized_class_name(class_token)
  local info = C_CreatureInfo.GetClassInfo(CLASS_IDS[class_token])
  return info and info.className or class_token
end

local function get_preview_size()
  return PREVIEW_FRAME_SIZE.width, PREVIEW_FRAME_SIZE.height
end

local function apply_preview_cooldown_settings(cooldown)
  local db = addon.db.profile.module_data.AuraIndicators

  cooldown:SetHideCountdownNumbers(not db.show_cooldown)
  if cooldown.GetCountdownFontString then
    local countdown_string = cooldown:GetCountdownFontString()
    if countdown_string then
      local font_path, _, font_flags = countdown_string:GetFont()
      if font_path then
        countdown_string:SetFont(font_path, db.cooldown_text_size, font_flags)
      end
    end
  end
  if cooldown.SetReverse then
    cooldown:SetReverse(db.cooldown_reverse)
  end
  if cooldown.SetDrawEdge then
    cooldown:SetDrawEdge(db.cooldown_draw_edge)
  end
  if cooldown.SetDrawSwipe then
    cooldown:SetDrawSwipe(db.cooldown_draw_swipe)
  end
  if cooldown.SetDrawBling then
    cooldown:SetDrawBling(db.cooldown_draw_bling)
  end
end

local function get_preview_scale(frame)
  local db = addon.db.profile.module_data.AuraIndicators
  local frame_width = frame:GetWidth()
  local frame_height = frame:GetHeight()
  local base_size = math.min(frame_width or 0, frame_height or 0)
  local indicator_size = db.indicator_size

  if base_size > 0 then
    indicator_size = math.max(4, math.floor((base_size * db.indicator_size / 100) + 0.5))
  end

  return indicator_size / math.max(db.indicator_size, 1), indicator_size
end

local function apply_indicator_slot_layout(slot, index)
  local pos = INDICATOR_POSITIONS[index]
  local db = addon.db.profile.module_data.AuraIndicators
  local preview_scale, indicator_size = get_preview_scale(slot.health_bar)
  local border_size = math.max(0, db.border_size * preview_scale)
  local offset_x = pos.x * preview_scale
  local offset_y = pos.y * preview_scale

  slot:SetSize(indicator_size, indicator_size)
  slot:ClearAllPoints()
  slot:SetPoint(pos.point, slot.health_bar, pos.point, offset_x, offset_y)
  slot:SetHitRectInsets(-4, -4, -4, -4)
  if border_size > 0 then
    slot:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8X8",
      edgeFile = "Interface\\Buttons\\WHITE8X8",
      edgeSize = border_size,
    })
  else
    slot:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8X8",
    })
  end

  slot.icon:ClearAllPoints()
  if border_size > 0 then
    slot.icon:SetPoint("TOPLEFT", slot, "TOPLEFT", border_size, -border_size)
    slot.icon:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -border_size, border_size)
  else
    slot.icon:SetAllPoints(slot)
  end

  if slot.cooldown then
    slot.cooldown:ClearAllPoints()
    slot.cooldown:SetAllPoints(slot.icon)
  end
end

local function reset_spell_popup_content(popup)
  for _, header in ipairs(popup.category_headers) do
    header:Hide()
  end

  for _, row in ipairs(popup.spell_rows) do
    row:Hide()
  end

  if popup.empty_text then
    popup.empty_text:Hide()
  end
end

local function acquire_spell_popup_header(popup, index)
  local header = popup.category_headers[index]
  if not header then
    header = popup.scroll_child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    popup.category_headers[index] = header
  end

  return header
end

local function acquire_spell_popup_row(popup, index)
  local row = popup.spell_rows[index]
  if not row then
    row = CreateFrame("Button", nil, popup.scroll_child)
    row:SetSize(240, 22)

    row.highlight = row:CreateTexture(nil, "HIGHLIGHT")
    row.highlight:SetAllPoints()
    row.highlight:SetColorTexture(1, 1, 1, 0.1)

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(18, 18)
    row.icon:SetPoint("LEFT", row, "LEFT", 2, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.text:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)

    popup.spell_rows[index] = row
  end

  return row
end

-- ========================================
-- Spell Picker Popup
-- ========================================

local function create_spell_popup(parent)
  local popup = CreateFrame("Frame", "RFS_SpellPickerPopup", parent, "BackdropTemplate")
  popup:SetSize(280, 300)
  popup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  popup:SetFrameStrata("FULLSCREEN_DIALOG")
  popup:SetMovable(true)
  popup:EnableMouse(true)
  popup:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
  })
  popup:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
  popup:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

  popup.title_bar = CreateFrame("Frame", nil, popup)
  popup.title_bar:SetPoint("TOPLEFT", popup, "TOPLEFT", 0, 0)
  popup.title_bar:SetPoint("TOPRIGHT", popup, "TOPRIGHT", 0, 0)
  popup.title_bar:SetHeight(28)
  popup.title_bar:EnableMouse(true)
  popup.title_bar:RegisterForDrag("LeftButton")
  popup.title_bar:SetScript("OnDragStart", function() popup:StartMoving() end)
  popup.title_bar:SetScript("OnDragStop", function() popup:StopMovingOrSizing() end)

  popup.title = popup:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  popup.title:SetPoint("TOP", popup, "TOP", 0, -8)
  popup.title:SetText(L["indicator_click_to_assign"])

  popup.close_button = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
  popup.close_button:SetPoint("TOPRIGHT", popup, "TOPRIGHT", -2, -2)
  popup.close_button:SetScript("OnClick", function() popup:Hide() end)

  popup.clear_button = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
  popup.clear_button:SetSize(100, 22)
  popup.clear_button:SetPoint("BOTTOM", popup, "BOTTOM", 0, 8)
  popup.clear_button:SetText(L["indicator_clear"])

  popup.scroll_frame = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
  popup.scroll_frame:SetPoint("TOPLEFT", popup, "TOPLEFT", 8, -32)
  popup.scroll_frame:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -28, 36)

  popup.scroll_child = CreateFrame("Frame", nil, popup.scroll_frame)
  popup.scroll_child:SetWidth(popup.scroll_frame:GetWidth())
  popup.scroll_child:SetHeight(1)
  popup.scroll_frame:SetScrollChild(popup.scroll_child)
  popup.category_headers = {}
  popup.spell_rows = {}
  popup.empty_text = nil

  popup:Hide()
  return popup
end

local function populate_spell_popup(popup, slot_index, on_spell_selected)
  local scroll_child = popup.scroll_child

  reset_spell_popup_content(popup)

  local y_offset = -4
  local spell_data = addon.AuraIndicatorSpells
  local has_entries = false
  local header_index = 1
  local row_index = 1

  for _, category in ipairs(spell_data) do
    if category.class == selected_class then
      has_entries = true

      local header = acquire_spell_popup_header(popup, header_index)
      header:ClearAllPoints()
      header:SetPoint("TOPLEFT", scroll_child, "TOPLEFT", 4, y_offset)
      header:SetText(category.category)
      header:Show()
      header_index = header_index + 1
      y_offset = y_offset - 20

      for _, spell in ipairs(category.spells) do
        local row = acquire_spell_popup_row(popup, row_index)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", scroll_child, "TOPLEFT", 4, y_offset)

        local spell_info = C_Spell.GetSpellInfo(spell.id)
        local spell_name = tostring(spell.id)
        if spell_info and spell_info.iconID then
          row.icon:SetTexture(spell_info.iconID)
          spell_name = spell_info.name or spell_name
        else
          row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        row.text:SetText(spell_name)
        row:SetScript("OnClick", function()
          on_spell_selected(slot_index, spell.id)
          popup:Hide()
        end)
        row:Show()
        row_index = row_index + 1

        y_offset = y_offset - 24
      end

      y_offset = y_offset - 8
    end
  end

  if not has_entries then
    if not popup.empty_text then
      popup.empty_text = scroll_child:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    end
    local empty_text = popup.empty_text
    empty_text:ClearAllPoints()
    empty_text:SetPoint("TOPLEFT", scroll_child, "TOPLEFT", 4, y_offset)
    empty_text:SetText(L["indicator_no_spell"])
    empty_text:Show()
    y_offset = y_offset - 20
  end

  scroll_child:SetHeight(math.abs(y_offset) + 10)

  popup.clear_button:SetScript("OnClick", function()
    on_spell_selected(slot_index, 0, nil)
    popup:Hide()
  end)

  popup.title:SetText(L["indicator_click_to_assign"])
end

-- ========================================
-- Indicators Tab Content Frame
-- ========================================

local function create_indicator_slot(parent, index, health_bar, on_click)
  local slot = CreateFrame("Button", nil, health_bar, "BackdropTemplate")
  slot:SetFrameLevel(health_bar:GetFrameLevel() + 10)
  slot.health_bar = health_bar
  slot:SetBackdropColor(0, 0, 0, 0.6)
  slot:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

  slot.icon = slot:CreateTexture(nil, "ARTWORK")
  slot.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  slot.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
  slot.icon:SetDesaturated(true)
  slot.icon:SetVertexColor(0.5, 0.5, 0.5)

  slot.cooldown = CreateFrame("Cooldown", nil, slot, "CooldownFrameTemplate")
  slot.cooldown:SetAllPoints()

  slot:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
  apply_indicator_slot_layout(slot, index)

  slot:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(INDICATOR_POSITIONS[index].label, 1, 1, 1)
    local indicators = get_class_indicators()
    local spell_id = indicators[index].spell_id
    if spell_id and spell_id > 0 then
      local spell_info = C_Spell.GetSpellInfo(spell_id)
      if spell_info then
        GameTooltip:AddLine(spell_info.name, 0.2, 0.8, 0.2)
      end
    else
      GameTooltip:AddLine(L["indicator_no_spell"], 0.5, 0.5, 0.5)
    end
    GameTooltip:Show()
  end)
  slot:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  slot:SetScript("OnClick", function()
    on_click(index)
  end)

  return slot
end

local function update_slot_display(slot, index)
  local indicators = get_class_indicators()
  local spell_id = indicators[index].spell_id
  local border_color = addon.db.profile.module_data.AuraIndicators.border_color
  slot:SetBackdropBorderColor(unpack(border_color))
  apply_preview_cooldown_settings(slot.cooldown)
  if spell_id and spell_id > 0 then
    local spell_info = C_Spell.GetSpellInfo(spell_id)
    if spell_info and spell_info.iconID then
      slot.icon:SetTexture(spell_info.iconID)
      slot.icon:SetDesaturated(false)
      slot.icon:SetVertexColor(1, 1, 1)
    end
    slot:SetBackdropColor(0, 0, 0, 0.2)
    slot.cooldown:SetCooldown(GetTime() - 6, 18)
  else
    slot.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    slot.icon:SetDesaturated(true)
    slot.icon:SetVertexColor(0.5, 0.5, 0.5)
    slot:SetBackdropColor(0, 0, 0, 0.6)
    slot.cooldown:Clear()
  end
end

local function create_indicator_class_dropdown(parent, on_refresh)
  local class_dropdown = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
  class_dropdown:SetPoint("TOPLEFT", parent, "TOPLEFT", 22, -22)
  class_dropdown:SetWidth(180)

  class_dropdown:SetupMenu(function(dropdown, root_description)
    for _, class_token in ipairs(CLASS_ORDER) do
      local color = CLASS_COLORS[class_token]
      local name = get_localized_class_name(class_token)
      local colored_name = string.format("|cff%02x%02x%02x%s|r",
        color[1] * 255, color[2] * 255, color[3] * 255, name)

      local function is_selected()
        return selected_class == class_token
      end

      local function set_selected()
        selected_class = class_token
        on_refresh()
      end

      root_description:CreateRadio(colored_name, is_selected, set_selected)
    end
  end)

  return class_dropdown
end

local function create_indicator_preview(parent)
  local health_bar = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  health_bar:SetPoint("TOP", parent, "TOP", 0, -90)
  health_bar:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
  })
  health_bar:SetBackdropColor(0.15, 0.15, 0.15, 1)
  health_bar:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

  -- Health fill.
  local fill = health_bar:CreateTexture(nil, "ARTWORK")
  fill:SetPoint("TOPLEFT", health_bar, "TOPLEFT", 1, -1)
  fill:SetPoint("BOTTOMRIGHT", health_bar, "BOTTOMRIGHT", -1, 1)
  fill:SetColorTexture(0.2, 0.6, 0.2, 0.8)

  -- Mock name text.
  local name_text = health_bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  name_text:SetPoint("CENTER", health_bar, "CENTER", 0, 0)
  name_text:SetText("Player")
  name_text:SetTextColor(1, 1, 1)

  return health_bar, fill, name_text
end

local function create_indicator_settings_panel(parent)
  local settings_panel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  settings_panel:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
  })
  settings_panel:SetBackdropColor(0.08, 0.08, 0.08, 0.92)
  settings_panel:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)

  settings_panel.title = settings_panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  settings_panel.title:SetPoint("TOPLEFT", settings_panel, "TOPLEFT", 14, -12)
  settings_panel.title:SetText(L["indicator_preview_options"])

  local settings_scroll = CreateFrame("ScrollFrame", nil, settings_panel)
  settings_scroll:SetPoint("TOPLEFT", settings_panel, "TOPLEFT", 10, -34)
  settings_scroll:SetPoint("BOTTOMRIGHT", settings_panel, "BOTTOMRIGHT", -28, 18)
  settings_scroll:EnableMouseWheel(true)

  local settings_content = CreateFrame("Frame", nil, settings_scroll)
  settings_content:SetSize(1, 1)
  settings_scroll:SetScrollChild(settings_content)

  local settings_scroll_bar = CreateFrame("EventFrame", nil, settings_panel, "MinimalScrollBar")
  settings_scroll_bar:SetPoint("TOPRIGHT", settings_panel, "TOPRIGHT", -10, -8)
  settings_scroll_bar:SetPoint("BOTTOMRIGHT", settings_panel, "BOTTOMRIGHT", -10, 8)
  settings_scroll_bar:SetHideIfUnscrollable(true)
  settings_scroll_bar:SetHideTrackIfThumbExceedsTrack(true)

  local function update_scroll_range()
    settings_scroll:UpdateScrollChildRect()

    local scroll_range = settings_scroll:GetVerticalScrollRange() or 0
    local view_height = settings_scroll:GetHeight() or 0
    local content_height = settings_content:GetHeight() or 0
    local current_scroll = math.min(settings_scroll:GetVerticalScroll() or 0, scroll_range)
    local scroll_percentage = 0
    local visible_extent_percentage = 1

    if scroll_range > 0 then
      scroll_percentage = current_scroll / scroll_range
    end

    if content_height > 0 then
      visible_extent_percentage = math.min(1, view_height / content_height)
    end

    settings_scroll:SetVerticalScroll(current_scroll)
    settings_scroll_bar:SetVisibleExtentPercentage(visible_extent_percentage)
    settings_scroll_bar:SetScrollPercentage(scroll_percentage)
  end

  settings_scroll:SetScript("OnMouseWheel", function(self, delta)
    settings_scroll_bar:ScrollStepInDirection(-delta)
  end)

  settings_scroll:SetScript("OnSizeChanged", update_scroll_range)
  settings_scroll:SetScript("OnVerticalScroll", function(self, offset)
    local scroll_range = self:GetVerticalScrollRange() or 0
    local scroll_percentage = 0

    if scroll_range > 0 then
      scroll_percentage = offset / scroll_range
    end

    settings_scroll_bar:SetScrollPercentage(scroll_percentage)
  end)
  settings_scroll:SetScript("OnScrollRangeChanged", function()
    update_scroll_range()
  end)

  settings_scroll_bar:RegisterCallback(settings_scroll_bar.Event.OnScroll, function(_, scroll_percentage)
    local scroll_range = settings_scroll:GetVerticalScrollRange() or 0
    settings_scroll:SetVerticalScroll(scroll_percentage * scroll_range)
  end)

  settings_panel.scroll = settings_scroll
  settings_panel.scroll_bar = settings_scroll_bar
  settings_panel.content = settings_content
  settings_panel.update_scroll_range = update_scroll_range

  return settings_panel, settings_content
end

local function create_toggle_row(parent, anchor, relative_to, relative_point, x, y, label)
  local row = CreateFrame("Button", nil, parent, "RaidFrameSettings_ToggleTemplate")
  row:SetSize(250, 42)
  row:SetPoint(anchor, relative_to, relative_point, x, y)
  row.settings_text:SetText(label)
  return row
end

local function create_indicator_settings_controls(settings_content, on_refresh)
  local controls = {}

  local size_label = settings_content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  size_label:SetPoint("TOPLEFT", settings_content, "TOPLEFT", 12, -4)
  size_label:SetText(L["indicator_size"])
  controls.size_label = size_label

  local size_slider = CreateFrame("Slider", nil, settings_content, "MinimalSliderTemplate")
  size_slider:SetPoint("TOPLEFT", size_label, "BOTTOMLEFT", 2, -14)
  size_slider:SetSize(190, 16)
  size_slider:SetMinMaxValues(4, 32)
  size_slider:SetValueStep(1)
  size_slider:SetObeyStepOnDrag(true)
  controls.size_slider = size_slider

  local size_value_text = size_slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  size_value_text:SetPoint("LEFT", size_slider, "RIGHT", 8, 0)
  controls.size_value_text = size_value_text

  function controls.init_size_slider()
    local current_size = addon.db.profile.module_data.AuraIndicators.indicator_size
    size_slider:SetValue(current_size)
    size_value_text:SetText(current_size)
  end
  controls.init_size_slider()

  size_slider:SetScript("OnValueChanged", function(_, value)
    local rounded = math.floor(value + 0.5)
    if addon.db.profile.module_data.AuraIndicators.indicator_size == rounded then
      size_value_text:SetText(rounded)
      return
    end
    addon.db.profile.module_data.AuraIndicators.indicator_size = rounded
    size_value_text:SetText(rounded)
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)

  local border_size_label = settings_content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  border_size_label:SetPoint("TOPLEFT", size_slider, "BOTTOMLEFT", -2, -20)
  border_size_label:SetText(L["aura_border_size"])
  controls.border_size_label = border_size_label

  local border_size_slider = CreateFrame("Slider", nil, settings_content, "MinimalSliderTemplate")
  border_size_slider:SetPoint("TOPLEFT", border_size_label, "BOTTOMLEFT", 2, -14)
  border_size_slider:SetSize(190, 16)
  border_size_slider:SetMinMaxValues(0, 3)
  border_size_slider:SetValueStep(0.5)
  border_size_slider:SetObeyStepOnDrag(true)
  controls.border_size_slider = border_size_slider

  local border_size_value_text = border_size_slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  border_size_value_text:SetPoint("LEFT", border_size_slider, "RIGHT", 8, 0)
  controls.border_size_value_text = border_size_value_text

  function controls.init_border_size_slider()
    local current = addon.db.profile.module_data.AuraIndicators.border_size
    border_size_slider:SetValue(current)
    border_size_value_text:SetText(current)
  end
  controls.init_border_size_slider()

  border_size_slider:SetScript("OnValueChanged", function(_, value)
    local rounded = tonumber(string.format("%.1f", value))
    if addon.db.profile.module_data.AuraIndicators.border_size == rounded then
      border_size_value_text:SetText(rounded)
      return
    end
    addon.db.profile.module_data.AuraIndicators.border_size = rounded
    border_size_value_text:SetText(rounded)
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)

  local cooldown_text_size_label = settings_content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  cooldown_text_size_label:SetPoint("TOPLEFT", border_size_slider, "BOTTOMLEFT", -2, -20)
  cooldown_text_size_label:SetText(L["indicator_cooldown_text_size"])
  controls.cooldown_text_size_label = cooldown_text_size_label

  local cooldown_text_size_slider = CreateFrame("Slider", nil, settings_content, "MinimalSliderTemplate")
  cooldown_text_size_slider:SetPoint("TOPLEFT", cooldown_text_size_label, "BOTTOMLEFT", 2, -14)
  cooldown_text_size_slider:SetSize(190, 16)
  cooldown_text_size_slider:SetMinMaxValues(6, 24)
  cooldown_text_size_slider:SetValueStep(1)
  cooldown_text_size_slider:SetObeyStepOnDrag(true)
  controls.cooldown_text_size_slider = cooldown_text_size_slider

  local cooldown_text_size_value_text = cooldown_text_size_slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  cooldown_text_size_value_text:SetPoint("LEFT", cooldown_text_size_slider, "RIGHT", 8, 0)
  controls.cooldown_text_size_value_text = cooldown_text_size_value_text

  function controls.init_cooldown_text_size_slider()
    local current = addon.db.profile.module_data.AuraIndicators.cooldown_text_size
    cooldown_text_size_slider:SetValue(current)
    cooldown_text_size_value_text:SetText(current)
  end
  controls.init_cooldown_text_size_slider()

  cooldown_text_size_slider:SetScript("OnValueChanged", function(_, value)
    local rounded = math.floor(value + 0.5)
    if addon.db.profile.module_data.AuraIndicators.cooldown_text_size == rounded then
      cooldown_text_size_value_text:SetText(rounded)
      return
    end
    addon.db.profile.module_data.AuraIndicators.cooldown_text_size = rounded
    cooldown_text_size_value_text:SetText(rounded)
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)

  local border_color_picker = CreateFrame("Button", nil, settings_content, "RaidFrameSettings_SingleChoiceColorPicker")
  border_color_picker:SetSize(240, 42)
  border_color_picker:SetPoint("TOPLEFT", cooldown_text_size_slider, "BOTTOMLEFT", -2, -28)
  border_color_picker.settings_text:SetText(L["aura_border_color"])
  border_color_picker.color_picker.text:SetText("")
  controls.border_color_picker = border_color_picker

  function controls.update_border_color_swatch()
    local c = addon.db.profile.module_data.AuraIndicators.border_color
    border_color_picker.color_picker.button.background_texture:SetColorTexture(unpack(c))
  end
  controls.update_border_color_swatch()

  border_color_picker.color_picker.button:SetScript("OnClick", function()
    local old_r, old_g, old_b, old_a = unpack(addon.db.profile.module_data.AuraIndicators.border_color)

    local function on_color_changed()
      local r, g, b = ColorPickerFrame:GetColorRGB()
      addon.db.profile.module_data.AuraIndicators.border_color = {r, g, b, old_a}
      controls.update_border_color_swatch()
      on_refresh()
      addon:ReloadModule("AuraIndicators")
    end

    local function on_cancel()
      addon.db.profile.module_data.AuraIndicators.border_color = {old_r, old_g, old_b, old_a}
      controls.update_border_color_swatch()
      on_refresh()
      addon:ReloadModule("AuraIndicators")
    end

    ColorPickerFrame:Hide()
    ColorPickerFrame:SetupColorPickerAndShow({
      swatchFunc = on_color_changed,
      opacityFunc = on_color_changed,
      cancelFunc = on_cancel,
      hasOpacity = false,
      r = old_r,
      g = old_g,
      b = old_b,
      opacity = old_a,
    })
  end)

  local toggles_anchor = CreateFrame("Frame", nil, settings_content)
  toggles_anchor:SetSize(250, 1)
  toggles_anchor:SetPoint("TOPLEFT", settings_content, "TOPLEFT", 260, -4)
  controls.toggles_anchor = toggles_anchor

  local cooldown_row = create_toggle_row(settings_content, "TOPLEFT", toggles_anchor, "TOPLEFT", 0, 0, L["indicator_show_cooldown"])
  local cooldown_check = cooldown_row.toggle
  cooldown_check:SetChecked(addon.db.profile.module_data.AuraIndicators.show_cooldown)
  cooldown_check:SetScript("OnClick", function(self)
    addon.db.profile.module_data.AuraIndicators.show_cooldown = self:GetChecked()
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)
  controls.cooldown_row = cooldown_row
  controls.cooldown_check = cooldown_check

  local reverse_row = create_toggle_row(settings_content, "TOPLEFT", cooldown_row, "BOTTOMLEFT", 0, -4, L["indicator_cooldown_reverse"])
  local reverse_check = reverse_row.toggle
  reverse_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_reverse)
  reverse_check:SetScript("OnClick", function(self)
    addon.db.profile.module_data.AuraIndicators.cooldown_reverse = self:GetChecked()
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)
  controls.reverse_row = reverse_row
  controls.reverse_check = reverse_check

  local draw_edge_row = create_toggle_row(settings_content, "TOPLEFT", reverse_row, "BOTTOMLEFT", 0, -4, L["indicator_cooldown_draw_edge"])
  local draw_edge_check = draw_edge_row.toggle
  draw_edge_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_draw_edge)
  draw_edge_check:SetScript("OnClick", function(self)
    addon.db.profile.module_data.AuraIndicators.cooldown_draw_edge = self:GetChecked()
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)
  controls.draw_edge_row = draw_edge_row
  controls.draw_edge_check = draw_edge_check

  local draw_swipe_row = create_toggle_row(settings_content, "TOPLEFT", draw_edge_row, "BOTTOMLEFT", 0, -4, L["indicator_cooldown_draw_swipe"])
  local draw_swipe_check = draw_swipe_row.toggle
  draw_swipe_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_draw_swipe)
  draw_swipe_check:SetScript("OnClick", function(self)
    addon.db.profile.module_data.AuraIndicators.cooldown_draw_swipe = self:GetChecked()
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)
  controls.draw_swipe_row = draw_swipe_row
  controls.draw_swipe_check = draw_swipe_check

  local draw_bling_row = create_toggle_row(settings_content, "TOPLEFT", draw_swipe_row, "BOTTOMLEFT", 0, -4, L["indicator_cooldown_draw_bling"])
  local draw_bling_check = draw_bling_row.toggle
  draw_bling_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_draw_bling)
  draw_bling_check:SetScript("OnClick", function(self)
    addon.db.profile.module_data.AuraIndicators.cooldown_draw_bling = self:GetChecked()
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)
  controls.draw_bling_row = draw_bling_row
  controls.draw_bling_check = draw_bling_check

  local hide_buffs_row = create_toggle_row(settings_content, "TOPLEFT", draw_bling_row, "BOTTOMLEFT", 0, -12, L["indicator_hide_default_buffs"])
  local hide_buffs_check = hide_buffs_row.toggle
  hide_buffs_check:SetChecked(addon.db.profile.module_data.AuraIndicators.hide_default_buffs)
  hide_buffs_check:SetScript("OnClick", function(self)
    addon.db.profile.module_data.AuraIndicators.hide_default_buffs = self:GetChecked()
    on_refresh()
    addon:ReloadModule("AuraIndicators")
  end)
  controls.hide_buffs_row = hide_buffs_row
  controls.hide_buffs_check = hide_buffs_check

  return controls
end

local function layout_toggle_rows(controls, anchor_frame, anchor_y)
  local rows = {
    controls.cooldown_row,
    controls.reverse_row,
    controls.draw_edge_row,
    controls.draw_swipe_row,
    controls.draw_bling_row,
    controls.hide_buffs_row,
  }

  local previous_row = nil
  for index, row in ipairs(rows) do
    row:ClearAllPoints()
    if index == 1 then
      row:SetPoint("TOPLEFT", anchor_frame, "TOPLEFT", 0, anchor_y)
    else
      local spacing = index == 6 and -12 or -4
      row:SetPoint("TOPLEFT", previous_row, "BOTTOMLEFT", 0, spacing)
    end
    previous_row = row
  end
end

local function layout_indicator_controls(frame, ui)
  local top_offset = 74
  local preview_gap = 22
  local bottom_padding = 20
  local side_padding = 20

  local preview_width, preview_height = get_preview_size()
  local preview_top = -top_offset
  local panel_top = preview_top - preview_height - preview_gap

  ui.health_bar:ClearAllPoints()
  ui.health_bar:SetPoint("TOP", frame, "TOP", 0, preview_top)

  ui.settings_panel:ClearAllPoints()
  ui.settings_panel:SetPoint("TOPLEFT", frame, "TOPLEFT", side_padding, panel_top)
  ui.settings_panel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -side_padding, bottom_padding)

  local panel_width = ui.settings_panel:GetWidth() or 0
  local content_width = math.max(260, panel_width - 60)
  local is_compact_layout = content_width < 520
  ui.settings_content:SetWidth(content_width)
  ui.settings_content:SetHeight(is_compact_layout and 470 or 370)
  ui.settings_panel.update_scroll_range()

  local left_column_width
  local slider_width
  local color_picker_width
  local right_column_x
  local right_column_width

  if is_compact_layout then
    left_column_width = content_width - 16
    slider_width = math.max(120, left_column_width - 44)
    color_picker_width = math.max(210, left_column_width)
    right_column_x = 12
    right_column_width = left_column_width
  else
    left_column_width = math.max(190, math.floor(content_width * 0.42))
    slider_width = math.max(150, left_column_width - 30)
    color_picker_width = math.max(220, left_column_width + 20)
    right_column_x = left_column_width + 40
    right_column_width = math.max(190, content_width - right_column_x - 10)
  end

  ui.controls.size_slider:SetWidth(slider_width)
  ui.controls.border_size_slider:SetWidth(slider_width)
  ui.controls.cooldown_text_size_slider:SetWidth(slider_width)
  ui.controls.border_color_picker:SetSize(color_picker_width, 42)

  ui.controls.toggles_anchor:ClearAllPoints()
  ui.controls.toggles_anchor:SetSize(right_column_width, 1)
  if is_compact_layout then
    ui.controls.toggles_anchor:SetPoint("TOPLEFT", ui.controls.border_color_picker, "BOTTOMLEFT", 0, -22)
    layout_toggle_rows(ui.controls, ui.controls.toggles_anchor, 0)
  else
    ui.controls.toggles_anchor:SetPoint("TOPLEFT", ui.settings_content, "TOPLEFT", right_column_x, -4)
    layout_toggle_rows(ui.controls, ui.controls.toggles_anchor, 0)
  end

  for _, row in ipairs({
    ui.controls.cooldown_row,
    ui.controls.reverse_row,
    ui.controls.draw_edge_row,
    ui.controls.draw_swipe_row,
    ui.controls.draw_bling_row,
    ui.controls.hide_buffs_row,
  }) do
    row:SetWidth(right_column_width)
  end
end

local function create_indicators_frame(options_frame)
  local frame = CreateFrame("Frame", nil, options_frame.inset_frame)
  frame:SetAllPoints(options_frame.inset_frame)
  if frame.SetClipsChildren then
    frame:SetClipsChildren(true)
  end
  frame:Hide()

  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
  frame.title:SetPoint("TOP", frame, "TOP", 0, -15)
  frame.title:SetText(L["indicator_settings"])

  local ui = {}

  ui.class_dropdown = create_indicator_class_dropdown(frame, function()
    frame:Refresh()
  end)
  ui.health_bar, ui.health_fill, ui.name_text = create_indicator_preview(frame)
  ui.settings_panel, ui.settings_content = create_indicator_settings_panel(frame)

  frame.slots = {}
  local function on_slot_click(index)
    if not spell_popup then
      spell_popup = create_spell_popup(options_frame)
    end
    populate_spell_popup(spell_popup, index, function(slot_idx, spell_id)
      local indicators = get_class_indicators()
      indicators[slot_idx].spell_id = spell_id
      update_slot_display(frame.slots[slot_idx], slot_idx)
      frame:Refresh()
      addon:ReloadModule("AuraIndicators")
    end)
    spell_popup:Show()
  end

  for i = 1, 8 do
    frame.slots[i] = create_indicator_slot(frame, i, ui.health_bar, on_slot_click)
  end

  ui.controls = create_indicator_settings_controls(ui.settings_content, function()
    frame:Refresh()
  end)
  frame.ui = ui

  frame:SetScript("OnSizeChanged", function(self)
    if self:IsShown() then
      self:Refresh()
    end
  end)

  function frame:Refresh()
    layout_indicator_controls(self, self.ui)

    local preview_width, preview_height = get_preview_size()
    self.ui.health_bar:SetSize(preview_width, preview_height)

    -- Update health bar color to match selected class.
    local color = CLASS_COLORS[selected_class]
    if color then
      self.ui.health_fill:SetColorTexture(color[1], color[2], color[3], 0.8)
      self.ui.name_text:SetText(get_localized_class_name(selected_class))
      self.ui.name_text:SetTextColor(color[1], color[2], color[3])
    end

    for i = 1, 8 do
      apply_indicator_slot_layout(self.slots[i], i)
      update_slot_display(self.slots[i], i)
    end

    self.ui.controls.init_size_slider()
    self.ui.controls.init_border_size_slider()
    self.ui.controls.init_cooldown_text_size_slider()
    self.ui.controls.update_border_color_swatch()
    self.ui.controls.cooldown_check:SetChecked(addon.db.profile.module_data.AuraIndicators.show_cooldown)
    self.ui.controls.reverse_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_reverse)
    self.ui.controls.draw_edge_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_draw_edge)
    self.ui.controls.draw_swipe_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_draw_swipe)
    self.ui.controls.draw_bling_check:SetChecked(addon.db.profile.module_data.AuraIndicators.cooldown_draw_bling)
    self.ui.controls.hide_buffs_check:SetChecked(addon.db.profile.module_data.AuraIndicators.hide_default_buffs)
  end

  return frame
end

function private.CreateIndicatorsFrame(options_frame)
  if indicators_frame then
    return indicators_frame
  end

  indicators_frame = create_indicators_frame(options_frame)
  return indicators_frame
end

function private.ShowIndicatorsFrame()
  local options_frame = private.GetOptionsFrame()
  local frame = private.CreateIndicatorsFrame(options_frame)
  frame:Refresh()

  options_frame.inset_frame.scroll_box:Hide()
  options_frame.inset_frame.scroll_bar:Hide()

  frame:Show()
end

function private.HideIndicatorsFrame()
  if indicators_frame then
    indicators_frame:Hide()
  end

  local options_frame = private.GetOptionsFrame()
  options_frame.inset_frame.scroll_box:Show()
  options_frame.inset_frame.scroll_bar:Show()
end
