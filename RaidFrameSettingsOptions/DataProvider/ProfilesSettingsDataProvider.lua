local addon_name, private = ...
local main_addon = _G["RaidFrameSettings"]
local data_base = main_addon.db
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

local data_manager = {}
private.DataHandler.RegisterDataManager("profiles_settings", data_manager)

local options = {
  --
  [1] = {
    title = {
      order = 1,
      type = "title",
      settings_text = L["profiles_header_1"] .. " ( |cff39FF14" .. main_addon.db:GetCurrentProfile() .. "|r )",
    },
    profile_list = {
      order = 2,
      type = "dropdown",
      settings_text = L["option_health_text_display_mode"],
      db_obj = data_base.profile.module_data,
      db_key = "health_text_display_mode",
      options = {},
      associated_modules = {
        "CVar_raidFramesHealthText",
        "CVar_pvpFramesHealthText",
      },
    },
  },
}

data_manager.get_data_provider = function ()
  local data_provider = CreateTreeDataProvider()

  -- Feed the profiles dropdown.
  table.wipe(options[1].profile_list.options)
  local ace_db_profiles = main_addon.db:GetProfiles()
  for _, profile_name in pairs(ace_db_profiles) do
    local entry_tbl = {profile_name, profile_name}
    table.insert(options[1].profile_list.options, entry_tbl)
  end

  for _, category in ipairs(options) do
    local order_tbl = {}
    local count = 1
    for _, option in pairs(category) do
      if option.hide and option.hide() == true then
        -- continue
      else
        local pos = option.order * 100
        order_tbl[pos] = option
        count = count > pos and count or pos
      end
    end
    for i = 1, count do
      local option = order_tbl[i]
      if option then
        data_provider:Insert(option)
      end
    end
  end

  return data_provider
end
