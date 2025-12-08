local addonName = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "ruRU")
if not L then return end

--Translator ZamestoTV

---------------
--- Widgets ---
---------------

L["color_picker_name"] = "Цвет"
L["color_picker_desc"] = "Выберите цвет из палитры."
L["reset_button"] = "Сброс"
L["font_slider_name"] = "Размер шрифта"
L["font_slider_desc"] = "Изменение размера шрифта."
L["outlinemode_name"] = "Обводка"
L["outlinemode_desc"] = "Обводка шрифта определяет точную форму каждой буквы. Это позволяет отображать буквы чётко при любом размере и цвете."
-- Font
L["font_dropdown_name"] = "Шрифт:"
L["font_dropdown_desc"] = "Шрифт"
L["font_text_color_name"] = "Цвет текста"
L["font_text_color_desc"] = "Цвет текста"
L["font_shadow_color_name"] = "Цвет тени"
L["font_shadow_color_desc"] = "Цвет тени текста."
L["font_duration_name"] = "Шрифт длительности"
L["font_stack_name"] = "Шрифт стаков"
-- Horizontal Justification
L["font_horizontal_justification_name"] = "Горизонтальное выравнивание"
L["font_horizontal_justification_desc"] = "Выравнивание текста определяет, как края строки текста выравниваются внутри абзаца."
L["font_justification_left"] = "По левому краю"
L["font_justification_center"] = "По центру"
L["font_justification_right"] = "По правому краю"
-- Vertical Justification
L["font_vertical_justification_name"] = "Вертикальное выравнивание"
L["font_vertical_justification_desc"] = "Выравнивание текста определяет, как края строки текста выравниваются внутри абзаца."
L["font_justification_top"] = "По верху"
L["font_justification_middle"] = "По центру"
L["font_justification_bottom"] = "По низу"
-- Font Flags
L["font_flag_monochrome"] = "Монохром"
L["font_flag_monochrome_outline"] = "Монохромная обводка"
L["font_flag_monochrome_thick_outline"] = "Монохромная толстая обводка"
L["font_flag_none"] = "Нет"
L["font_flag_outline"] = "Обводка"
L["font_flag_thick_outline"] = "Толстая обводка"

---------------
--- Position ---
---------------

L["point_name"] = "Точка привязки:"
L["point_desc"] = "Точка привязки на фрейме."

L["relative_point_name"] = "Относительная точка:"
L["relative_point_desc"] = "Точка другого фрейма, к которой осуществляется привязка."

L["offset_x_name"] = "Смещение по горизонтали"
L["offset_x_desc"] = "Горизонтальное смещение точки привязки в пикселях."

L["offset_y_name"] = "Смещение по вертикали"
L["offset_y_desc"] = "Вертикальное смещение точки привязки в пикселях."
L["scale_factor_name"] = "Масштаб"
L["scale_factor_desc"] = "Коэффициент масштабирования."

-- Frame Points
L["frame_point_top_left"] = "Верхний левый"
L["frame_point_top"] = "Верх"
L["frame_point_top_right"] = "Верхний правый"
L["frame_point_right"] = "Правый"
L["frame_point_bottom_right"] = "Нижний правый"
L["frame_point_bottom"] = "Низ"
L["frame_point_bottom_left"] = "Нижний левый"
L["frame_point_left"] = "Левый"
L["frame_point_center"] = "Центр"

-- Direction of growth
L["direction_of_growth_vertical_name"] = "Рост по вертикали:"
L["direction_of_growth_vertical_desc"] = "Направление роста по вертикали."
L["vertical_padding_name"] = "Отступ по вертикали:"
L["horizontal_padding_name"] = "Отступ по горизонтали:"
L["padding_desc"] = "Пространство между индикаторами."
L["direction_of_growth_horizontal_name"] = "Рост по горизонтали:"
L["direction_of_growth_horizontal_desc"] = "Направление роста по горизонтали."
L["growth_direction_up"] = "Вверх"
L["growth_direction_down"] = "Вниз"
L["growth_direction_left"] = "Влево"
L["growth_direction_right"] = "Вправо"
L["num_indicators_per_row_name"] = "В строке"
L["num_indicators_per_row_desc"] = "Количество индикаторов в строке. После этого фрейм аур будет расти в направлении вертикального роста."
L["num_indicators_per_column_name"] = "В столбце"
L["num_indicators_per_column_desc"] = "Количество индикаторов в столбце. После этого фрейм аур будет расти в направлении горизонтального роста."

-- Indicator visuals
L["indicator_header_name"] = "Настройки фрейма аур"
L["indicator_width_name"] = "Ширина иконки"
L["indicator_width_desc"] = "Горизонтальный размер индикаторов этого фрейма аур."
L["indicator_height_name"] = "Высота иконки"
L["indicator_height_desc"] = "Вертикальный размер индикаторов этого фрейма аур."
L["indicator_border_thicknes_name"] = "Толщина рамки"
L["indicator_border_thicknes_desc"] = "Толщина рамки в пикселях."
L["indicator_border_color_name"] = "Цвет рамки"
L["indicator_border_color_desc"] = "Цвет рамки индикаторов этого фрейма аур."
L["show_swipe_name"] = "Показывать затухание"
L["show_swipe_desc"] = "Показывать затухание"
L["reverse_swipe_name"] = "Обратить затухание"
L["reverse_swipe_desc"] = "Обратить затухание"
L["show_edge_name"] = "Показывать край"
L["show_edge_desc"] = "Показывать край"
L["show_tooltip_name"] = "Показывать подсказку"
L["show_tooltip_desc"] = "Показывать подсказку для индикаторов этого фрейма аур."
L["show_cooldown_numbers_name"] = "Числа кулдауна"
L["show_cooldown_numbers_desc"] = "Показывать обратный отсчёт кулдаунов."

---------------
--- Modules ---
---------------

--General
L["operation_mode"] = "Режим работы:"
L["operation_mode_option_smart"] = "Умный режим"
L["operation_mode_option_manual"] = "Ручной режим"

-- Header
L["module_selection_header_name"] = "Включённые модули"
L["module_selection_header_desc"] = "Включённые модули"

-- Role Icon
L["module_role_icon_name"] = "Иконка роли"
L["module_role_icon_desc"] = "Изменение позиции и размера иконки роли, а также выбор, для каких ролей её показывать."
L["role_icon_show_for_dps_name"] = "Показывать для ДПС"
L["role_icon_show_for_dps_desc"] = "Показывать иконку меча для юнитов с ролью «БОЕЦ»."
L["role_icon_show_for_heal_name"] = "Показывать для лекарей"
L["role_icon_show_for_heal_desc"] = "Показывать иконку креста для юнитов с ролью «ЛЕЧИТЕЛЬ»."
L["role_icon_show_for_tank_name"] = "Показывать для танков"
L["role_icon_show_for_tank_desc"] = "Показывать иконку щита для юнитов с ролью «ТАНК»."

-- Solo Frame
L["module_solo_frame_name"] = "Фрейм в соло"
L["module_solo_frame_desc"] = "Показывать фрейм группы для игрока даже когда вы не в группе."

-- DebuffHighlight
L["module_debuff_highlight_name"] = "Подсветка дебаффов"
L["module_debuff_highlight_desc"] = "Подсвечивать дебаффы, которые можно развеять, окрашивая полосу здоровья поражённого юнита в соответствующий цвет развеивания."
L["module_debuff_highlight_operation_mode_desc"] = "\nУмный режим: аддон сам определяет, какие дебаффы вы можете развеять, исходя из ваших талантов.\n\nРучной режим: вы сами выбираете, какие типы развеивания показывать (Проклятие, Болезнь, Магия, Яд)"
L["debuff_highlight_show_curses_name"] = "Показывать проклятия"
L["debuff_highlight_show_curses_desc"] = "Подсвечивать дебаффы типа «Проклятие»."
L["debuff_highlight_show_diseases_name"] = "Показывать болезни"
L["debuff_highlight_show_diseases_desc"] = "Подсвечивать дебаффы типа «Болезнь»."
L["debuff_highlight_show_magic_name"] = "Показывать магию"
L["debuff_highlight_show_magic_desc"] = "Подсвечивать дебаффы типа «Магия»."
L["debuff_highlight_show_poisons_name"] = "Показывать яды"
L["debuff_highlight_show_poisons_desc"] = "Подсвечивать дебаффы типа «Яд»."
L["debuff_highlight_highlight_texture_name"] = "Текстура подсветки"

-- Resizer
L["module_resizer_name"] = "Изменение размера"
L["module_resizer_desc"] = "Изменение масштаба контейнеров групповых фреймов."
L["resizer_party_scale_factor_name"] = "Группа"
L["resizer_raid_scale_factor_name"] = "Рейд"
L["resizer_arena_scale_factor_name"] = "Арена"

-- Range
L["module_range_name"] = "Дальность"
L["module_range_desc"] = "Настройка поведения фреймов, когда юниты находятся вне зоны досягаемости игрока."
L["range_out_of_range_foregorund_alpha_name"] = "Прозрачность переднего плана"
L["range_out_of_range_foregorund_alpha_desc"] = "Уровень прозрачности переднего плана, когда юнит вне зоны досягаемости."
L["range_out_of_range_background_alpha_name"] = "Прозрачность фона"
L["range_out_of_range_background_alpha_desc"] = "Уровень прозрачности фона, когда юнит вне зоны досягаемости."
L["range_use_out_of_range_background_color_name"] = "Изменять фон"
L["range_use_out_of_range_background_color_desc"] = "Использовать другой цвет фона, когда юнит вне зоны досягаемости."

-- Overabsorb
L["module_overabsorb_name"] = "Сверхпоглощение"
L["module_overabsorb_desc"] = "Полосы здоровья могут визуально показывать остаток поглощающего щита даже если он превышает максимальное здоровье юнита. Это реализовано отдельной секцией щита справа от полосы здоровья. Ширина этой секции пропорциональна здоровью юнита, что позволяет легко оценить остаток поглощения. Например, юнит с 100 000 ХП, полным здоровьем и 30 000 поглощения будет иметь полосу здоровья, где 30% ширины заполнено индикатором щита."
L["overabsorb_glow_alpha_name"] = "Интенсивность свечения"
L["overabsorb_glow_alpha_desc"] = "Значение альфа-канала свечения поглощения."

-- Texture
L["module_texture_name"] = "Текстуры"
L["module_texture_desc"] = "Изменение текстур полос здоровья и ресурса."

-- BuffFrame
L["module_buff_frame_name"] = "Фрейм баффов"
L["module_buff_frame_desc"] = "Замена стандартного фрейма баффов на более настраиваемый с возможностью чёрного списка."

-- DebuffFrame
L["module_debuff_frame_name"] = "Фрейм дебаффов"
L["module_debuff_frame_desc"] = "Замена стандартного фрейма дебаффов на более настраиваемый с возможностью чёрного списка."
L["debuff_frame_show_only_raid_auras_name"] = "Только рейдовые"
L["debuff_frame_show_only_raid_auras_desc"] = "Показывать только те ауры, которые показывал бы стандартный фрейм дебаффов при выборе «Только развеиваемые дебаффы». Сюда входят ауры с фильтром «РЕЙД» и некоторые особо важные."
L["debuff_frame_indicator_border_by_dispel_color_name"] = "Рамка по типу развеивания"
L["debuff_frame_indicator_border_by_dispel_color_desc"] = "Окрашивать рамку индикатора в соответствии с типом развеивания ауры. Если типа нет — используется стандартный цвет."
L["debuff_frame_duration_font_by_dispel_color_name"] = "Длительность по типу развеивания"
L["debuff_frame_duration_font_by_dispel_color_desc"] = "Окрашивать текст длительности в соответствии с типом развеивания ауры. Если типа нет — используется стандартный цвет."
L["priv_point_name"] = "Приватная привязка"
L["priv_point_desc"] = "Точка привязки приватного индикатора ауры."
L["increase_factor_name"] = "Коэффициент увеличения"
L["increase_factor_desc"] = "Насколько сильно увеличивать увеличенную ауру."

-- Aura lists
L["blacklist_name"] = "Чёрный список"
L["watchlist_name"] = "Список наблюдения"
L["increased_auras_name"] = "Увеличенные"

-- DefensiveOverlay
L["module_defensive_overlay_name"] = "Защитные кулдауны"
L["module_defensive_overlay_desc"] = "Защитные накладки — это простая в настройке группа аур, отображающая активные защитные кулдауны в отдельной настраиваемой области рейдовых фреймов. Вкладка позволяет выбрать ауры и место их размещения."
L["TRINKET"] = "Аксессуары"

-- RaidFrameColor
L["module_raid_frame_color_name"] = "Настройки цвета"
L["module_raid_frame_color_desc"] = "Настройки цвета"
L["raid_frame_color_health_operation_mode_desc"] = "\nКласс/Реакция: окрашивать полосы здоровья по классу юнита или реакции НИП. Цвета настраиваются во вкладке «Цвета аддона».\n\nСтатичный: использовать один фиксированный цвет для всех полос здоровья."
L["raid_frame_color_operation_mode_class"] = "Класс/Реакция - Цвет"
L["raid_frame_color_operation_mode_static"] = "Статичный"
L["raid_frame_color_foreground_use_gradient_name"] = "Градиент"
L["raid_frame_color_foreground_use_gradient_desc"] = "Использовать градиент для цвета переднего плана."
L["raid_frame_color_static_normal_color_name"] = "Статичный цвет"
L["raid_frame_color_static_normal_color_desc"] = "Цвет, который будет применён к текстурам."
L["raid_frame_color_static_min_color_name"] = "Статичный цвет — Начало"
L["raid_frame_color_static_min_color_desc"] = "Начальный цвет градиента."
L["raid_frame_color_static_max_color_name"] = "Статичный цвет — Конец"
L["raid_frame_color_static_max_color_desc"] = "Конечный цвет градиента"
L["raid_frame_color_background_use_gradient_name"] = "Градиент"
L["raid_frame_color_background_use_gradient_desc"] = "Использовать градиент для фона."
L["raid_frame_color_power_operation_mode_desc"] = "\nТип ресурса: окрашивать полосы ресурса по типу ресурса юнита. Цвета настраиваются во вкладке «Цвета аддона».\n\nСтатичный: использовать один фиксированный цвет для всех полос ресурса."
L["raid_frame_color_operation_mode_power"] = "Тип ресурса"
L["raid_frame_health_bar_color_foreground"] = "Полоса здоровья — Передний план"
L["raid_frame_health_bar_color_background"] = "Полоса здоровья — Фон"
L["raid_frame_power_bar_color_foreground"] = "Полоса ресурса — Передний план"
L["raid_frame_power_bar_color_background"] = "Полоса ресурса — Фон"
L["color_darkening_factor_name"] = "Затемнение"
L["color_darkening_factor_desc"] = "Насколько фон будет темнее переднего плана."

-- Texture
L["health_bar_border_color"] = "Цвет рамки"
L["module_texture_header_name"] = "Настройки текстур"
L["module_texture_header_desc"] = "Настройки текстур"
L["texture_health_bar_foreground_name"] = "Полоса здоровья — передний план"
L["texture_health_bar_background_name"] = "Полоса здоровья — фон"
L["texture_power_bar_foreground_name"] = "Полоса ресурса — передний план"
L["texture_power_bar_background_name"] = "Полоса ресурса — фон"
L["texture_detach_power_bar_name"] = "Открепить"
L["texture_detach_power_bar_desc"] = "Открепить полосу ресурса и свободно разместить её на полосе здоровья. Направление заполнения меняется, если высота больше ширины."
L["texture_power_bar_width_name"] = "Ширина"
L["texture_power_bar_width_desc"] = "Ширина полосы ресурса в % от полосы здоровья."
L["texture_power_bar_height_name"] = "Высота"
L["texture_power_bar_height_desc"] = "Высота полосы ресурса в % от полосы здоровья."

-- Font
L["module_font_name"] = "Имя и текст статуса"
L["module_font_desc"] = "Включить настройку шрифта для имени и текста статуса."
L["font_name_header"] = "Текст имени"
L["font_name_class_colored_name"] = "Цвет класса"
L["font_name_class_colored_desc"] = "Окрашивать текст в цвет класса юнита."
L["font_name_show_server_name"] = "Показывать реалм"
L["font_name_show_server_desc"] = "Отображать название реалма рядом с именем игрока"
L["font_status_header"] = "Текст статуса"
L["font_nicknames_header"] = "Никнеймы"
L["max_length_name"] = "Длина"
L["max_length_desc"] = "Длина строки шрифта относительно ширины фрейма."

-- Aura Groups
L["module_aura_groups_name"] = "Группы аур"
L["module_aura_groups_desc"] = "Группы аур — это фреймы аур (как баффы и дебаффы), но содержащие только выбранные вами ауры, включая смесь баффов и дебаффов. Их можно размещать в любом месте рейдового фрейма."
L["aura_groups_menu_band_name"] = "Создать группы"
L["create_aura_group_name"] = "Введите название:"
L["create_aura_group_desc"] = "Создать новую группу аур. Сама по себе группа ничего не делает. Нужно добавить ауры в группу. Это можно сделать, нажав на:"
L["edit_grp_btn_name"] = "Редактировать"
L["edit_grp_btn_desc"] = "Редактировать ауры группы, а также её позицию и размеры на рейдовом фрейме."
L["edit_grp_title"] = "Вы редактируете группу:"
L["add_aura_to_grp_name"] = "Добавить ауру:"
L["add_aura_to_grp_desc"] = "Добавьте ауру в группу, введя spellId ауры и нажав «ОК»."
L["aura_groups_own_only_name"] = "Только свои"
L["aura_groups_own_only_desc"] = "Отслеживать ауру только если её источником являетесь вы."
L["aura_groups_show_glow_name"] = "Свечение"
L["aura_groups_show_glow_desc"] = "Подсвечивать индикатор ауры анимацией свечения."
L["enlarge_aura_name"] = "Увеличить"
L["enlarge_aura_desc"] = "Увеличить ауру так, как если бы это была босс-аура."
L["aura_groups_track_if_missing_name"] = "Отсутствует"
L["aura_groups_track_if_missing_desc"] = "Показывать обесцвеченный индикатор ауры, если аура отсутствует."
L["aura_groups_track_if_present_name"] = "Отслеживать"
L["aura_groups_track_if_present_desc"] = "Показывать индикатор ауры, когда она присутствует на юните."
L["aura_prio_name"] = "Приоритет:"
L["aura_prio_desc"] = "Ауры будут сортироваться по уровню приоритета, 1 — наивысший."
L["import_spec_preset_header_name"] = "Импорт пресета:"
L["import_resto_druid_btn_name"] = "Рестор друид"
L["import_preset_confirm_msg"] = "Это перезапишет предыдущие группы, созданные этой кнопкой."
L["create_grp_confirm_msg"] = "Создать новую группу аур с названием: "
L["create_grp_header_name"] = "Создать свою группу:"
L["import_disci_priest_btn_name"] = "Дисциплина жрец"

-- Buff Highlight
L["module_buff_highlight_name"] = "Подсветка баффов"
L["module_buff_highlight_desc"] = "Подсвечивать отсутствующие или присутствующие баффы, окрашивая полосу здоровья юнита в цвет подсветки."
L["buff_highlight_operation_mode_desc"] = "\nРежим «Присутствует»: подсветка когда бафф есть.\n\nРежим «Отсутствует»: подсветка когда баффа нет"
L["buff_highlight_option_present"] = "Присутствует"
L["buff_highlight_option_missing"] = "Отсутствует"
L["buff_highlight_edit_auras_name"] = "Редактировать ауры"
L["buff_highlight_edit_auras_desc"] = "Редактировать ауры"

-- Raid Mark
L["module_raid_mark_name"] = "Рейдовая метка"
L["module_raid_mark_desc"] = "Отображать иконку метки цели юнита на рейдовом фрейме."

------------
--- Tabs ---
------------

L["general_options_tab_name"] = "Общие"
L["module_selection_tab_name"] = "Центр модулей"
L["addon_colors_tab_name"] = "Цвета аддона"
L["font_options_tab_name"] = "Шрифты"
L["defensive_overlay_options_tab_name"] = "Защитные кулдауны"
L["buff_frame_options_tab_name"] = "Баффы"
L["debuff_frame_options_tab_name"] = "Дебаффы"
L["profiles_options_tab_name"] = "Профили"
L["aura_groups_tab_name"] = "Группы аур"

--------------------
--- AddOn Colors ---
--------------------

L["class_colors_tab_name"] = "Цвета классов"
L["power_colors_tab_name"] = "Цвета ресурсов"
L["dispel_type_colors_tab_name"] = "Цвета развеивания"
L["color_reset_button_desc"] = "Сбросить цвета к значениям по умолчанию."
L["normal_color_name"] = "Обычный — Цвет"
L["normal_color_desc"] = "«Обычный» цвет, используется когда градиент не включён или недоступен."
L["min_color_name"] = "Начало — Цвет"
L["min_color_desc"] = "Цвет в начале градиента."
L["max_color_name"] = "Конец — Цвет"
L["max_color_desc"] = "Цвет в конце градиента."
L["Magic"] = "Магия"
L["Disease"] = "Болезнь"
L["Poison"] = "Яд"
L["Curse"] = "Проклятие"

----------------
--- Profiles ---
----------------

--Profile Management:
L["profile_management_group_name"] = "Управление профилями"
L["share_profile_title"] = "Импорт/Экспорт профиля"
L["export_profile_input_title"] = "Чтобы экспортировать текущий профиль, скопируйте код ниже."
L["import_profile_input_title"] = "Чтобы импортировать профиль, вставьте строку профиля ниже и нажмите «Принять»."
L["import_profile_confirm_msg"] = "Внимание: импорт профиля перезапишет ваш текущий профиль."
L["import_profile_btn_name"] = "Импорт профиля"
L["import_profile_btn_desc"] = "Импорт профиля"
L["export_profile_btn_name"] = "Экспорт профиля"
L["export_profile_btn_desc"] = "Экспорт профиля"
--Profile import error handling:
L["import_empty_string_error"] = "Строка импорта пуста. Отмена"
L["import_decoding_failed_error"] = "Декодирование не удалось. Отмена"
L["import_uncompression_failed_error"] = "Распаковка не удалась. Отмена"
L["invalid_profile_error"] = "Некорректный профиль. Отмена"
L["import_incompatible_profile_error"] = "Профиль, который вы пытаетесь импортировать, несовместим."
L["party_profile_name"] = "Группа"
L["raid_profile_name"] = "Рейд"
L["arena_profile_name"] = "Арена"
L["battleground_profile_name"] = "Поле боя"
L["active_spec_indicator"] = "Активный"
L["profile_creation_title"] = "Профили — Текущий профиль: "
L["new_profile_desc_name"] = "Создать новый профиль. Профили загружаются в зависимости от специализации и типа группы. Не забудьте выбрать нужный профиль в разделе «Профили групп» ниже."
L["reset_profile_btn_name"] = "Сброс профиля"
L["reset_profile_btn_desc"] = "Сброс текущего профиля к значениям по умолчанию, если конфигурация сломана или вы хотите начать заново."
L["new_profile_name"] = "Новый"
L["new_profile_desc"] = "Создать новый профиль."
L["copy_profile_name"] = "Копировать из"
L["copy_profile_desc"] = "Копировать профиль в текущий."
L["copy_profile_desc_name"] = "Скопировать настройки из существующего профиля в текущий."
L["delete_profile_desc_name"] = "Удалить существующий профиль."
L["delete_profile_name"] = "Удалить профиль"
L["delete_profile_desc"] = "Удаляет профиль из базы данных"
L["delete_profile_confirm"] = "Вы уверены, что хотите удалить выбранный профиль?"

----------------------
--- Aura Menu Band ---
----------------------

L["aura_meanu_band_name"] = " "
L["add_to_blacklist_name"] = "Добавить в \124cFFEE4B2Bчёрный список\124r:"
L["add_to_watchlist_name"] = "Добавить в \124cFF00FF7Fсписок наблюдения\124r:"
L["spell_id_input_field_desc"] = "Введите spellId"
L["spell_id_wrong_input_notification"] = "Похоже, spell ID неверный. Spell ID должен состоять только из цифр от 0 до 9. Попробуйте ещё раз."
L["settings_toggle_button_show_name"] = "Показать настройки"
L["settings_toggle_button_show_desc"] = "Отображает настройки фрейма аур для этой группы. Появится панель с элементами управления внешним видом и поведением фрейма аур."
L["settings_toggle_button_hide_name"] = "Скрыть настройки"
L["settings_toggle_button_hide_desc"] = "Скрыть настройки фрейма аур. После настройки внешнего вида можно скрыть верхнюю панель, нажав эту кнопку."
L["remove_button_name"] = "Удалить"
L["remove_button_desc"] = "из списка"

-----------------------
--- Mini Map Button ---
-----------------------

L["module_mini_map_button_name"] = "Кнопка у миникарты"
L["module_mini_map_button_desc"] = "Включить кнопку у миникарты для управления аддоном."
L["mini_map_tooltip_left_button_text"] = "ЛКМ: Открыть настройки."
L["mini_map_tooltip_right_button_text"] = "ПКМ: Перезагрузить аддон."

----------------
--- Messages ---
----------------

L["option_open_after_combat_msg"] = "Настройки откроются/откроются снова после боя."
L["mini_map_in_combat_warning"] = "Перезагрузка во время боя невозможна — это может сломать ваш интерфейс."
