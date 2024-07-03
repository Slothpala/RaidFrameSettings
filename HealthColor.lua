
local _, addonTable = ...
addonTable.HealthColor = {}
local HealthColor = addonTable.HealthColor

--------------------
--- Libs & Utils ---
--------------------

local UnitCache = addonTable.UnitCache

------------------------
--- Speed references ---
------------------------

-- Lua
local next = next
-- WoW Api
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsPlayer = UnitIsPlayer


local function to_player_color(cuf_frame)
  -- Function is controlled by RaidFrameColor.lua
end

local function to_npc_color(cuf_frame)
  -- Function is controlled by RaidFrameColor.lua
end

local function set_background_color(cuf_frame)
  -- Function is controlled by RaidFrameColor.lua
end

local function update_healt_color(cuf_frame)
  -- Filter out protected frames in this case friendly nameplates in instanced content.
  if not cuf_frame or not cuf_frame.unit or cuf_frame:IsForbidden() then
    return
  end
  -- Filter out all other nameplates. Nameplates are unnamed.
  local name = cuf_frame:GetName()
  if not name then
    return
  end
  local is_connected = UnitIsConnected(cuf_frame.unit)
  local is_dead = is_connected and UnitIsDead(cuf_frame.unit)
  local is_player = UnitIsPlayer(cuf_frame.unit)
  if not is_connected or is_dead then
    -- Color it gray
    local color = addonTable.colors.unit_offline_color
    cuf_frame.healthBar:SetStatusBarColor(color[1], color[2], color[3])
    return
  end
  -- Check if the color update is blocked, e.g. by an aura color.
  -- The callback function recolors the frame and returns true/false depending on whether the condition was met.
  if cuf_frame.RFS_FrameEnvironment then
    -- Debuff Highlight
    if cuf_frame.RFS_FrameEnvironment.debuff_color_override then
      local is_true = cuf_frame.RFS_FrameEnvironment.debuff_color_override(cuf_frame)
      if is_true then
        return
      end
      cuf_frame.RFS_FrameEnvironment.debuff_color_override = nil
    -- Buff Highlight
    elseif cuf_frame.RFS_FrameEnvironment.buff_color_override then
      local is_true = cuf_frame.RFS_FrameEnvironment.buff_color_override(cuf_frame)
      if is_true then
        return
      end
      cuf_frame.RFS_FrameEnvironment.buff_color_override = nil
    end
  end
  -- The "normal" color
  if is_player then
    to_player_color(cuf_frame)
  else
    to_npc_color(cuf_frame)
  end
end

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", update_healt_color)

--- Set the default color of player healthbars
---@param new_to_player_color function
function HealthColor:SetPlayerColorFunction(new_to_player_color)
  to_player_color = new_to_player_color
end

--- Set the default color of npc healthbars
---@param new_to_npc_color function
function HealthColor:SetNpcColorFunction(new_to_npc_color)
  to_npc_color = new_to_npc_color
end

function HealthColor:SetBackgroundColorFunction(new_set_background_color)
  set_background_color = new_set_background_color
end

-- Apply functions

function HealthColor:UpdateColor(cuf_frame)
  update_healt_color(cuf_frame)
end

function HealthColor:SetBackgroundColor(cuf_frame)
  set_background_color(cuf_frame)
end
