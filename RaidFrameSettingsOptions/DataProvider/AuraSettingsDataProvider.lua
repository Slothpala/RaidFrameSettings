local addon_name, private = ...
local main_addon = _G["RaidFrameSettings"]
local data_base = main_addon.db
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

local data_manager = {}
private.DataHandler.RegisterDataManager("aura_settings", data_manager)

local function generate_options_tbl()
  local options = {
    -- Buffs.
    [1] = {
      title = {
        order = 1,
        type = "title",
        settings_text = L["title_buffs"],
      },
      buff_border_color = {
        order = 2,
        type = "color",
        settings_text = L["aura_border_color"],
        db_obj = data_base.profile.module_data.AuraBorder_Buffs,
        db_key = "border_color",
        associated_modules = {
          "AuraBorder_Buffs",
        },
      },
      buff_border_size = {
        order = 3,
        type = "slider",
        settings_text = L["aura_border_size"],
        db_obj = data_base.profile.module_data.AuraBorder_Buffs,
        db_key = "border_size",
        associated_modules = {
          "AuraBorder_Buffs",
        },
        slider_options = {
          min_value = 1,
          max_value = 5,
          steps = 4,
          decimals = 0,
        },
      },
    },
    -- Debuffs.
    [2] = {
      title = {
        order = 1,
        type = "title",
        settings_text = L["title_debuffs"],
      },
      debuff_border_color = {
        order = 2,
        type = "color",
        settings_text = L["aura_border_color"],
        db_obj = data_base.profile.module_data.AuraBorder_Debuffs,
        db_key = "border_color",
        associated_modules = {
          "AuraBorder_Debuffs",
        },
      },
      debuff_border_size = {
        order = 3,
        type = "slider",
        settings_text = L["aura_border_size"],
        db_obj = data_base.profile.module_data.AuraBorder_Debuffs,
        db_key = "border_size",
        associated_modules = {
          "AuraBorder_Debuffs",
        },
        slider_options = {
          min_value = 1,
          max_value = 5,
          steps = 4,
          decimals = 0,
        },
      },
    },
  }
  return options
end

data_manager.get_data_provider = function ()
  local options = generate_options_tbl()
  local data_provider = CreateTreeDataProvider()

  for _, category in ipairs(options) do
    local order_tbl = {}

    -- Exclude hidden objects.
    for _, option in pairs(category) do
      if not (option.hide and option.hide() == true) then
        table.insert(order_tbl, option)
      end
    end

    -- Sort by order key.
    table.sort(order_tbl, function(a, b)
      return (a.order or 0) < (b.order or 0)
    end)

    -- Add them to the data provider.
    for _, option in ipairs(order_tbl) do
      data_provider:Insert(option)
    end
  end

  return data_provider
end
