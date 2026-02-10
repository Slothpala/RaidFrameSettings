local addonName = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhTW", false, true)
if not L then return end

-- Categories.
L["general_settings"] = "通用"
L["text_settings"] = "文字"
L["aura_frame_settings"] = "光環"
L["profiles_settings"] = "設定檔"

-- Titles.
L["title_colors"] = "顏色"
L["textures"] = "材質"
L["fonts"] = "字體"
L["blizzard_settings_unit_frames"] = "單位框體"
L["title_name"] = "名稱"
L["title_status"] = "狀態"

-- Settings.
L["health_bar_fg"] = "生命條前景"
L["health_bar_bg"] = "生命條背景"
L["power_bar_fg"] = "能量條前景"
L["power_bar_bg"] = "能量條背景"

L["option_font"] = "字體"
L["option_player_color"] = "玩家顏色"
L["option_npc_color"] = "NPC顏色"
L["option_anchor"] = "位置"

L["border_color"] = "邊框顏色"

L["option_power_bars"] = "能量條"
L["option_show"] = "顯示"
L["option_hide"] = "隱藏"
L["option_healer_only"] = "僅治療者"
L["option_darkening_factor"] = "變暗系數"
L["option_disabled"] = "禁用"
L["option_dispellable_by_me"] = "可由我驅散"
L["option_show_all"] = "顯示全部"

-- Display Health
L["option_health_text_display_mode"] = "顯示生命值文字"
L["option_health_none"] = "無"
L["option_health_health"] = "剩餘生命值"
L["option_health_lost"] = "損失生命值"
L["option_health_perc"] = "生命值百分比"

-- Color Options.
L["class"] = "職業"
L["class_gradient"] = "漸變職業"
L["static"] = "靜態"
L["static_gradient"] = "漸變靜態"
L["health_value"] = "生命值"
L["power_type"] = "能量類型"
L["power_type_gradient"] = "漸變能量類型"
L["class_to_health_value"] = "職業 -> 生命值"

-- Colors.
L["static_color"] = "顏色"
L["gradient_start"] = "漸變起始"
L["gradient_end"] = "漸變結束"

-- CVars
L["display_pets"] = "顯示寵物"
L["display_aggro_highlight"] = "顯示仇恨高亮"
L["display_incoming_heals"] = "顯示即將到來的治療"
L["display_main_tank_and_assist"] = "顯示主坦克和助理"
L["center_big_defensive"] = "居中大型防禦"
L["dispellable_debuff_indicator"] = "可驅散減益指示器"
L["dispellable_debuff_color"] = "可驅散減益顏色"

-- Anchors
L["to_frames"] = "到框體"
L["offset_x"] = "X軸偏移"
L["offset_y"] = "Y軸偏移"
L["frame_point_top_left"] = "左上"
L["frame_point_top"] = "上"
L["frame_point_top_right"] = "右上"
L["frame_point_right"] = "右"
L["frame_point_bottom_right"] = "右下"
L["frame_point_bottom"] = "下"
L["frame_point_bottom_left"] = "左下"
L["frame_point_left"] = "左"
L["frame_point_center"] = "中"

-- Font Settings.
L["outline"] = "輪廓"
L["thick"] = "粗"
L["monochrome"] = "單色"
L["font_height"] = "高度"
L["text_horizontal_justification"] = "水平對齊"
L["text_horizontal_justification_option_left"] = "左"
L["text_horizontal_justification_option_center"] = "中"
L["text_horizontal_justification_option_right"] = "右"
L["text_vertical_justification"] = "垂直對齊"
L["text_horizontal_justification_option_top"] = "上"
L["text_horizontal_justification_option_middle"] = "中"
L["text_horizontal_justification_option_bottom"] = "下"
L["max_length"] = "長度"

-- Modules.
L["clean_borders"] = "清理高亮"
L["role_icon"] = "角色圖示"
L["role_icon_slection"] = "顯示職責圖示"
L["role_icon_scale"] = "職責圖示縮放"
L["unit_group_role_tank"] = "坦克"
L["unit_group_role_heal"] = "治療"
L["unit_group_role_dps"] = "傷害輸出"
L["raid_mark_pos"] = "團隊標記位置"
L["raid_mark_scale"] = "團隊標記縮放"
L["settings_text_solo_frame"] = "單人時顯示"

-- Profiles
L["profiles_header_1"] = "設定檔 - 當前設定檔："
L["create_profile"] = "建立新設定檔"
L["reset_profile"] = "重置設定檔"
L["delete_profile"] = "刪除設定檔"
L["copy_profile"] = "複製設定檔"
L["party_profile"] = "小隊"
L["raid_profile"] = "團隊"
L["arena_profile"] = "競技場"
L["battleground_profile"] = "戰場"

-- Labels
L["label_create"] = "建立"
L["label_reset"] = "重置"
