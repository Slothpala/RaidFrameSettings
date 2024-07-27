--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  childGroups = "tab",
  args = {},
}

local function update_options()

  options.args = {
    menu_band = {
      order = 1,
      name = " ",
      type = "group",
      inline = true,
      args = {
        add_to_list = {
          order = 1,
          name = L["add_aura_to_grp_name"],
          desc = L["add_aura_to_grp_desc"],
          type = "input",
          pattern = "^%d+$", -- only digits from 0 - 9
          usage = L["spell_id_wrong_input_notification"],
          set = function(_, value)
            local spell_id = tonumber(value)
            addon.db.profile.BuffHighlight.auras[spell_id] = {
              own_only = true
            }
            update_options() -- this will only update the options table.
            addon:ReloadModule("BuffHighlight")
          end,
        },
      },
    },
  }

  local function update_auras()
    for spell_id, _ in next, addon.db.profile.BuffHighlight.auras do
      -- Gather spell infos
      local string_id = tostring(spell_id)
      local is_valid_id = #string_id <= 10
      local spell_obj = is_valid_id and Spell:CreateFromSpellID(spell_id) or nil
      local spell_name = spell_obj and spell_obj:GetSpellName() or "|cffff0000aura not found|r"

      options.args[string_id] = {
        order = math.max(spell_id, 3),
        name = "",
        type = "group",
        inline = true,
        args = {
          space = {
            order = 1,
            name = "",
            type = "description",
            width = 0.05,
          },
          icon = {
            order = 2,
            name = spell_name .. " ( "  .. string_id .. " )",
            image = spell_obj and spell_obj:GetSpellTexture() or "Interface\\ICONS\\INV_Misc_QuestionMark.blp",
            imageWidth = 24,
            imageHeight = 24,
            imageCoords = {0.1,0.9,0.1,0.9},
            type = "description",
            width = 1.5,
          },
          own_only = {
            order = 3,
            name = L["aura_groups_own_only_name"],
            desc = L["aura_groups_own_only_desc"],
            type = "toggle",
            get = function()
              return addon.db.profile.BuffHighlight.auras[spell_id].own_only
            end,
            set = function(_, value)
              addon.db.profile.BuffHighlight.auras[spell_id].own_only = value
              addon:ReloadModule("BuffHighlight")
            end,
            width = 0.6,
          },
          remove_btn = {
            order = 4,
            name = L["remove_button_name"],
            desc = L["remove_button_name"] .. " " .. spell_name .. " " .. L["remove_button_desc"],
            type = "execute",
            func = function()
              addon.db.profile.BuffHighlight.auras[spell_id] = nil
              update_options()
              addon:ReloadModule("BuffHighlight")
            end,
            width = 0.5,
          }
        }
      }
    end
  end

  update_auras()
end

function addon:GetBuffHighlightAuraOptions()
  update_options()
  return options
end
