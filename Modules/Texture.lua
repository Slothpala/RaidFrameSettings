--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("Texture")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)
local Media = LibStub("LibSharedMedia-3.0")
local HealthColor = addonTable.HealthColor

------------------------
--- Speed references ---
------------------------

-- Lua

-- WoW Api
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local Mixin = Mixin
local GetCvar =  C_CVar.GetCVar

function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.Texture)
  -- Fetch the actual data
  local path_to_health_bar_foreground_texture = Media:Fetch("statusbar", db_obj.health_bar_foreground_texture)
  local path_to_health_bar_background_texture = Media:Fetch("statusbar", db_obj.health_bar_background_texture)
  local path_to_power_bar_foreground_texture = Media:Fetch("statusbar", db_obj.power_bar_foreground_texture)
  local path_to_power_bar_background_texture = Media:Fetch("statusbar", db_obj.power_bar_background_texture)
  -- Backdrop info table for the border
  local backdrop_info = {
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile = false,
    tileEdge = true,
    edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1},
  }
  -- Function to check if a frames power bar is actually shown if not we don't have to apply a texture to it or reanchor it.
  local function is_power_bar_shown(cuf_frame)
    if not cuf_frame.powerBar then
      return false
    end
    local options = DefaultCompactUnitFrameSetupOptions
    local display_power_bar = CompactUnitFrame_GetOptionDisplayPowerBar(cuf_frame, options)
    local display_only_healer_power_bars = CompactUnitFrame_GetOptionDisplayOnlyHealerPowerBars(cuf_frame, options)
    local role = UnitGroupRolesAssigned(cuf_frame.unit)
    return display_power_bar and (not display_only_healer_power_bars or role == "HEALER")
  end
  -- Setup the frame
  local function set_status_bar_textures(cuf_frame)
    -- Setup the border
    if not cuf_frame.backdropInfo then
      Mixin(cuf_frame, BackdropTemplateMixin)
      cuf_frame:SetBackdrop(backdrop_info)
      cuf_frame:ApplyBackdrop()
      cuf_frame:SetBackdropBorderColor(0, 0, 0)
    end
    -- Check if a powerbar should be shown
    if is_power_bar_shown(cuf_frame) then
      cuf_frame.powerBar:SetStatusBarTexture(path_to_power_bar_foreground_texture)
      cuf_frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER", 3)
      cuf_frame.powerBar.background:SetTexture(path_to_power_bar_background_texture)
      cuf_frame.powerBar.background:SetDrawLayer("BORDER", 2)
    end
    cuf_frame.healthBar:SetStatusBarTexture(path_to_health_bar_foreground_texture)
    cuf_frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER", 0)
    cuf_frame.background:SetTexture(path_to_health_bar_background_texture)
  end
  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", set_status_bar_textures)
  addon:IterateRoster(set_status_bar_textures)

  -- Since 110002 the function CompactUnitFrame_UpdateWidgetSet reorders the layout of the cuf_frame
  if db_obj.detach_power_bar then
    local function update_layout(cuf_frame)
      if is_power_bar_shown(cuf_frame) then
        -- Setup the powerbar
        cuf_frame.powerBar:ClearAllPoints()
        cuf_frame.powerBar:SetPoint(db_obj.point, cuf_frame.healthBar, db_obj.relative_point, db_obj.offset_x , db_obj.offset_y)
        local width = cuf_frame:GetWidth() * db_obj.power_bar_width
        local height = cuf_frame:GetHeight() * db_obj.power_bar_height
        cuf_frame.powerBar:SetSize(width, height)
        if height > width then
          cuf_frame.powerBar:SetOrientation("VERTICAL")
        end
        -- Setup the healthbar
        cuf_frame.healthBar:SetPoint("TOPLEFT", cuf_frame, "TOPLEFT", 1, -1)
        cuf_frame.healthBar:SetPoint("BOTTOMRIGHT", cuf_frame, "BOTTOMRIGHT", -1, 1)
        cuf_frame.totalAbsorb:SetDrawLayer("BORDER", 1)
        cuf_frame.myHealPrediction:SetDrawLayer("BORDER", 1)
      end
    end
    self:HookFunc_CUF_Filtered("CompactUnitFrame_UpdateWidgetSet", update_layout)
    addon:IterateRoster(update_layout)
  end


  -- Mini frames are the pet and tank target etc. frames
  local function set_mini_frame_textures(cuf_frame)
    -- Setup the border
    if not cuf_frame.backdropInfo then
      Mixin(cuf_frame, BackdropTemplateMixin)
      cuf_frame:SetBackdrop(backdrop_info)
      cuf_frame:ApplyBackdrop()
      cuf_frame:SetBackdropBorderColor(0, 0, 0)
    end
    cuf_frame.healthBar:SetStatusBarTexture(path_to_health_bar_foreground_texture)
    cuf_frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
    cuf_frame.background:SetTexture(path_to_health_bar_background_texture)
    HealthColor:SetBackgroundColor(cuf_frame)
    cuf_frame.horizTopBorder:Hide()
    cuf_frame.horizBottomBorder:Hide()
    cuf_frame.vertLeftBorder:Hide()
    cuf_frame.vertRightBorder:Hide()
  end
  if GetCvar("raidOptionDisplayPets") == "1" or GetCvar("raidOptionDisplayMainTankAndAssist") == "1" then
    -- For party pets
    self:HookFunc("DefaultCompactMiniFrameSetup", set_mini_frame_textures)
    -- For raid pets and tank targat and targettarget
    local function update_raid_mini_frames(cuf_frame)
      if cuf_frame.unit and cuf_frame.unit:match("raidpet") or cuf_frame.unit:match("target") then
        set_mini_frame_textures(cuf_frame)
      end
    end
    self:HookFunc_CUF_Filtered("CompactUnitFrame_SetUnit", update_raid_mini_frames)
    -- Apply the settings to all frames
    addon:IterateMiniRoster(set_mini_frame_textures)
  end
  self:RegisterEvent("CVAR_UPDATE", function(_, cvar)
    if cvar == "raidOptionDisplayPets" or cvar == "raidOptionDisplayMainTankAndAssist" then
      addon:ReloadModule("Texture")
    end
  end)
end

--- The values are from CompactUnitFrame.lua > DefaultCompactUnitFrameSetup()
function module:OnDisable()
  self:DisableHooks()
  local function restore_health_bars_to_default(cuf_frame)
    local options = DefaultCompactUnitFrameSetupOptions
    -- restore the powerbar
    if cuf_frame.powerBar then
      cuf_frame.powerBar:SetOrientation("HORIZONTAL")
      local display_power_bar = CompactUnitFrame_GetOptionDisplayPowerBar(cuf_frame, options)
      local display_only_healer_power_bars = CompactUnitFrame_GetOptionDisplayOnlyHealerPowerBars(cuf_frame, options)
      local role = UnitGroupRolesAssigned(cuf_frame.unit)
      local show_power_bar = display_power_bar and (not display_only_healer_power_bars or role == "HEALER")
      if show_power_bar then
        local displayBorder = EditModeManagerFrame:ShouldRaidFrameDisplayBorder(cuf_frame.groupType)
        cuf_frame.powerBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")
        cuf_frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
        cuf_frame.powerBar.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Background")
        cuf_frame.powerBar.background:SetDrawLayer("BACKGROUND", 1)
        cuf_frame.powerBar:ClearAllPoints()
        cuf_frame.powerBar:SetPoint("TOPLEFT", cuf_frame.healthBar, "BOTTOMLEFT", 0, displayBorder and -2 or 0)
        cuf_frame.powerBar:SetPoint("BOTTOMRIGHT", cuf_frame, "BOTTOMRIGHT", -1, 1)
      end
    end
    local is_power_bar_showing = cuf_frame.powerBar and cuf_frame.powerBar:IsShown()
    local power_bar_used_height = is_power_bar_showing and 8 or 0
    cuf_frame.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Bg")
    cuf_frame.background:SetTexCoord(0, 1, 0, 0.53125)
    cuf_frame.healthBar:SetPoint("TOPLEFT", cuf_frame, "TOPLEFT", 1, -1)
    cuf_frame.healthBar:SetPoint("BOTTOMRIGHT", cuf_frame, "BOTTOMRIGHT", -1, 1 + power_bar_used_height)
    cuf_frame.healthBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    cuf_frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
    if cuf_frame.backdropInfo then
      cuf_frame:ClearBackdrop()
    end
  end
  addon:IterateRoster(restore_health_bars_to_default)
end

