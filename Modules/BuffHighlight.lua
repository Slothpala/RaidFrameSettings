--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("BuffHighlight")

--------------------
--- Libs & Utils ---
--------------------

local HealthColor = addonTable.HealthColor
local CR = addonTable.CallbackRegistry

------------------------
--- Speed references ---
------------------------

-- WoW Api
--local TableUtil_ContainsAllKeys = TableUtil.ContainsAllKeys currently bugged ? I lack time to further test it but since tww pre patch this was returning false data.


local callback_id
function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.BuffHighlight)

  if next(db_obj.auras) == nil then
    return
  end

  local tracked_auras = {}
  for spell_id, info in next, db_obj.auras do
    if info.own_only then
      if addon:IsPlayerAura(spell_id) then
        tracked_auras[spell_id] = true
      end
    else
      tracked_auras[spell_id] = true
    end
  end

  local highlight_color = db_obj.highlight_color

  local function set_statusbar_to_highlight_color(cuf_frame)
    if not cuf_frame.RFS_FrameEnvironment.debuff_color_override then
      cuf_frame.healthBar:SetStatusBarColor(highlight_color[1], highlight_color[2], highlight_color[3])
    end
  end

  local function contains_all_keys(lhs_table, rhs_table)
    for key, _ in next, rhs_table do
      if not lhs_table[key] then
        return false
      end
    end

    return true
  end

  local function has_all_auras(cuf_frame)
    local compare_table = {}
    cuf_frame.RFS_FrameEnvironment.buffs:Iterate(function(_, aura)
      if aura.sourceUnit == "player" then
        compare_table[aura.spellId] = true
      end
    end)
    return contains_all_keys(compare_table, tracked_auras)
  end

  local function should_use_highlight_color(cuf_frame)
    if db_obj.operation_mode == 1 then -- highlight when present
      return has_all_auras(cuf_frame)
    else
      return not has_all_auras(cuf_frame) -- highlight when missing
    end
  end

  local function on_buffs_changed(cuf_frame)
    if should_use_highlight_color(cuf_frame) then
      set_statusbar_to_highlight_color(cuf_frame)
      -- I called it other_cuf_frame to indicate that it does not have to be the same unit.
      -- If this seems odd see HealthColor.lua.
      cuf_frame.RFS_FrameEnvironment.buff_color_override = function(other_cuf_frame)
        local is_true = should_use_highlight_color(other_cuf_frame)
        if is_true then
          set_statusbar_to_highlight_color(other_cuf_frame)
        end
        return is_true
      end
    else
      HealthColor:UpdateColor(cuf_frame)
    end
  end

  addon:IterateRoster(on_buffs_changed, true)

  callback_id = CR:RegisterCallback("BUFFS_CHANGED", on_buffs_changed)
end

function module:OnDisable()
  CR:UnregisterCallback("BUFFS_CHANGED", callback_id)

  local function restore_color(cuf_frame)
    cuf_frame.RFS_FrameEnvironment.buff_color_override = nil
    HealthColor:UpdateColor(cuf_frame)
  end

  addon:IterateRoster(restore_color, true)
end
