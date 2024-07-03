local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("AuraGroups")

--------------------
--- Libs & Utils ---
--------------------
local Media = LibStub("LibSharedMedia-3.0")
local CR = addonTable.CallbackRegistry

------------------------
--- Speed references ---
------------------------

-- WoW Api


local callback_ids = {}
function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.AuraGroups)
  local db_obj_font_duration = CopyTable(addon.db.profile.AuraGroupsDurationFont)
  local db_obj_font_stack = CopyTable(addon.db.profile.AuraGroupsStackFont)
  -- Fetch DB values
  local path_to_duration_font = Media:Fetch("font", db_obj_font_duration.font)
  local path_to_stack_font = Media:Fetch("font", db_obj_font_stack.font)

  -- Update the lists
  addon:UpdateWhitelist()
  addon:UpdateGlowAuraList()

  for _, aura_group in next, db_obj.aura_groups do
    if next(aura_group.auras) then
      -- Create the aura frame options table
      local aura_frame_options = {
        -- Position
        anchor_point = aura_group.point,
        relative_point = aura_group.relative_point,
        offset_x = aura_group.offset_x,
        offset_y = aura_group.offset_y,
        -- Num indicators row*column
        num_indicators_per_row = aura_group.num_indicators_per_row,
        num_indicators_per_column = aura_group.num_indicators_per_column,
        -- Orientation
        direction_of_growth_vertical = aura_group.direction_of_growth_vertical,
        vertical_padding = aura_group.vertical_padding,
        direction_of_growth_horizontal = aura_group.direction_of_growth_horizontal,
        horizontal_padding = aura_group.horizontal_padding,
        -- Indicator size
        indicator_width = aura_group.indicator_width,
        indicator_height = aura_group.indicator_height,
        -- Indicator border
        indicator_border_thickness = aura_group.indicator_border_thickness,
        indicator_border_color = aura_group.indicator_border_color,
        -- Font: Duration
        path_to_duration_font = path_to_duration_font,
        duration_font_size = db_obj_font_duration.font_size,
        duration_font_outlinemode = db_obj_font_duration.font_outlinemode,
        duration_font_color = db_obj_font_duration.text_color,
        duration_font_point = db_obj_font_duration.point,
        duration_font_relative_point = db_obj_font_duration.relative_point,
        duration_font_offset_x = db_obj_font_duration.offset_x,
        duration_font_offset_y = db_obj_font_duration.offset_y,
        duration_font_shadow_color =  db_obj_font_duration.shadow_color,
        duration_font_shadow_offset_x = db_obj_font_duration.shadow_offset_x,
        duration_font_shadow_offset_y = db_obj_font_duration.shadow_offset_y,
        duration_font_horizontal_justification = db_obj_font_duration.horizontal_justification,
        duration_font_vertical_justification = db_obj_font_duration.vertical_justification,
        -- Font: Stack
        path_to_stack_font = path_to_stack_font,
        stack_font_size = db_obj_font_stack.font_size,
        stack_font_outlinemode = db_obj_font_stack.font_outlinemode,
        stack_font_color = db_obj_font_stack.text_color,
        stack_font_point = db_obj_font_stack.point,
        stack_font_relative_point = db_obj_font_stack.relative_point,
        stack_font_offset_x = db_obj_font_stack.offset_x,
        stack_font_offset_y = db_obj_font_stack.offset_y,
        stack_font_shadow_color =  db_obj_font_stack.shadow_color,
        stack_font_shadow_offset_x = db_obj_font_stack.shadow_offset_x,
        stack_font_shadow_offset_y = db_obj_font_stack.shadow_offset_y,
        stack_font_horizontal_justification = db_obj_font_stack.horizontal_justification,
        stack_font_vertical_justification = db_obj_font_stack.vertical_justification,
        -- Cooldown
        show_swipe = aura_group.show_swipe,
        reverse_swipe = aura_group.reverse_swipe,
        show_edge = aura_group.show_edge,
        -- Tooltip
        show_tooltip = aura_group.show_tooltip,
      }

      -- Check if the aura frame tracks missing auras.
      local missing_list = {}
      local present_list = {}
      for spell_id, aura_info in next, aura_group.auras do
        if aura_info.track_if_missing then
          missing_list[spell_id] = true
        end
        if aura_info.track_if_present then
          present_list[spell_id] = true
        end
      end

      -- Create a callback to create an aura frame when a new frame env is created.
      local function create_or_update_aura_group(cuf_frame)
        if not cuf_frame.RFS_FrameEnvironment.aura_frames[aura_group.name] then
          cuf_frame.RFS_FrameEnvironment.aura_frames[aura_group.name] = addon:NewAuraFrame(cuf_frame)
        end
        cuf_frame.RFS_FrameEnvironment.aura_frames[aura_group.name]:Enable(aura_frame_options)
        -- If missing auras should be tracked, change the Update function.

        local aura_frame = cuf_frame.RFS_FrameEnvironment.aura_frames[aura_group.name]
        aura_frame.Update = function(self, aura_table)
          local indicator_pos = 1

          local present_auras = {}

          aura_table:Iterate(function(auraInstanceID, aura)
            if indicator_pos > self.num_indicators then
              return true
            end

            if present_list[aura.spellId] then
              self.indicators[indicator_pos]:SetAura(aura)
              if self.on_set_aura_callback then
                self.on_set_aura_callback(self.indicators[indicator_pos], aura)
              end
              indicator_pos = indicator_pos + 1
            end

            present_auras[aura.spellId] = true

            return false
          end)

          for spell_id, _ in next, missing_list do
            if indicator_pos > self.num_indicators then
              return true
            end

            if not present_auras[spell_id] then
              self.indicators[indicator_pos]:SetMissingAura(spell_id)
              indicator_pos = indicator_pos + 1
            end
          end

          for i=indicator_pos, self.num_indicators do
            self.indicators[i]:Clear()
          end
        end

      end
      -- Place the callback in the callback table.
      addonTable.on_create_frame_env_callbacks[aura_group.name] = create_or_update_aura_group



      -- Handle Aura Changes
      local function on_auras_changed(cuf_frame)
        cuf_frame.RFS_FrameEnvironment.aura_frames[aura_group.name]:Update(cuf_frame.RFS_FrameEnvironment.grouped_auras[aura_group.name])
      end

      -- Register the spell ids for the aura group. The cuf_frames frame env will use this name as the update notifier event.
      addon:RegisterAuraGroup(aura_group.name, aura_group.auras)
      -- Register the DefensiveOverlay callback
      local id = CR:RegisterCallback(aura_group.name, on_auras_changed)
      callback_ids[aura_group.name] = id

      addon:IterateRoster(function(cuf_frame)
        create_or_update_aura_group(cuf_frame)
        if cuf_frame.unit and cuf_frame:IsShown() then
          addon:CreateOrUpdateAuraScanner(cuf_frame)
        end
      end, true)
    end
  end
end

function module:OnDisable()
  -- Update the whitelist.
  addon:UpdateWhitelist()
  addon:UpdateGlowAuraList()
  -- Those modules also use the aura_frame table but should not be disabled here.
  local dont_remove = {
    ["BuffFrame"] = true,
    ["DebuffFrame"] = true,
    ["DefensiveOverlay"] = true,
  }

  for aura_group_name, id in next, callback_ids do
    CR:UnregisterCallback(aura_group_name, id)
  end
  callback_ids = {}

  local function delete_aura_groups(cuf_frame)
    for aura_group_name, aura_frame in next, cuf_frame.RFS_FrameEnvironment.aura_frames do
      if not dont_remove[aura_group_name] then
        addon:UnregisterAuraGroup(aura_group_name)
        aura_frame:Disable()
      end
    end
    if cuf_frame.unit and cuf_frame:IsShown() then
      addon:CreateOrUpdateAuraScanner(cuf_frame)
    end
  end
  addon:IterateRoster(delete_aura_groups, true)
end
