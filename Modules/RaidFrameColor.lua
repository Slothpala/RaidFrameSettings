--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("RaidFrameColor")

--------------------
--- Libs & Utils ---
--------------------

local HealthColor = addonTable.HealthColor
local PowerColor = addonTable.PowerColor
local UnitCache = addonTable.UnitCache
Mixin(module, addonTable.HookRegistryMixin)

------------------------
--- Speed references ---
------------------------

-- Lua
local unpack = unpack
-- WoW Api
local UnitGUID = UnitGUID
local CreateColor = CreateColor
local UnitPowerType = UnitPowerType
local UnitInPartyIsAI = UnitInPartyIsAI

function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.RaidFrameColor)
  -- Healthbar foreground
    --[[
    color_mode:
    1 = class/reaction colored
    2 = static colored
  --]]
  -- Player
  local foreground_to_player_color
  if db_obj.health_bar_foreground_color_mode == 1 then
    if db_obj.health_bar_foreground_use_gradient_colors then
      foreground_to_player_color = function(cuf_frame)
        local guid = UnitGUID(cuf_frame.unit)
        local unit_cache = UnitCache:Get(guid)
        local min_color = addonTable.colors.class_colors[unit_cache.class].min_color
        local max_color = addonTable.colors.class_colors[unit_cache.class].max_color
        local texture = cuf_frame.healthBar:GetStatusBarTexture()
        texture:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      foreground_to_player_color = function(cuf_frame)
        local guid = UnitGUID(cuf_frame.unit)
        local unit_cache = UnitCache:Get(guid)
        local class_color = addonTable.colors.class_colors[unit_cache.class].normal_color
        cuf_frame.healthBar:SetStatusBarColor(class_color[1], class_color[2], class_color[3], class_color[4])
      end
    end
  else
    if db_obj.health_bar_foreground_use_gradient_colors then
      local min_color = CreateColor(unpack(db_obj.health_bar_foreground_static_min_color))
      local max_color = CreateColor(unpack(db_obj.health_bar_foreground_static_max_color))
      foreground_to_player_color = function(cuf_frame)
        local texture = cuf_frame.healthBar:GetStatusBarTexture()
        texture:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      local color = db_obj.health_bar_foreground_static_normal_color
      foreground_to_player_color = function(cuf_frame)
        cuf_frame.healthBar:SetStatusBarColor(color[1], color[2], color[3], color[4])
      end
    end
  end
  HealthColor:SetPlayerColorFunction(foreground_to_player_color)
  -- NPC
  local foreground_to_npc_color
  if db_obj.health_bar_foreground_color_mode == 1 then
    if db_obj.health_bar_foreground_use_gradient_colors then
      local enemy_min_color = CreateColor(1, 0, 0)
      local enemy_max_color = CreateColor(1, 0, 0)
      local friend_min_color = CreateColor(0, 1, 0)
      local friend_max_color = CreateColor(0, 1, 0)
      foreground_to_npc_color = function(cuf_frame)
        local is_ai_companion = UnitInPartyIsAI(cuf_frame.unit)
        if is_ai_companion then
          foreground_to_player_color(cuf_frame)
          return
        end
        local is_enemy = UnitIsEnemy("player", cuf_frame.unit)
        local texture = cuf_frame.healthBar:GetStatusBarTexture()
        if is_enemy then
          texture:SetGradient("HORIZONTAL", enemy_min_color, enemy_max_color)
        else
          texture:SetGradient("HORIZONTAL", friend_min_color, friend_max_color)
        end
      end
    else
      local enemy_normal_color = {1, 0, 0, 1}
      local friend_normal_color = {0, 1, 0, 1}
      foreground_to_npc_color = function(cuf_frame)
        local is_ai_companion = UnitInPartyIsAI(cuf_frame.unit)
        if is_ai_companion then
          foreground_to_player_color(cuf_frame)
          return
        end
        local is_enemy = UnitIsEnemy("player", cuf_frame.unit)
        if is_enemy then
          cuf_frame.healthBar:SetStatusBarColor(enemy_normal_color[1], enemy_normal_color[2], enemy_normal_color[3], enemy_normal_color[4])
        else
          cuf_frame.healthBar:SetStatusBarColor(friend_normal_color[1], friend_normal_color[2], friend_normal_color[3], friend_normal_color[4])
        end
      end
    end
  else
    foreground_to_npc_color = foreground_to_player_color
  end
  HealthColor:SetNpcColorFunction(foreground_to_npc_color)
  -- Healthbar background
  --[[
    color_mode:
    1 = class/reaction colored
    2 = static colored
  --]]
  local health_darkening_factor = db_obj.health_bar_background_class_color_darkening_factor
  local set_background_health_color
  if db_obj.health_bar_background_color_mode == 1 then
    local darkened_class_colors  = {}
    local db_obj_class_colors = CopyTable(addon.db.profile.AddOnColors.class_colors)
    for class, color_info in next, db_obj_class_colors do
      darkened_class_colors[class] = {
        min_color = CreateColor(color_info.min_color[1] * health_darkening_factor, color_info.min_color[2] * health_darkening_factor, color_info.min_color[3] * health_darkening_factor, color_info.min_color[4]),
        max_color = CreateColor(color_info.max_color[1] * health_darkening_factor, color_info.max_color[2] * health_darkening_factor, color_info.max_color[3] * health_darkening_factor, color_info.max_color[4]),
        normal_color = {color_info.normal_color[1] * health_darkening_factor, color_info.normal_color[2] * health_darkening_factor, color_info.normal_color[3] * health_darkening_factor, color_info.normal_color[4]},
      }
    end
    if db_obj.health_bar_background_use_gradient_colors then
      local enemy_min_color = CreateColor(1 * health_darkening_factor, 0 * health_darkening_factor, 0 * health_darkening_factor)
      local enemy_max_color = CreateColor(1 * health_darkening_factor, 0 * health_darkening_factor, 0 * health_darkening_factor)
      local friend_min_color = CreateColor(0 * health_darkening_factor, 1 * health_darkening_factor, 0 * health_darkening_factor)
      local friend_max_color = CreateColor(0 * health_darkening_factor, 1 * health_darkening_factor, 0 * health_darkening_factor)
      set_background_health_color = function(cuf_frame)
        local min_color, max_color
        if UnitIsPlayer(cuf_frame.unit) or UnitInPartyIsAI(cuf_frame.unit) then
          local guid = UnitGUID(cuf_frame.unit)
          local unit_cache = UnitCache:Get(guid)
          min_color = darkened_class_colors[unit_cache.class].min_color
          max_color = darkened_class_colors[unit_cache.class].max_color
        else
          if UnitIsEnemy("player", cuf_frame.unit) then
            min_color = enemy_min_color
            max_color = enemy_max_color
          else
            min_color = friend_min_color
            max_color = friend_max_color
          end
        end
        cuf_frame.background:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      local enemy_normal_color = {1 * health_darkening_factor, 0 * health_darkening_factor, 0 * health_darkening_factor, 1}
      local friend_normal_color = {0 * health_darkening_factor, 1 * health_darkening_factor, 0 * health_darkening_factor, 1}
      set_background_health_color = function(cuf_frame)
        local color
        if UnitIsPlayer(cuf_frame.unit) or UnitInPartyIsAI(cuf_frame.unit) then
          local guid = UnitGUID(cuf_frame.unit)
          local unit_cache = UnitCache:Get(guid)
          color = darkened_class_colors[unit_cache.class].normal_color
        else
          if UnitIsEnemy("player", cuf_frame.unit) then
            color = enemy_normal_color
          else
            color = friend_normal_color
          end
        end
        cuf_frame.background:SetVertexColor(color[1], color[2], color[3], color[4])
      end
    end
  else
    if db_obj.health_bar_background_use_gradient_colors then
      local min_color = CreateColor(unpack(db_obj.health_bar_background_static_min_color))
      local max_color = CreateColor(unpack(db_obj.health_bar_background_static_max_color))
      set_background_health_color = function(cuf_frame)
        cuf_frame.background:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      local color = db_obj.health_bar_background_static_normal_color
      set_background_health_color = function(cuf_frame)
        cuf_frame.background:SetVertexColor(color[1], color[2], color[3], color[4])
      end
    end
  end
  HealthColor:SetBackgroundColorFunction(set_background_health_color)
  -- Power Bar foreground
  --[[
    color_mode:
    1 = power type colored
    2 = static colored
  --]]
  local set_power_color
  if db_obj.power_bar_foreground_color_mode == 1 then
    if db_obj.power_bar_foreground_use_gradient_colors then
      set_power_color = function(cuf_frame)
        local texture = cuf_frame.powerBar:GetStatusBarTexture()
        -- Sad but it sometimes is nil
        if not texture then
          return
        end
        local _, power_token = UnitPowerType(cuf_frame.unit)
        local power_color_info = addonTable.colors.power_colors[power_token] or addonTable.colors.power_colors["MANA"]
        local min_color = power_color_info.min_color
        local max_color = power_color_info.max_color
        texture:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      set_power_color = function(cuf_frame)
        local _, power_token = UnitPowerType(cuf_frame.unit)
        local power_color_info = addonTable.colors.power_colors[power_token] or addonTable.colors.power_colors["MANA"]
        local normal_color = power_color_info.normal_color
        cuf_frame.powerBar:SetStatusBarColor(normal_color[1], normal_color[2], normal_color[3])
      end
    end
  else
    if db_obj.power_bar_foreground_use_gradient_colors then
      local min_color = CreateColor(unpack(db_obj.power_bar_foreground_static_min_color))
      local max_color = CreateColor(unpack(db_obj.power_bar_foreground_static_max_color))
      set_power_color = function(cuf_frame)
        local texture = cuf_frame.powerBar:GetStatusBarTexture()
        -- Sad but it sometimes is nil
        if not texture then
          return
        end
        texture:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      local normal_color = db_obj.power_bar_foreground_static_normal_color
      set_power_color = function(cuf_frame)
        cuf_frame.powerBar:SetStatusBarColor(normal_color[1], normal_color[2], normal_color[3])
      end
    end
  end
  PowerColor:SetPowerColorFunction(set_power_color)
  -- Powerbar background
  --[[
    color_mode:
    1 = power type colored
    2 = static colored
  --]]
  local power_darkening_factor = db_obj.power_bar_background_power_color_darkening_factor
  local set_background_power_color
  if db_obj.power_bar_background_color_mode == 1 then
    local darkened_power_colors  = {}
    local db_obj_power_colors = CopyTable(addon.db.profile.AddOnColors.power_colors)
    for power_type, color_info in next, db_obj_power_colors do
      darkened_power_colors[power_type] = {
        min_color = CreateColor(color_info.min_color[1] * power_darkening_factor, color_info.min_color[2] * power_darkening_factor, color_info.min_color[3] * power_darkening_factor, color_info.min_color[4]),
        max_color = CreateColor(color_info.max_color[1] * power_darkening_factor, color_info.max_color[2] * power_darkening_factor, color_info.max_color[3] * power_darkening_factor, color_info.max_color[4]),
        normal_color = {color_info.normal_color[1] * power_darkening_factor, color_info.normal_color[2] * power_darkening_factor, color_info.normal_color[3] * power_darkening_factor, color_info.normal_color[4]},
      }
    end
    if db_obj.power_bar_background_use_gradient_colors then
      set_background_power_color = function(cuf_frame)
        local _, power_token = UnitPowerType(cuf_frame.unit)
        local power_color_info = darkened_power_colors[power_token] or darkened_power_colors["MANA"]
        cuf_frame.powerBar.background:SetGradient("HORIZONTAL", power_color_info.min_color, power_color_info.max_color)
      end
    else
      set_background_power_color = function(cuf_frame)
        local _, power_token = UnitPowerType(cuf_frame.unit)
        local power_color_info = darkened_power_colors[power_token] or darkened_power_colors["MANA"]
        cuf_frame.powerBar.background:SetVertexColor(power_color_info.normal_color[1], power_color_info.normal_color[2], power_color_info.normal_color[3], power_color_info.normal_color[4])
      end
    end
    PowerColor:SetPowerBackgroundColorFunction(set_background_power_color)
  else
    if db_obj.power_bar_background_use_gradient_colors then
      local min_color = CreateColor(unpack(db_obj.power_bar_background_static_min_color))
      local max_color = CreateColor(unpack(db_obj.power_bar_background_static_max_color))
      set_background_power_color = function(cuf_frame)
        cuf_frame.powerBar.background:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      local normal_color = db_obj.power_bar_background_static_normal_color
      set_background_power_color = function(cuf_frame)
        cuf_frame.powerBar.background:SetVertexColor(normal_color[1], normal_color[2], normal_color[3], normal_color[4])
      end
    end
    PowerColor:SetPowerBackgroundColorFunction(nil) -- The color update on CompactUnitFrame_UpdatePowerColor is only needed when playing with power color as background color.
  end

  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", function(cuf_frame)
    set_background_health_color(cuf_frame)
    if db_obj.power_bar_background_color_mode == 2 then -- If the background color is static it only has be set once and therefore PowerColor will not update it.
      set_background_power_color(cuf_frame)
    end
  end)

  addon:IterateRoster(function(cuf_frame)
    if cuf_frame.unit then
      HealthColor:UpdateColor(cuf_frame)
      HealthColor:SetBackgroundColor(cuf_frame)
      PowerColor:UpdateColor(cuf_frame)
      if db_obj.power_bar_background_color_mode == 2 then -- See above
        set_background_power_color(cuf_frame)
      end
    end
  end)
  addon:IterateMiniRoster(function(cuf_frame)
    if cuf_frame.unit then
      HealthColor:UpdateColor(cuf_frame)
      HealthColor:SetBackgroundColor(cuf_frame)
    end
  end)
  if addon:IsModuleEnabled("Range") then
    addon:ReloadModule("Range")
  end

  -- Compact Arena Frames
    --[[
    color_mode:
    1 = class/reaction colored
    2 = static colored
  --]]
  local set_arena_opponent_foreground_color
  if db_obj.health_bar_foreground_color_mode == 1 then
    if db_obj.health_bar_foreground_use_gradient_colors then
      set_arena_opponent_foreground_color = function(texture, class)
        local min_color = addonTable.colors.class_colors[class].min_color
        local max_color = addonTable.colors.class_colors[class].max_color
        texture:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      set_arena_opponent_foreground_color = function(texture, class)
        local class_color = addonTable.colors.class_colors[class].normal_color
        texture:SetVertexColor(class_color[1], class_color[2], class_color[3], class_color[4])
      end
    end
  else
    if db_obj.health_bar_foreground_use_gradient_colors then
      local min_color = CreateColor(unpack(db_obj.health_bar_foreground_static_min_color))
      local max_color = CreateColor(unpack(db_obj.health_bar_foreground_static_max_color))
      set_arena_opponent_foreground_color = function(texture)
        texture:SetGradient("HORIZONTAL", min_color, max_color)
      end
    else
      local color = db_obj.health_bar_foreground_static_normal_color
      set_arena_opponent_foreground_color = function(texture)
        texture:SetVertexColor(color[1], color[2], color[3], color[4])
      end
    end
  end

  for i=1, 3 do
    -- Stealth Unit
    local stealthed_unit_frame = CompactArenaFrame["StealthedUnitFrame" .. i]
    local foreground_texture = stealthed_unit_frame.BarTexture
    local function set_stealth_unit_color()
      local unit_class_info = stealthed_unit_frame:GetUnitClassInfo()
      local class = unit_class_info.class or "PRIEST"
      set_arena_opponent_foreground_color(foreground_texture, class)
    end
    self:HookFunc(stealthed_unit_frame, "SetUnitFrame", set_stealth_unit_color)
    set_stealth_unit_color()
    -- Pre Match Frame
    local pre_match_frame = CompactArenaFrame.PreMatchFramesContainer["PreMatchFrame" .. i]
    local pre_match_texture = pre_match_frame.BarTexture
    local function set_pre_match_frame_color(_, index)
      local spec_id = GetArenaOpponentSpec(index)
      if spec_id and spec_id > 0 then
        local class = select(6, GetSpecializationInfoByID(spec_id)) or "PRIEST"
        set_arena_opponent_foreground_color(pre_match_texture, class)
      end
    end
    self:HookFunc(pre_match_frame, "Update", set_pre_match_frame_color)
    set_pre_match_frame_color(_, i)
  end


end

function module:OnDisable()
  self:DisableHooks()
  -- This module is always active
end
