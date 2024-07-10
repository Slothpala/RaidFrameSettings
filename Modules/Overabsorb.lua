--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("Overabsorb")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)

------------------------
--- Speed references ---
------------------------

-- WoW Api
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitHealth = UnitHealth


function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.Overabsorb)
  -- Reanchor the textures
  local function reanchor_absorb_overlay_and_absorb_glow(cuf_frame)
    local absorb_overlay = cuf_frame.totalAbsorbOverlay
    local absorb_glow = cuf_frame.overAbsorbGlow
    local health_bar = cuf_frame.healthBar
    absorb_overlay:ClearAllPoints()
    absorb_glow:ClearAllPoints()
    absorb_overlay:SetParent(health_bar)
    absorb_glow:SetPoint("TOPLEFT", absorb_overlay, "TOPLEFT", -5, 0)
    absorb_glow:SetPoint("BOTTOMLEFT", absorb_overlay, "BOTTOMLEFT", -5, 0)
    absorb_glow:SetAlpha(db_obj.glow_alpha)
    absorb_glow:SetDrawLayer("BORDER", 1)
  end
  -- Hook
  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", reanchor_absorb_overlay_and_absorb_glow)
  -- Calculate the absorb and resize the absorb bar accordingly.
  local function resize_absorb_bar(cuf_frame)
    local absorb_bar = cuf_frame.totalAbsorb
    local absorb_overlay = cuf_frame.totalAbsorbOverlay
    local health_bar = cuf_frame.healthBar
    local _, max_health = health_bar:GetMinMaxValues()
    if ( max_health <= 0 ) then
      return
    end
    local total_absorb = UnitGetTotalAbsorbs(cuf_frame.displayedUnit) or 0
    if ( total_absorb > max_health ) then
      -- Do not leave the frames region.
      total_absorb = max_health
    end
    local width, height = health_bar:GetSize()
    local bar_size
    local health = UnitHealth(cuf_frame.displayedUnit)
    local missing_health = max_health - health
    if ( total_absorb > 0 ) then
      if absorb_bar:IsShown() and total_absorb <= missing_health then
        absorb_overlay:SetPoint("TOPRIGHT", absorb_bar, "TOPRIGHT", 0, 0)
        absorb_overlay:SetPoint("BOTTOMRIGHT", absorb_bar, "BOTTOMRIGHT", 0, 0)
        bar_size = total_absorb / max_health * width
      else
        absorb_overlay:SetPoint("TOPRIGHT", health_bar, "TOPRIGHT", 0, 0)
        absorb_overlay:SetPoint("BOTTOMRIGHT", health_bar, "BOTTOMRIGHT", 0, 0)
        bar_size = ( (total_absorb - missing_health) / max_health ) * width
      end
      absorb_overlay:SetWidth(bar_size)
      absorb_overlay:SetTexCoord(0, ( bar_size / absorb_overlay.tileSize ), 0, ( height / absorb_overlay.tileSize) )
      absorb_overlay:Show()
    end
  end
  -- Hook
  self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateHealPrediction", resize_absorb_bar)
  -- Apply the changed
  addon:IterateRoster(function(cuf_frame)
    if cuf_frame.unit then
      reanchor_absorb_overlay_and_absorb_glow(cuf_frame)
      resize_absorb_bar(cuf_frame)
    end
  end)
end

function module:OnDisable()
  self:DisableHooks()
  local restore_absorb_overlay_and_absorb_glow_anchors = function(cuf_frame)
    cuf_frame.overAbsorbGlow:SetPoint("BOTTOMLEFT", cuf_frame.healthBar, "BOTTOMRIGHT", -7, 0)
    cuf_frame.overAbsorbGlow:SetPoint("TOPLEFT", cuf_frame.healthBar, "TOPRIGHT", -7, 0)
    cuf_frame.overAbsorbGlow:SetAlpha(1)
  end
  addon:IterateRoster(restore_absorb_overlay_and_absorb_glow_anchors)
end
