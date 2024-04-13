local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
addonTable.HealthColor = {}
local HealthColor = addonTable.HealthColor
Mixin(HealthColor, addonTable.hooks)


-- Block color updates for aura modules
local prio_block = "dispel" -- In case we want to add an option to prioritize blocks
local is_color_locked = {}

function HealthColor:LockColor(frame, callback, lock_reason)
   is_color_locked[frame] = is_color_locked[frame] or {}
   is_color_locked[frame][lock_reason] = callback
end

function HealthColor:RemoveLockReason(frame, lock_reason)
   if not is_color_locked[frame] then
      return
   end
   is_color_locked[frame][lock_reason] = nil
end

-- Color restore functions
local use_custom_override_color = false
local custom_override_color = {r=0,g=0,b=0,a=1}

local restore_color = function (frame_env, frame)

end

function HealthColor:SetRestoreFunction()
   --colors
   local health_bars_enabeld = addon.db.profile.Module.HealthBars
   local selected = addon.db.profile.HealthBars.Colors.statusbarmode
   local raid_frame_display_class_color = C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" and true or false

   local use_class_colors 
   if ( health_bars_enabeld and selected == 1 ) or (not health_bars_enabeld and raid_frame_display_class_color ) then
      use_class_colors = true
   end
   local use_override_color 
   if ( health_bars_enabeld and selected == 2 ) or (not health_bars_enabeld and not raid_frame_display_class_color ) then
      use_override_color = true
   end
   use_custom_override_color = not use_class_colors and not use_override_color

   if use_class_colors then
      if C_CVar.GetCVar("raidFramesDisplayClassColor") == "0" then
         C_CVar.SetCVar("raidFramesDisplayClassColor","1")
      end
      restore_color = function(frame_env, frame)
         -- TODO frame_env
         local _, english_class = UnitClass(frame.unit)
         local r,g,b = GetClassColor(english_class)
         frame.healthBar:SetStatusBarColor(r, g, b)
         if (frame.optionTable.colorHealthWithExtendedColors) then
            frame.selectionHighlight:SetVertexColor(r, g, b)
         else
            frame.selectionHighlight:SetVertexColor(1, 1, 1)
         end
      end
   elseif use_override_color then
      if C_CVar.GetCVar("raidFramesDisplayClassColor") == "1" then
         C_CVar.SetCVar("raidFramesDisplayClassColor", "0")
      end
      restore_color = function(frame_env, frame)
         local override_color = {r = 0, g = 1, b = 0}
         frame.healthBar:SetStatusBarColor(override_color.r, override_color.g, override_color.b)
         if (frame.optionTable.colorHealthWithExtendedColors) then
            frame.selectionHighlight:SetVertexColor(override_color.r, override_color.g, override_color.b)
         else
            frame.selectionHighlight:SetVertexColor(1, 1, 1)
         end
      end
   else 
      local custom_color = addon.db.profile.HealthBars.Colors.statusbar
      custom_override_color = custom_color
      restore_color = function(frame_env, frame)
         frame.healthBar:SetStatusBarColor(custom_color.r, custom_color.g, custom_color.b)
         if (frame.optionTable.colorHealthWithExtendedColors) then
            frame.selectionHighlight:SetVertexColor(custom_color.r, custom_color.g, custom_color.b)
         else
            frame.selectionHighlight:SetVertexColor(1, 1, 1)
         end
      end
   end
end
--HealthColor:SetRestoreFunction() do in OnInitialize

function HealthColor:RestoreColor(frame)
   restore_color(_, frame)
end

function HealthColor:GetRestoreFunction()
   return restore_color
end

-- The code below is a modified version of Blizzards CompactUnitFrame_UpdateHealthColor()
HealthColor:HookFuncFiltered("CompactUnitFrame_UpdateHealthColor", function(frame_env, frame)
   -- Check if a dispel is present
   if is_color_locked[frame] then
      local callback = is_color_locked[frame][prio_block] or next(is_color_locked[frame])
      if callback then
         callback(frame_env, frame)
         return
      end
   end
   -- Follow Blizzards color scheme 
   local r, g, b
	local unit_is_connected = UnitIsConnected(frame.unit)
	local unit_is_dead = unit_is_connected and UnitIsDead(frame.unit)
	local unit_is_player = UnitIsPlayer(frame.unit) or UnitIsPlayer(frame.displayedUnit)

   if ( not unit_is_connected or (unit_is_dead and not unit_is_player) ) then
		-- Color it gray
		r, g, b = 0.5, 0.5, 0.5
   else
      if frame.optionTable.healthBarColorOverride or use_custom_override_color then
         -- Color it either by Blizzarsds green color or the user set color
         local override_color = use_custom_override_color and custom_override_color or frame.optionTable.healthBarColorOverride
         r, g, b = override_color.r, override_color.g, override_color.b
      else
         -- TODO once frame_env is implemented use cached data
         -- Try to color it by class
         local _, english_class = UnitClass(frame.unit)
         local class_color = RAID_CLASS_COLORS[english_class]
         local use_class_colors = CompactUnitFrame_GetOptionUseClassColors(frame, frame.optionTable)
         if ( (frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit) or UnitTreatAsPlayerForDisplay(frame.unit)) and class_color and use_class_colors ) then
            -- Use class colors for players if class color option is turned on
            r, g, b = class_color.r, class_color.g, class_color.b
         elseif ( CompactUnitFrame_IsTapDenied(frame) ) then
            -- Use grey if not a player and can't get tap on unit
            r, g, b = 0.9, 0.9, 0.9
         elseif ( UnitIsFriend("player", frame.unit) ) then
            r, g, b = 0.0, 1.0, 0.0
         else
            r, g, b = 1.0, 0.0, 0.0
         end
      end
   end
   
   local old_r, old_g, old_b = frame.healthBar:GetStatusBarColor()
   if ( r ~= old_r or g ~= old_g or b ~= old_b ) then
      frame.healthBar:SetStatusBarColor(r, g, b)

      if (frame.optionTable.colorHealthWithExtendedColors) then
         frame.selectionHighlight:SetVertexColor(r, g, b)
      else
         frame.selectionHighlight:SetVertexColor(1, 1, 1);
      end
   end

end)