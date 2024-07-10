local addonName = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)

---------------
--- Widgets ---
---------------

L["color_picker_name"] = "Color"
L["color_picker_desc"] = "Choose a color from a color palette."
L["reset_button"] = "Reset"
L["font_slider_name"] = "Font Size"
L["font_slider_desc"] = "Change the size of the font."
L["outlinemode_name"] = "Outline"
L["outlinemode_desc"] = "A font outline defines the exact shape of each letter. This allows letters to be displayed clearly at any size or color."
-- Font
L["font_dropdown_name"] = "Font:"
L["font_dropdown_desc"] = "Font"
L["font_text_color_name"] = "Text Color"
L["font_text_color_desc"] = "Text Color"
L["font_shadow_color_name"] = "Shadow Color"
L["font_shadow_color_desc"] = "The color of the text shadow."
L["font_duration_name"] = "Duration Font"
L["font_stack_name"] = "Stack Font"
-- Horizontal Justification
L["font_horizontal_justification_name"] = "JustifyH"
L["font_horizontal_justification_desc"] = "Text justification refers to how the edges of your text line up within a paragraph."
L["font_justification_left"] = "Left"
L["font_justification_center"] = "Center"
L["font_justification_right"] = "Right"
-- Vertical Justification
L["font_vertical_justification_name"] = "JustifyV"
L["font_vertical_justification_desc"] = "Text justification refers to how the edges of your text line up within a paragraph."
L["font_justification_top"] = "Top"
L["font_justification_middle"] = "Middle"
L["font_justification_bottom"] = "Bottom"

-- Font Flags
L["font_flag_monochrome"] = "Monochrome"
L["font_flag_monochrome_outline"] = "Monochrome Outline"
L["font_flag_monochrome_thick_outline"] = "Monochrome Thick Outline"
L["font_flag_none"] = "None"
L["font_flag_outline"] = "Outline"
L["font_flag_thick_outline"] = "Thick Outline"

---------------
--- Poition ---
---------------

L["point_name"] = "Anchor point:"
L["point_desc"] = "The anchor point on the frame."

L["relative_point_name"] = "Relative point:"
L["relative_point_desc"] = "The point of the other frame to anchor to."

L["offset_x_name"] = "Horizontal offset"
L["offset_x_desc"] = "The horizontal offset of the anchor point in pixels."

L["offset_y_name"] = "Vertical offset"
L["offset_y_desc"] = "The vertical offset of the anchor point in pixels."
L["scale_factor_name"] = "Scale factor"
L["scale_factor_desc"] = "The scale factor."

-- Frame Points
L["frame_point_top_left"] = "Top Left"
L["frame_point_top"] = "Top"
L["frame_point_top_right"] = "Top Right"
L["frame_point_right"] = "Right"
L["frame_point_bottom_right"] = "Bottom Right"
L["frame_point_bottom"] = "Bottom"
L["frame_point_bottom_left"] = "Bottom Left"
L["frame_point_left"] = "Left"
L["frame_point_center"] = "Center"

-- Direction of growth
L["direction_of_growth_vertical_name"] = "Growth vertical:"
L["direction_of_growth_vertical_desc"] = "The vertical direction of growth."
L["vertical_padding_name"] = "Padding vertical:"
L["horizontal_padding_name"] = "Padding horizontal:"
L["padding_desc"] = "The space between indicators."
L["direction_of_growth_horizontal_name"] = "Growth horizontal:"
L["direction_of_growth_horizontal_desc"] = "The horizontal direction of growth."
L["growth_direction_up"] = "Up"
L["growth_direction_down"] = "Down"
L["growth_direction_left"] = "Left"
L["growth_direction_right"] = "Right"
L["num_indicators_per_row_name"] = "Per row"
L["num_indicators_per_row_desc"] = " The number of indicators per row. After that, the aura frame will grow in the vertical growth direction."
L["num_indicators_per_column_name"] = "Per column"
L["num_indicators_per_column_desc"] = "The number of indicators per column. After that, the aura frame will grow in the horizontal growth direction."

-- Indicator visuals
L["indicator_header_name"] = "Aura Frame Settings"
L["indicator_width_name"] = "Icon width"
L["indicator_width_desc"] = "The horizontal dimension of the indicators of this aura frame."
L["indicator_height_name"] = "Icon height"
L["indicator_height_desc"] = "The vertical dimension of the indicators of this aura frame."
L["indicator_border_thicknes_name"] = "Border thickness"
L["indicator_border_thicknes_desc"] = "The border thickness in pixels."
L["indicator_border_color_name"] = "Border color"
L["indicator_border_color_desc"] = "The border color of the indicators of this aura frame."
L["show_swipe_name"] = "Show swipe"
L["show_swipe_desc"] = "Show swipe"
L["reverse_swipe_name"] = "Reverse swipe"
L["reverse_swipe_desc"] = "Reverse swipe"
L["show_edge_name"] = "Show Edge"
L["show_edge_desc"] = "Show Edge"
L["show_tooltip_name"] = "Show tooltip"
L["show_tooltip_desc"] = "Show a tooltip for the indicators of this aura frame."

---------------
--- Modules ---
---------------

--General
L["operation_mode"] = "Operation mode:"
L["operation_mode_option_smart"] = "Smart Mode"
L["operation_mode_option_manual"] = "Manual Mode"

-- Header
L["module_selection_header_name"] = "Enabled Modules"
L["module_selection_header_desc"] = "Enabled Modules"

-- Role Icon
L["module_role_icon_name"] = "Role Icon"
L["module_role_icon_desc"] = "Change the position and size of the role icon and select which roles you want to see it for."
L["role_icon_show_for_dps_name"] = "Show for Dps"
L["role_icon_show_for_dps_desc"] = "Show the sword role icon for units with the \"DAMAGER\" role."
L["role_icon_show_for_heal_name"] = "Show for Heals"
L["role_icon_show_for_heal_desc"] = "Show the cross role icon for units with the \"HEALER\" role."
L["role_icon_show_for_tank_name"] = "Show for Tanks"
L["role_icon_show_for_tank_desc"] = "Show the shield role icon for units with the \"TANK\" role."

-- Solo Frame
L["module_solo_frame_name"] = "Solo Frame"
L["module_solo_frame_desc"] = "Show the player party frame even if you are not in a group."

-- DebuffHighlight
L["module_debuff_highlight_name"] = "Debuff Highlight"
L["module_debuff_highlight_desc"] = "Highlight debuffs that can be dispelled by coloring the affected unit's health bar with the respective dispel color."
L["module_debuff_highlight_operation_mode_desc"] = "\nSmart Mode: The add-on determines which debuffs you can dispel based on your talents.\n\nManual Mode: You can choose which dispel types you want to see. (Curse, Disease, Magic, Poison)"
L["debuff_highlight_show_curses_name"] = "Show Curses"
L["debuff_highlight_show_curses_desc"] = "Highlight debuffs of the dispel type Curse."
L["debuff_highlight_show_diseases_name"] = "Show Diseases"
L["debuff_highlight_show_diseases_desc"] = "Highlight debuffs of the dispel type Disease."
L["debuff_highlight_show_magic_name"] = "Show Magic"
L["debuff_highlight_show_magic_desc"] = "Highlight debuffs of the dispel type Magic."
L["debuff_highlight_show_poisons_name"] = "Show Poisons"
L["debuff_highlight_show_poisons_desc"] = "Highlight debuffs of the dispel type Poison."

-- Resizer
L["module_resizer_name"] = "Resizer"
L["module_resizer_desc"] = "Change the scale of group frame containers."
L["resizer_party_scale_factor_name"] = "Party"
L["resizer_raid_scale_factor_name"] = "Raid"
L["resizer_arena_scale_factor_name"] = "Arena"

-- Range
L["module_range_name"] = "Range"
L["module_range_desc"] = "Adjust the behaviour of frames when units are out of range of the player."
L["range_out_of_range_foregorund_alpha_name"] = "Foreground Alpha"
L["range_out_of_range_foregorund_alpha_desc"] = "The foreground alpha level when a unit is out of range of the player."
L["range_out_of_range_background_alpha_name"] = "Background Alpha"
L["range_out_of_range_background_alpha_desc"] = "The background alpha level when a unit is out of range of the player."
L["range_use_out_of_range_background_color_name"] = "Adjust Background"
L["range_use_out_of_range_background_color_desc"] = "Use a different background color if a unit is out of range of the player."

-- Overabsorb
L["module_overabsorb_name"] = "Overabsorb"
L["module_overabsorb_desc"] = "Health bars can visually represent a unit's remaining absorption shield even if it exceeds the unit's maximum health. This is achieved by extending a separate shield section on the right side of the health bar. The width of this shield section is proportional to the unit's health, making it easy to understand the amount of remaining absorption. For example, a unit with 100,000 HP, full health, and 30,000 absorption shield would have a health bar with 30% of its width filled with a shield indicator."
L["overabsorb_glow_alpha_name"] = "Glow intensity"
L["overabsorb_glow_alpha_desc"] = "The alpha value of the absorb glow."

-- Texture
L["module_texture_name"] = "Texture"
L["module_texture_desc"] = "Change the textures of the health and power bar statusbars."

-- BuffFrame
L["module_buff_frame_name"] = "Buff Frame"
L["module_buff_frame_desc"] = "Replace the default buff frame with one that uses the addons framework. It is much more customizable and allows blacklisting."

-- DebuffFrame
L["module_debuff_frame_name"] = "Debuff Frame"
L["module_debuff_frame_desc"] = "Replace the default debuff frame with one that uses the addons framework. It is much more customizable and allows blacklisting."
L["debuff_frame_show_only_raid_auras_name"] = "Raid Only"
L["debuff_frame_show_only_raid_auras_desc"] = "Show only the auras that the default debuff frame would show if you had selected \"Display Only Dispellable Debuffs\". This includes auras that match the \"RAID\" aura filter and some that are important enough to be shown anyway."
L["debuff_frame_indicator_border_by_dispel_color_name"] = "Dispel Border"
L["debuff_frame_indicator_border_by_dispel_color_desc"] = "Color the border of the indicator according to the dispel type of the aura it represents. If the aura has no dispel type, the default color is used."
L["debuff_frame_duration_font_by_dispel_color_name"] = "Dispel Duration"
L["debuff_frame_duration_font_by_dispel_color_desc"] = "Color the duration text of the indicator according to the dispel type of the aura it represents. If the aura has no dispel type, the default color is used."
L["priv_point_name"] = "Private Anchor"
L["priv_point_desc"] = "The anchor point of the private aura indicator."
L["increase_factor_name"] = "Enlarge factor"
L["increase_factor_desc"] = "The factor of how much an enlarged aura is increased."

-- Aura lists
L["blacklist_name"] = "Blacklist"
L["watchlist_name"] = "Watchlist"
L["increased_auras_name"] = "Enlarge"

-- DefensiveOverlay
L["module_defensive_overlay_name"] = "Defensive Overlay"
L["module_defensive_overlay_desc"] = "The Defensive Overlay is an easy-to-setup aura group that displays active defensive cooldowns in a separate, customizable area of the raid frame. The Defensive Overlay tab allows you to select which auras to display and where to place them."


-- AuraGroups
L["module_aura_groups_name"] = "Aura Groups"
L["module_aura_groups_desc"] = "Aura Groups are aura frames (like Buff & Debuff Frames), but contain only auras of your choice and can be a mix of both buffs and debuffs. They can be placed anywhere on the raid frame."

-- RaidFrameColor
L["module_raid_frame_color_name"] = "Health Color Settings"
L["module_raid_frame_color_desc"] = "Health Color Settings"
L["raid_frame_color_health_operation_mode_desc"] = "\nClass\\Reaction: Color health bars based on unit class or NPC reaction. The colors used can be changed in the AddOn Colors tab.\n\nStatic: Choose a single static color to use for all health bars, regardless of class or reaction."
L["raid_frame_color_operation_mode_class"] = "Class\\Reaction - Color"
L["raid_frame_color_operation_mode_static"] = "Static"
L["raid_frame_color_foreground_use_gradient_name"] = "Use Gradient"
L["raid_frame_color_foreground_use_gradient_desc"] = "Use a gradient for the color of the foreground."
L["raid_frame_color_static_normal_color_name"] = "Static Color"
L["raid_frame_color_static_normal_color_desc"] = "The color that will be applied to the textures."
L["raid_frame_color_static_min_color_name"] = "Static Color - Beginning"
L["raid_frame_color_static_min_color_desc"] = "The starting color of the gradient."
L["raid_frame_color_static_max_color_name"] = "Static Color - Ending  "
L["raid_frame_color_static_max_color_desc"] = "The final color of the gradient"
L["raid_frame_color_background_use_gradient_name"] = "Use Gradient"
L["raid_frame_color_background_use_gradient_desc"] = "Use a gradient for the color of the background."
L["raid_frame_color_power_operation_mode_desc"] = "\nPower Type: Color power bars based on units power type. The colors used can be changed in the AddOn Colors tab.\n\nStatic: Choose a single static color to use for all power bars, regardless of their power type."
L["raid_frame_color_operation_mode_power"] = "Power Type"
L["raid_frame_health_bar_color_foreground"] = "Health Bar Foreground"
L["raid_frame_health_bar_color_background"] = "Health Bar Background"
L["raid_frame_power_bar_color_foreground"] = "Power Bar Foreground"
L["raid_frame_power_bar_color_background"] = "Power Bar Background"

-- Texture
L["module_texture_header_name"] = "Texture Settings"
L["module_texture_header_desc"] = "Texture Settings"
L["texture_health_bar_foreground_name"] = "Health bar foreground"
L["texture_health_bar_background_name"] = "Health bar background"
L["texture_power_bar_foreground_name"] = "Power bar foreground"
L["texture_power_bar_background_name"] = "Power bar background"
L["texture_detach_power_bar_name"] = "Detach"
L["texture_detach_power_bar_desc"] = "Detach the Power Bar and place it freely on the Heath Bar. The fill direction changes when height is greater than width."
L["texture_power_bar_width_name"] = "Width"
L["texture_power_bar_width_desc"] = "The width of the power bar in % relative to the health bar."
L["texture_power_bar_height_name"] = "Height"
L["texture_power_bar_height_desc"] = "The height of the power bar in % relative to the health bar."

-- Font
L["module_font_name"] = "Name & Status Text"
L["module_font_desc"] = "Enable font customization for the name and status text."
L["font_name_header"] = "Name Text"
L["font_name_class_colored_name"] = "Class colored"
L["font_name_class_colored_desc"] = "Color the text in the units class color."
L["font_name_show_server_name"] = "Show Realm"
L["font_name_show_server_desc"] = "Display the name of the realm next to the name of the player"
L["font_status_header"] = "Status Text"

-- Aura Groups
L["aura_groups_menu_band_name"] = "Create Groups"
L["create_aura_group_name"] = "Create Group:"
L["create_aura_group_desc"] = "Create a new aura group. The aura group will do nothing of its own. You must add auras to the group. You can do this by clicking on: "
L["edit_grp_btn_name"] = "Edit"
L["edit_grp_btn_desc"] = "Edit the group's auras and position and dimension on the raid frame."
L["edit_grp_title"] = "You are currently editing the group:"
L["add_aura_to_grp_name"] = "Add Aura:"
L["add_aura_to_grp_desc"] = "Add an aura to this group by entering the spellId of the aura and pressing okay."
L["aura_groups_own_only_name"] = "Own only"
L["aura_groups_own_only_desc"] = "Only track the aura if you, the player, are the source unit of the aura."
L["aura_groups_show_glow_name"] = "Glow aura"
L["aura_groups_show_glow_desc"] = "Highlight the aura indicator with a glowing animation."
L["enlarge_aura_name"] = "Enlarge"
L["enlarge_aura_desc"] = "Enlarge the aura as if it were a boss aura."
L["aura_groups_track_if_missing_name"] = "Track Missing"
L["aura_groups_track_if_missing_desc"] = "Display a desaturated aura indicator for this aura if the aura is missing."
L["aura_groups_track_if_present_name"] = "Track Active"
L["aura_groups_track_if_present_desc"] = "Display the aura indicator when the aura is present on the unit."

-- Buff Highlight
L["module_buff_highlight_name"] = "Buff Highlight"
L["module_buff_highlight_desc"] = "Highlight missing or present buffs by coloring the affected unit's health bar with a highlight color."
L["buff_highlight_operation_mode_desc"] = "\nPresent Mode: Highlight when present.\n\nMissing Mode: Highlight when missing"
L["buff_highlight_option_present"] = "Present"
L["buff_highlight_option_missing"] = "Missing"
L["buff_highlight_edit_auras_name"] = "Edit Auras"
L["buff_highlight_edit_auras_desc"] = "Edit Auras"

------------
--- Tabs ---
------------

L["general_options_tab_name"] = "General"
L["module_selection_tab_name"] = "Module Center"
L["addon_colors_tab_name"] = "AddOn Colors"
L["font_options_tab_name"] = "Fonts"
L["defensive_overlay_options_tab_name"] = "Defensive Overlay"
L["buff_frame_options_tab_name"] = "Buffs"
L["debuff_frame_options_tab_name"] = "Debuffs"
L["profiles_options_tab_name"] = "Profiles"
L["aura_groups_tab_name"] = "Aura Groups"

--------------------
--- AddOn Colors ---
--------------------

L["class_colors_tab_name"] = "Class Colors"
L["power_colors_tab_name"] = "Power Colors"
L["dispel_type_colors_tab_name"] = "Dispel Colors"
L["color_reset_button_desc"] = "Reset the colors back to default."
L["normal_color_name"] = "Normal - Color"
L["normal_color_desc"] = "The \"normal\" color, used when no gradient is used or when a gradient is not an option."
L["min_color_name"] = "Beginning - Color"
L["min_color_desc"] = "The color at the beginning of a gradient."
L["max_color_name"] = "Ending - Color"
L["max_color_desc"] = "The color at the end of a gradient."
L["Magic"] = true
L["Disease"] = true
L["Poison"] = true
L["Curse"] = true

----------------
--- Profiles ---
----------------

--Profile Management:
L["profile_management_group_name"] = "Profile Management"
L["share_profile_title"] = "Import/Export Profile"
L["export_profile_input_title"] = "To export your current profile copy the code below."
L["import_profile_input_title"] = "To import a profile paste the profile string below and press \"Accept.\""
L["import_profile_confirm_msg"] = "Caution: Importing a profile will overwrite your current profile."
L["import_profile_btn_name"] = "Import Profile"
L["import_profile_btn_desc"] = "Import Profile"
L["export_profile_btn_name"] = "Export Porfile"
L["export_profile_btn_desc"] = "Export Porfile"
--Porfile import error handling:
L["import_empty_string_error"] = "No import string provided. Abort"
L["import_decoding_failed_error"] = "Decoding failed. Abort"
L["import_uncompression_failed_error"] = "Uncompressing failed. Abort"
L["invalid_profile_error"] = "Invalid profile. Abort"
L["import_incompatible_profile_error"] = "The profile you are trying to import is not compatible."
L["party_profile_name"] = "Party"
L["raid_profile_name"] = "Raid"
L["arena_profile_name"] = "Arena"
L["battleground_profile_name"] = "Battleground"
L["active_spec_indicator"] = "Active"

----------------------
--- Aura Menu Band ---
----------------------

L["aura_meanu_band_name"] = " "
L["add_to_blacklist_name"] = "Add to \124cFFEE4B2Bblacklist\124r:"
L["add_to_watchlist_name"] = "Add to \124cFF00FF7Fwatchlist\124r:"
L["spell_id_input_field_desc"] = "Enter spellid"
L["spell_id_wrong_input_notification"] = "It looks like the spell ID is invalid. Spell IDs should be lists of numbers between 0 and 9. Please try again."
L["settings_toggle_button_show_name"] = "Show Settings"
L["settings_toggle_button_show_desc"] = "Displays the aura frame settings for this group. This displays a menu bar with controls for changing the appearance and behavior of the aura frame."
L["settings_toggle_button_hide_name"] = "Hide Settings"
L["settings_toggle_button_hide_desc"] = "Hide the aura frame settings. Once you have setup the aura frame visuals you can hide the above menu band by clicking this button."
L["remove_button_name"] = "Remove"
L["remove_button_desc"] = "from the list"


-----------------------
--- Mini Map Button ---
-----------------------

L["module_mini_map_button_name"] = "Minimap Button"
L["module_mini_map_button_desc"] = "Enable a minimap button to control the addon."
L["mini_map_tooltip_left_button_text"] = "Left button: Toggle the settings."
L["mini_map_tooltip_right_button_text"] = "Right button: Reload the addon."

----------------
--- Messages ---
----------------

L["option_open_after_combat_msg"] = "The options will open after combat."
L["mini_map_in_combat_warning"] = "Reloading during combat is not allowed as it may break your UI."
