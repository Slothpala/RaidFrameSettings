local addonName = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "ruRU", false, true)
if not L then return end

-- Categories.
L["general_settings"] = "Основное"
L["text_settings"] = "Текст"
L["aura_frame_settings"] = "Ауры"
L["profiles_settings"] = "Профили"

-- Titles.
L["title_colors"] = "Цвета"
L["textures"] = "Текстуры"
L["fonts"] = "Шрифты"
L["blizzard_settings_unit_frames"] = "Фреймы юнитов"
L["title_name"] = "Имя"
L["title_status"] = "Состояние"

-- Settings.
L["health_bar_fg"] = "Передний план индикатора здоровья"
L["health_bar_bg"] = "Фон индикатора здоровья"
L["power_bar_fg"] = "Передний план индикатора энергии"
L["power_bar_bg"] = "Фон индикатора энергии"

L["option_font"] = "Шрифт"
L["option_player_color"] = "Цвет игрока"
L["option_npc_color"] = "Цвет NPC"
L["option_anchor"] = "Положение"

L["border_color"] = "Цвет границы"

L["option_power_bars"] = "Индикаторы энергии"
L["option_show"] = "Показать"
L["option_hide"] = "Скрыть"
L["option_healer_only"] = "Только целители"
L["option_darkening_factor"] = "Фактор затемнения"
L["option_disabled"] = "Отключено"
L["option_dispellable_by_me"] = "Может быть рассеяно мной"
L["option_show_all"] = "Показать все"

-- Display Health
L["option_health_text_display_mode"] = "Отображение текста о здоровье"
L["option_health_none"] = "Ничего"
L["option_health_health"] = "Остаток здоровья"
L["option_health_lost"] = "Потерянное здоровье"
L["option_health_perc"] = "Процент здоровья"


-- Color Options.
L["class"] = "Класс"
L["class_gradient"] = "Классовый градиент"
L["static"] = "Статический"
L["static_gradient"] = "Статический градиент"
L["health_value"] = "Значение HP"
L["power_type"] = "Тип энергии"
L["power_type_gradient"] = "Градиент энергии"
L["class_to_health_value"] = "Класс -> Значение HP"

-- Colors.
L["static_color"] = "Цвет"
L["gradient_start"] = "Начало градиента"
L["gradient_end"] = "Конец градиента"

-- CVars
L["display_pets"] = "Отображение питомцев"
L["display_aggro_highlight"] = "Отображение Аггро"
L["display_incoming_heals"] = "Отображение входящего исцеления"
L["display_main_tank_and_assist"] = "Отображение главного танка и ассистента"
L["center_big_defensive"] = "Сильные защитные способности"
L["dispellable_debuff_indicator"] = "Индикатор рассеиваемого дебаффа"
L["dispellable_debuff_color"] = "Цвет рассеиваемого дебаффа"

-- Anchors
L["to_frames"] = "к фреймам"
L["offset_x"] = "Смещение X"
L["offset_y"] = "Смещение Y"
L["frame_point_top_left"] = "Лево верх"
L["frame_point_top"] = "Верх"
L["frame_point_top_right"] = "Право верх"
L["frame_point_right"] = "Справа"
L["frame_point_bottom_right"] = "Право низ"
L["frame_point_bottom"] = "Низ"
L["frame_point_bottom_left"] = "Лево низ"
L["frame_point_left"] = "Слева"
L["frame_point_center"] = "Центр"

-- Font Settings.
L["outline"] = "Контур"
L["thick"] = "Толстый"
L["monochrome"] = "Монохромный"
L["font_height"] = "Высота"
L["text_horizontal_justification"] = "Выравнивание по горизонтали"
L["text_horizontal_justification_option_left"] = "Слева"
L["text_horizontal_justification_option_center"] = "Центр"
L["text_horizontal_justification_option_right"] = "Справа"
L["text_vertical_justification"] = "Выравнивание по вертикали"
L["text_horizontal_justification_option_top"] = "Верх"
L["text_horizontal_justification_option_middle"] = "Середина"
L["text_horizontal_justification_option_bottom"] = "Низ"
L["max_length"] = "Длина"

-- Modules.
L["clean_borders"] = "Чистое выделение"
L["role_icon"] = "Значок роли"
L["raid_mark_pos"] = "Позиция метки рейда"
L["raid_mark_scale"] = "Масштаб меток рейда"

-- Profiles
L["profiles_header_1"] = "Профили - Текущий профиль:"
L["create_profile"] = "Создать новый профиль"
L["reset_profile"] = "Сбросить профиль"
L["delete_profile"] = "Удалить профиль"
L["copy_profile"] = "Скопировать профиль"
L["party_profile"] = "Группа"
L["raid_profile"] = "Рейд"
L["arena_profile"] = "Арена"
L["battleground_profile"] = "Поле боя"

-- Labels
L["label_create"] = "Создать"
L["label_reset"] = "Сброс"
