-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("AuraIndicators")

-- Position mapping: index -> anchor point on the raid frame.
local INDICATOR_POSITIONS = {
  [1] = { point = "TOPLEFT",     x =  2, y = -2 },
  [2] = { point = "LEFT",        x =  2, y =  0 },
  [3] = { point = "BOTTOMLEFT",  x =  2, y =  2 },
  [4] = { point = "TOP",         x =  0, y = -2 },
  [5] = { point = "BOTTOM",      x =  0, y =  2 },
  [6] = { point = "TOPRIGHT",    x = -2, y = -2 },
  [7] = { point = "RIGHT",       x = -2, y =  0 },
  [8] = { point = "BOTTOMRIGHT", x = -2, y =  2 },
}

local border_texture = "Interface\\Buttons\\WHITE8X8"
local fallback_icon = "Interface\\Icons\\INV_Misc_QuestionMark"
local DEFAULT_DISPLAY_MODE = "present"
local MISSING_ICON_VERTEX = 0.75

local function normalize_display_mode(mode)
  if mode == "missing" or mode == "both" then
    return mode
  end

  return DEFAULT_DISPLAY_MODE
end

local function reset_indicator(indicator)
  indicator:Hide()

  if indicator.cooldown then
    indicator.cooldown:Clear()
  end

  if indicator.count then
    indicator.count:Hide()
  end

  if indicator.icon then
    indicator.icon:SetDesaturated(false)
    indicator.icon:SetVertexColor(1, 1, 1)
  end
end

-- Setup the module.
function module:OnEnable()
  local db = addon.db.profile.module_data.AuraIndicators
  local show_cooldown = db.show_cooldown
  local cooldown_text_size = db.cooldown_text_size
  local cooldown_reverse = db.cooldown_reverse
  local cooldown_draw_edge = db.cooldown_draw_edge
  local cooldown_draw_swipe = db.cooldown_draw_swipe
  local cooldown_draw_bling = db.cooldown_draw_bling
  local hide_default_buffs = db.hide_default_buffs
  local border_color = CopyTable(db.border_color)
  local border_size = db.border_size

  -- Use the player's own class to determine which indicators to show.
  local _, player_class = UnitClass("player")
  local player_indicators = db.class_indicators[player_class]

  -- Build spell lookup for the player's class only.
  local spell_lookup = {}
  local configured_indices = {}
  local indicator_configs = {}
  local has_any = false
  for i = 1, 8 do
    local indicator_data = player_indicators[i]
    local spell_id = indicator_data and indicator_data.spell_id or 0
    if spell_id and spell_id > 0 then
      local display_mode = normalize_display_mode(indicator_data and indicator_data.display_mode)
      local spell_info = C_Spell.GetSpellInfo(spell_id)

      indicator_configs[i] = {
        spell_id = spell_id,
        display_mode = display_mode,
        icon = spell_info and spell_info.iconID or fallback_icon,
      }

      if not spell_lookup[spell_id] then
        spell_lookup[spell_id] = {}
      end
      table.insert(spell_lookup[spell_id], i)
      table.insert(configured_indices, i)
      has_any = true
    end
  end

  if not has_any and not hide_default_buffs then
    return
  end

  local function create_border_edges(indicator)
    if indicator.RFS_BorderEdges then
      return indicator.RFS_BorderEdges
    end

    local edges = {}

    edges.topleft = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.topleft:SetTexture(border_texture)
    edges.topleft:SetPoint("TOPLEFT", indicator, "TOPLEFT", 0, 0)

    edges.topright = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.topright:SetTexture(border_texture)
    edges.topright:SetPoint("TOPRIGHT", indicator, "TOPRIGHT", 0, 0)

    edges.bottomleft = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottomleft:SetTexture(border_texture)
    edges.bottomleft:SetPoint("BOTTOMLEFT", indicator, "BOTTOMLEFT", 0, 0)

    edges.bottomright = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottomright:SetTexture(border_texture)
    edges.bottomright:SetPoint("BOTTOMRIGHT", indicator, "BOTTOMRIGHT", 0, 0)

    edges.top = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.top:SetTexture(border_texture)
    edges.top:SetPoint("TOPLEFT", edges.topleft, "TOPRIGHT", 0, 0)
    edges.top:SetPoint("TOPRIGHT", edges.topright, "TOPLEFT", 0, 0)

    edges.bottom = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottom:SetTexture(border_texture)
    edges.bottom:SetPoint("BOTTOMLEFT", edges.bottomleft, "BOTTOMRIGHT", 0, 0)
    edges.bottom:SetPoint("BOTTOMRIGHT", edges.bottomright, "BOTTOMLEFT", 0, 0)

    edges.left = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.left:SetTexture(border_texture)
    edges.left:SetPoint("TOPLEFT", edges.topleft, "BOTTOMLEFT", 0, 0)
    edges.left:SetPoint("BOTTOMLEFT", edges.bottomleft, "TOPLEFT", 0, 0)

    edges.right = indicator:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.right:SetTexture(border_texture)
    edges.right:SetPoint("TOPRIGHT", edges.topright, "BOTTOMRIGHT", 0, 0)
    edges.right:SetPoint("BOTTOMRIGHT", edges.bottomright, "TOPRIGHT", 0, 0)

    indicator.RFS_BorderEdges = edges
    return edges
  end

  local function apply_border(indicator)
    local edges = create_border_edges(indicator)

    if border_size <= 0 then
      for _, edge in pairs(edges) do
        edge:Hide()
      end

      indicator.icon:ClearAllPoints()
      indicator.icon:SetAllPoints(indicator)

      indicator.cooldown:ClearAllPoints()
      indicator.cooldown:SetAllPoints(indicator.icon)
      return
    end

    for _, edge in pairs(edges) do
      edge:SetVertexColor(unpack(border_color))
      edge:Show()
    end

    edges.top:SetHeight(border_size)
    edges.bottom:SetHeight(border_size)
    edges.left:SetWidth(border_size)
    edges.right:SetWidth(border_size)

    edges.topleft:SetSize(border_size, border_size)
    edges.topright:SetSize(border_size, border_size)
    edges.bottomleft:SetSize(border_size, border_size)
    edges.bottomright:SetSize(border_size, border_size)

    indicator.icon:ClearAllPoints()
    indicator.icon:SetPoint("TOPLEFT", indicator, "TOPLEFT", border_size, -border_size)
    indicator.icon:SetPoint("BOTTOMRIGHT", indicator, "BOTTOMRIGHT", -border_size, border_size)

    indicator.cooldown:ClearAllPoints()
    indicator.cooldown:SetAllPoints(indicator.icon)
  end

  local function get_indicator_size(cuf_frame)
    local frame_width = cuf_frame:GetWidth() or 0
    local frame_height = cuf_frame:GetHeight() or 0
    local base_size = math.min(frame_width, frame_height)
    if base_size <= 0 then
      return db.indicator_size
    end

    return math.max(4, math.floor((base_size * db.indicator_size / 100) + 0.5))
  end

  local function create_indicator(cuf_frame, index)
    local pos = INDICATOR_POSITIONS[index]
    if not pos then
      return nil
    end

    local key = "RFS_AuraIndicator" .. index
    local indicator = cuf_frame[key]

    if not indicator then
      indicator = CreateFrame("Frame", nil, cuf_frame)
      indicator:SetFrameLevel(cuf_frame:GetFrameLevel() + 5)

      indicator.icon = indicator:CreateTexture(nil, "ARTWORK")
      indicator.icon:SetAllPoints()
      indicator.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

      indicator.cooldown = CreateFrame("Cooldown", nil, indicator, "CooldownFrameTemplate")
      indicator.cooldown:SetAllPoints()
      indicator.cooldown:SetDrawEdge(false)

      indicator.count = indicator:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
      indicator.count:SetPoint("BOTTOMRIGHT", indicator, "BOTTOMRIGHT", 1, -1)
      indicator.count:Hide()

      cuf_frame[key] = indicator
    end

    local indicator_size = get_indicator_size(cuf_frame)
    indicator:SetSize(indicator_size, indicator_size)
    indicator:ClearAllPoints()
    indicator:SetPoint(pos.point, cuf_frame, pos.point, pos.x, pos.y)
    indicator.cooldown:SetHideCountdownNumbers(not show_cooldown)
    if indicator.cooldown.GetCountdownFontString then
      local countdown_string = indicator.cooldown:GetCountdownFontString()
      if countdown_string then
        local font_path, _, font_flags = countdown_string:GetFont()
        if font_path then
          countdown_string:SetFont(font_path, cooldown_text_size, font_flags)
        end
      end
    end
    if indicator.cooldown.SetReverse then
      indicator.cooldown:SetReverse(cooldown_reverse)
    end
    if indicator.cooldown.SetDrawEdge then
      indicator.cooldown:SetDrawEdge(cooldown_draw_edge)
    end
    if indicator.cooldown.SetDrawSwipe then
      indicator.cooldown:SetDrawSwipe(cooldown_draw_swipe)
    end
    if indicator.cooldown.SetDrawBling then
      indicator.cooldown:SetDrawBling(cooldown_draw_bling)
    end
    apply_border(indicator)

    return indicator
  end

  local function hide_indicator(indicator)
    reset_indicator(indicator)
  end

  local function show_present_indicator(indicator, aura_data, config)
    indicator.icon:SetTexture(aura_data.icon or config.icon or fallback_icon)
    indicator.icon:SetDesaturated(false)
    indicator.icon:SetVertexColor(1, 1, 1)

    if aura_data.duration and aura_data.duration > 0 then
      local start_time = aura_data.expirationTime - aura_data.duration
      indicator.cooldown:SetCooldown(start_time, aura_data.duration)
    else
      indicator.cooldown:Clear()
    end

    if aura_data.applications and aura_data.applications > 1 then
      indicator.count:SetText(aura_data.applications)
      indicator.count:Show()
    else
      indicator.count:Hide()
    end

    indicator:Show()
  end

  local function show_missing_indicator(indicator, config)
    indicator.icon:SetTexture(config.icon or fallback_icon)
    indicator.icon:SetDesaturated(true)
    indicator.icon:SetVertexColor(MISSING_ICON_VERTEX, MISSING_ICON_VERTEX, MISSING_ICON_VERTEX)
    indicator.cooldown:Clear()
    indicator.count:Hide()
    indicator:Show()
  end

  local function hide_default_buff_frames(cuf_frame)
    if not hide_default_buffs or not cuf_frame.buffFrames then
      return
    end

    for _, buff_frame in pairs(cuf_frame.buffFrames) do
      buff_frame:Hide()
    end
  end

  local function hide_all_indicators(cuf_frame)
    for i = 1, 8 do
      local key = "RFS_AuraIndicator" .. i
      local indicator = cuf_frame[key]
      if indicator then
        hide_indicator(indicator)
      end
    end
  end

  local function setup_indicators(cuf_frame)
    -- Hide any existing indicators first so removed assignments stay hidden.
    hide_all_indicators(cuf_frame)

    -- Create only configured indicator frames.
    for _, i in ipairs(configured_indices) do
      local indicator = create_indicator(cuf_frame, i)
      if indicator then
        hide_indicator(indicator)
        indicator.spell_id = indicator_configs[i].spell_id
        indicator.display_mode = indicator_configs[i].display_mode
      end
    end
  end

  local function update_indicators(cuf_frame)
    if not cuf_frame.unit then
      return
    end

    local active_auras = {}

    -- Hide configured indicators first.
    for _, i in ipairs(configured_indices) do
      local key = "RFS_AuraIndicator" .. i
      local indicator = cuf_frame[key]
      if indicator then
        hide_indicator(indicator)
      end
    end

    -- Scan auras on the unit for the player's configured spells.
    local unit = cuf_frame.unit
    for i = 1, 255 do
      local aura_data = C_UnitAuras.GetAuraDataByIndex(unit, i, "HELPFUL")
      if not aura_data then
        break
      end

      local spell_id = aura_data.spellId
      local indices = nil
      if spell_id and not issecretvalue(spell_id) then
        indices = spell_lookup[spell_id]
      end
      if indices then
        for _, idx in ipairs(indices) do
          active_auras[idx] = aura_data
        end
      end
    end

    for _, idx in ipairs(configured_indices) do
      local config = indicator_configs[idx]
      local key = "RFS_AuraIndicator" .. idx
      local indicator = cuf_frame[key]
      local aura_data = active_auras[idx]

      if indicator and config then
        if aura_data then
          if config.display_mode ~= "missing" then
            show_present_indicator(indicator, aura_data, config)
          end
        elseif config.display_mode ~= "present" then
          show_missing_indicator(indicator, config)
        end
      end
    end
  end

  local on_frame_setup
  if has_any and hide_default_buffs then
    on_frame_setup = function(cuf_frame)
      hide_default_buff_frames(cuf_frame)
      setup_indicators(cuf_frame)
    end
  elseif has_any then
    on_frame_setup = setup_indicators
  else
    on_frame_setup = hide_default_buff_frames
  end

  local on_aura_update
  if has_any and hide_default_buffs then
    on_aura_update = function(cuf_frame)
      hide_default_buff_frames(cuf_frame)
      update_indicators(cuf_frame)
    end
  elseif has_any then
    on_aura_update = update_indicators
  else
    on_aura_update = hide_default_buff_frames
  end

  if on_frame_setup then
    self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", on_frame_setup)
  end

  if on_aura_update then
    self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateAuras", on_aura_update)
  end

  private.IterateRoster(function(cuf_frame)
    on_frame_setup(cuf_frame)
    if has_any then
      update_indicators(cuf_frame)
    end
  end)
end

function module:OnDisable()
  private.IterateRoster(function(cuf_frame)
    for i = 1, 8 do
      local key = "RFS_AuraIndicator" .. i
      local indicator = cuf_frame[key]
      if indicator then
        reset_indicator(indicator)
      end
    end
  end)
end
