local _, addonTable = ...
local addon = addonTable.addon

--------------------
--- Libs & Utils ---
--------------------

--- The frame pool is mainly used to reuse frames when changing profiles.
local function indicator_resetter(_, rfs_aura_indicator)
  rfs_aura_indicator:SetParent(nil)
  rfs_aura_indicator:ClearAllPoints()
  rfs_aura_indicator:SetScale(1)
  rfs_aura_indicator:Clear()
end
local rfs_aura_indicator_pool = CreateFramePool("Button", nil, "RaidFrameSettings_AuraIndicatorTemplate", indicator_resetter)

------------------------
--- Speed references ---
------------------------

-- Lua
local unpack = unpack
-- WoW Api

local AuraFrame = {}
AuraFrame.metatable = {__index = AuraFrame}

--- Update the Indicators. This function gets overwriten by AuraFrame.lua if the frame has missing auras.
---@param aura_table table A priority table see TableUtil.CreatePriorityTable.
function AuraFrame:Update(aura_table)
  local indicator_pos = 1
  aura_table:Iterate(function(auraInstanceID, aura)
    if indicator_pos > self.num_indicators then
      return true
    end

    self.indicators[indicator_pos]:SetAura(aura)

    if self.on_set_aura_callback then
      self.on_set_aura_callback(self.indicators[indicator_pos], aura)
    end
    indicator_pos = indicator_pos + 1

    return false
  end)

  for i=indicator_pos, self.num_indicators do
    self.indicators[i]:Clear()
  end
end

function AuraFrame:Clear()
  for i=1, self.num_indicators do
    self.indicators[i]:Clear()
  end
end

local function get_indicator_position(cuf_frame, aura_frame, indicator_pos, options)
  local point, relative_region, relative_point, offset_x, offset_y
  if indicator_pos == 1 then
    point, relative_region, relative_point, offset_x, offset_y = options.anchor_point, cuf_frame, options.relative_point, options.offset_x, options.offset_y -- anchor to cuf_frame.healthBar will result in visual artifacts.
  else
    if ( ( ( indicator_pos - 1 ) % options.num_indicators_per_row ) == 0 ) then
      relative_region = aura_frame.indicators[indicator_pos - options.num_indicators_per_row]
      point = options.direction_of_growth_vertical == "UP" and "BOTTOMRIGHT" or "TOPRIGHT"
      relative_point = point == "BOTTOMRIGHT" and "TOPRIGHT" or "BOTTOMRIGHT"
      offset_x = 0
      offset_y = options.direction_of_growth_vertical == "UP" and options.vertical_padding or -options.vertical_padding
    else
      relative_region = aura_frame.indicators[indicator_pos - 1]
      point = options.direction_of_growth_horizontal == "LEFT" and "BOTTOMRIGHT" or "BOTTOMLEFT"
      relative_point = point == "BOTTOMRIGHT" and "BOTTOMLEFT" or "BOTTOMRIGHT"
      offset_x = options.direction_of_growth_horizontal == "LEFT" and -options.horizontal_padding or options.horizontal_padding
      offset_y = 0
    end
  end
  return point, relative_region, relative_point, offset_x, offset_y
end

---@param options table
--[[
  options = {
    -- Position
    anchor_point
    relative_point
    offset_x
    offset_y
    -- Num indicators row*column
    num_indicators_per_row
    num_indicators_per_column
    -- Orientation
    direction_of_growth_vertical
    vertical_padding
    direction_of_growth_horizontal
    horizontal_padding
    -- Indicator size
    indicator_width
    indicator_height
    -- Indicator border
    indicator_border_thicknes
    indicator_border_color
    -- Font: Duration
    path_to_duration_font
    duration_font_size
    duration_font_outlinemode
    duration_font_color
    -- Font: Stack
    path_to_stack_font
    stack_font_size
    stack_font_outlinemode
    stack_font_color
    -- Cooldown
    show_swipe
    swipe_color
    reverse_swipe
    show_edge
    -- Tooltip
    show_tooltip
    -- SetAura callback
    on_set_aura_callback
  }
  --]]
function AuraFrame:Enable(options)
   -- Num indicators
  --@TODO: compare old num_indicators with new.
  self.num_indicators = options.num_indicators_per_row * options.num_indicators_per_column
  -- SetAura callback
  self.on_set_aura_callback = options.on_set_aura_callback
  for i=1, self.num_indicators do
    -- Fetch the indicator ot create one.
    local rfs_aura_indicator = rfs_aura_indicator_pool:Acquire()
    rfs_aura_indicator:SetParent(self.parent)
    -- Position & Orientation.
    rfs_aura_indicator:SetPoint(get_indicator_position(self.parent, self, i, options))
    -- Indicator size.
    rfs_aura_indicator:Resize(options.indicator_width, options.indicator_height)
    -- Indicator border.
    rfs_aura_indicator:SetBorderThickness(options.indicator_border_thickness)
    rfs_aura_indicator:SetBorderColor(unpack(options.indicator_border_color))
    -- Font: Duration.
    rfs_aura_indicator:SetDurationFont(options.path_to_duration_font, options.duration_font_size, options.duration_font_outlinemode)
    rfs_aura_indicator:SetDurationColor(unpack(options.duration_font_color))
    rfs_aura_indicator:SetDurationShadowColor(unpack(options.duration_font_shadow_color))
    rfs_aura_indicator:SetDurationShadowOffset(options.duration_font_shadow_offset_x, options.duration_font_shadow_offset_y)
    rfs_aura_indicator:SetDurationJustification(options.duration_font_horizontal_justification, options.duration_font_vertical_justification)
    rfs_aura_indicator:SetDurationPosition(options.duration_font_point, options.duration_font_relative_point, options.duration_font_offset_x, options.duration_font_offset_y)
    -- Font: Stack.
    rfs_aura_indicator:SetStackFont(options.path_to_stack_font, options.stack_font_size, options.stack_font_outlinemode)
    rfs_aura_indicator:SetStackColor(unpack(options.stack_font_color))
    rfs_aura_indicator:SetStackShadowColor(unpack(options.stack_font_shadow_color))
    rfs_aura_indicator:SetStackShadowOffset(options.stack_font_shadow_offset_x, options.stack_font_shadow_offset_y)
    rfs_aura_indicator:SetStackJustification(options.stack_font_horizontal_justification, options.stack_font_vertical_justification)
    rfs_aura_indicator:SetStackPosition(options.stack_font_point, options.stack_font_relative_point, options.stack_font_offset_x, options.stack_font_offset_y)
    -- Cooldown.
    rfs_aura_indicator.cooldown:SetDrawSwipe(options.show_swipe)
    rfs_aura_indicator.cooldown:SetReverse(options.reverse_swipe)
    rfs_aura_indicator.cooldown:SetDrawEdge(options.show_edge)
    -- Tooltip
    if options.show_tooltip then
      rfs_aura_indicator:SetScript("OnEnter", function()
        GameTooltip:SetOwner(rfs_aura_indicator, "ANCHOR_RIGHT")
        if rfs_aura_indicator.aura and rfs_aura_indicator.aura.isHelpful then
          GameTooltip:SetUnitBuffByAuraInstanceID(self.parent.unit, rfs_aura_indicator.aura.auraInstanceID)
        elseif rfs_aura_indicator.aura and rfs_aura_indicator.aura.isHarmful then
          GameTooltip:SetUnitDebuffByAuraInstanceID(self.parent.unit, rfs_aura_indicator.aura.auraInstanceID)
        end
      end)
      rfs_aura_indicator:SetScript("OnLeave", function()
        GameTooltip:Hide()
      end)
      -- Even though this is already set in xml when calling SetScript it has to be done again.
      rfs_aura_indicator:SetMouseClickEnabled(false)
    end
    --@TODO: Implement tooltip support.
    self.indicators[i] = rfs_aura_indicator
  end
end

--- Release all rfs_aura_indicators of the aura frame back to the frame pool.
function AuraFrame:Disable()
  self.Update = nil -- Restore the meta function.
  self.num_indicators = 0 -- Important
  for i, rfs_aura_indicator in next, self.indicators do
    rfs_aura_indicator:SetScript("OnEnter", nil)
    rfs_aura_indicator_pool:Release(rfs_aura_indicator)
    self.indicators[i] = nil
  end
end

--- Create a new aura frame.
---@param cuf_frame table the cuf_frame to place the frame on.
---@return table
function addon:NewAuraFrame(cuf_frame)
  local new_aura_frame = setmetatable({}, AuraFrame.metatable)
  new_aura_frame.parent = cuf_frame
  new_aura_frame.indicators = {}
  return new_aura_frame
end
