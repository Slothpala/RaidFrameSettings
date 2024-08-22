--[[Created by Slothpala]]--
RaidFrameSettings_AuraIndicatorMixin = {}

local _, addonTable = ...
local addon = addonTable.addon

--------------------
--- Libs & Utils ---
--------------------

local LCG = LibStub("LibCustomGlow-1.0")
local LCG_ProcGlow_Start = LCG.ProcGlow_Start
local LCG_ProcGlow_Stop = LCG.ProcGlow_Stop

------------------------
--- Speed references ---
------------------------

-- Lua
local next = next
local string_format = string.format
-- WoW Api
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetTime = GetTime
local GetSpellInfo = GetSpellInfo

---------------
--- Display ---
---------------

---@param r number [0.0 - 1.0] - Red component
---@param g number [0.0 - 1.0] - Green component
---@param b number [0.0 - 1.0] - Blue component
---@param a number [0.0 - 1.0] - Alpha optional
function RaidFrameSettings_AuraIndicatorMixin:SetBorderColor(r, g, b, a)
  self.border:SetVertexColor(r, g, b, a or 1)
end

--- This will reanchor the icon, the frame size will not change
---@param pixel number
function RaidFrameSettings_AuraIndicatorMixin:SetBorderThickness(pixel)
  self.icon:SetPoint("TOPLEFT", self, "TOPLEFT", pixel, -pixel)
  self.icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -pixel, pixel)
end

---@param font_file string  - Path to the font file.
---@param height number - Size in points.
---@param flags string - Any comma-delimited combination of OUTLINE, THICK and MONOCHROME
function RaidFrameSettings_AuraIndicatorMixin:SetDurationFont(font_file, height, flags)
  self.text.duration:SetFont(font_file, height, flags)
end

---@param r number [0.0 - 1.0] - Red component
---@param g number [0.0 - 1.0] - Green component
---@param b number [0.0 - 1.0] - Blue component
---@param a number [0.0 - 1.0] - Alpha optional
function RaidFrameSettings_AuraIndicatorMixin:SetDurationColor(r, g, b, a)
  self.text.duration:SetTextColor(r, g, b, a or 1)
end

---@param r number [0.0 - 1.0] - Red component
---@param g number [0.0 - 1.0] - Green component
---@param b number [0.0 - 1.0] - Blue component
---@param a number [0.0 - 1.0] - Alpha optional
function RaidFrameSettings_AuraIndicatorMixin:SetDurationShadowColor(r, g, b, a)
  self.text.duration:SetShadowColor(r, g, b, a or 1)
end

function RaidFrameSettings_AuraIndicatorMixin:SetDurationShadowOffset(x, y)
  self.text.duration:SetShadowOffset(x, y)
end

function RaidFrameSettings_AuraIndicatorMixin:SetDurationJustification(horizontal, vertical)
  self.text.duration:SetJustifyH(horizontal)
  self.text.duration:SetJustifyV(vertical)
end

function RaidFrameSettings_AuraIndicatorMixin:SetDurationPosition(point, relative_point, offset_x, offset_y)
  self.text.duration:ClearAllPoints()
  self.text.duration:SetPoint(point, self, relative_point, offset_x, offset_y)
end

---@param font_file string  - Path to the font file.
---@param height number - Size in points.
---@param flags string - Any comma-delimited combination of OUTLINE, THICK and MONOCHROME
function RaidFrameSettings_AuraIndicatorMixin:SetStackFont(font_file, height, flags)
  self.text.count:SetFont(font_file, height, flags)
end

---@param r number [0.0 - 1.0] - Red component
---@param g number [0.0 - 1.0] - Green component
---@param b number [0.0 - 1.0] - Blue component
---@param a number [0.0 - 1.0] - Alpha optional
function RaidFrameSettings_AuraIndicatorMixin:SetStackColor(r, g, b, a)
  self.text.count:SetTextColor(r, g, b, a or 1)
end

---@param r number [0.0 - 1.0] - Red component
---@param g number [0.0 - 1.0] - Green component
---@param b number [0.0 - 1.0] - Blue component
---@param a number [0.0 - 1.0] - Alpha optional
function RaidFrameSettings_AuraIndicatorMixin:SetStackShadowColor(r, g, b, a)
  self.text.count:SetShadowColor(r, g, b, a or 1)
end

function RaidFrameSettings_AuraIndicatorMixin:SetStackShadowOffset(x, y)
  self.text.count:SetShadowOffset(x, y)
end

function RaidFrameSettings_AuraIndicatorMixin:SetStackJustification(horizontal, vertical)
  self.text.count:SetJustifyH(horizontal)
  self.text.count:SetJustifyV(vertical)
end

function RaidFrameSettings_AuraIndicatorMixin:SetStackPosition(point, relative_point, offset_x, offset_y)
  self.text.count:ClearAllPoints()
  self.text.count:SetPoint(point, self, relative_point, offset_x, offset_y)
end

--- The icon aspect ratio will be preserved
---@param width number
---@param height number
function RaidFrameSettings_AuraIndicatorMixin:Resize(width, height)
  local left, right, top, bottom = 0.1, 0.9, 0.1, 0.9
  if ( height ~= width ) then
    if ( height < width ) then
      local delta = width - height
      local scale_factor = ((( 100 / width )  * delta) / 100) / 2
      top = top + scale_factor
      bottom = bottom - scale_factor
    else
      local delta = height - width
      local scale_factor = ((( 100 / height )  * delta) / 100) / 2
      left = left + scale_factor
      right = right - scale_factor
    end
  end
  self:SetSize(width, height)
  self.icon:SetTexCoord(left, right, top, bottom)
  self.border:SetTexCoord(left, right, top, bottom)
  self.cooldown:ClearAllPoints()
  self.cooldown:SetAllPoints(self.icon)
end

----------------
--- Cooldown ---
----------------

local day = 86400
local hour = 3600
local min = 60
-- TODO add format options
local function get_timer_text(number)
-- BreakUpLargeNumbers or Round
  if number < min then
    return Round(number)
  elseif number < hour then
    return string_format("%dm", BreakUpLargeNumbers( number / min ) )
  else
    return string_format("%dh", BreakUpLargeNumbers( number / hour ) )
  end
end

local cooldown_queue = {}
local on_update_frame = CreateFrame("Frame")
local interval = 0.1
local time_since_last_upate = 0

local function update_cooldowns(_, elapsed)
  time_since_last_upate = time_since_last_upate + elapsed
  if ( time_since_last_upate >= interval ) then
    time_since_last_upate = 0
    local current_time = GetTime()
    for rfs_aura_indicator in next, cooldown_queue do
      local cooldown = rfs_aura_indicator.cooldown
      local time = ( cooldown:GetCooldownTimes() + cooldown:GetCooldownDuration() ) / 1000
      local left = time - current_time
      if ( left <= 0 )  then
        cooldown_queue[rfs_aura_indicator] = nil
        rfs_aura_indicator.text.duration:SetText("")
      else
        rfs_aura_indicator.text.duration:SetText(get_timer_text(left))
      end
    end
    if next(cooldown_queue) == nil then
      on_update_frame:SetScript("OnUpdate", nil)
      time_since_last_upate = 0
      return
    end
  end
end

--- Queue the indicator for update_cooldowns which loops over cooldown_queue OnUpdate.
function RaidFrameSettings_AuraIndicatorMixin:StartDurationUpdate()
  cooldown_queue[self] = true
  if next(cooldown_queue) ~= nil then
    on_update_frame:SetScript("OnUpdate", update_cooldowns)
  end
end

--- Remove the indicator from cooldown_queue and stop the OnUpdate script if it was the last indicator.
function RaidFrameSettings_AuraIndicatorMixin:StopDurationUpdate()
  cooldown_queue[self] = nil
  if next(cooldown_queue) == nil then
    on_update_frame:SetScript("OnUpdate", nil)
  end
end

------------
--- Glow ---
------------

local glow_options = {
  startAnim = false,
  frameLevel = 200,
}

function RaidFrameSettings_AuraIndicatorMixin:StartGlow()
  if not self.is_glowing then
    LCG_ProcGlow_Start(self, glow_options)
    self.is_glowing = true
  end
end

function RaidFrameSettings_AuraIndicatorMixin:StopGlow()
  if self.is_glowing then
    LCG_ProcGlow_Stop(self)
  end
  self.is_glowing = false
end

------------
--- Aura ---
------------

local glow_aura_list = {}

function addon:UpdateGlowAuraList()
  glow_aura_list = {}
  if addon:IsModuleEnabled("BuffFrame") then
    for spell_id, info in next, addon.db.profile.BuffFrame.watchlist do
      if info.show_glow then
        glow_aura_list[spell_id] = true
      end
    end
  end
  if addon:IsModuleEnabled("DebuffFrame") then
    for spell_id, info in next, addon.db.profile.DebuffFrame.watchlist do
      if info.show_glow then
        glow_aura_list[spell_id] = true
      end
    end
  end
  if addon:IsModuleEnabled("AuraGroups") then
    for _, v in next, self.db.profile.AuraGroups.aura_groups do
      if type(v) == "table" then
        for spell_id, info in next, v.auras do
          if info.show_glow then
            glow_aura_list[spell_id] = true
          else
            -- The aura group should alwys have the highest priority.
            glow_aura_list[spell_id] = nil
          end
        end
      end
    end
  end
end

---@param aura table - packed Aura as in AuraUtil.
function RaidFrameSettings_AuraIndicatorMixin:SetAura(aura)
  -- Icon texture
  self.icon:SetTexture(aura.icon)
  if self.desaturated then
    self.icon:SetDesaturated(false)
    self.desaturated = false
  end
  -- aura
  self.aura = aura
  -- Cooldown
  if ( aura.duration > 0 ) then
    local start_time = aura.expirationTime - aura.duration
    self.cooldown:SetCooldown(start_time, aura.duration)
    if self.show_cooldown_numbers then
      self:StartDurationUpdate()
      self.text.duration:Show()
    end
  else
    self.cooldown:Clear()
    self.text.duration:Hide()
  end
  -- Stack count
  if ( aura.applications > 1 ) then
    local count_text = aura.applications
    if ( aura.applications >= 100 ) then
      count_text = BUFF_STACKS_OVERFLOW
    end
    self.text.count:SetText(count_text)
    self.text.count:Show()
  else
    self.text.count:Hide()
  end
  -- Glow
  if glow_aura_list[aura.spellId] then
    self:StartGlow()
  else
    self:StopGlow()
  end
  self:Show()
end

function RaidFrameSettings_AuraIndicatorMixin:SetMissingAura(spell_id)
  local spellInfo  = C_Spell.GetSpellInfo(spell_id)
  -- Icon texture
  self.icon:SetTexture(spellInfo.iconID)
  if not self.desaturated then
    self.icon:SetDesaturated(true)
    self.desaturated = true
  end
  -- Cooldown
  self.cooldown:Clear()
  self.text.duration:Hide()
  -- Stack count
  self.text.count:Hide()
  self:StopGlow()
  self:Show()
end

---------------
--- Cleanup ---
---------------

--- Clear the indicator frame and stop all associated work.
function RaidFrameSettings_AuraIndicatorMixin:Clear()
  self:StopDurationUpdate()
  self.cooldown:Clear()
  self.text.duration:Hide()
  self.text.count:Hide()
  self:StopGlow()
  self:Hide()
end
