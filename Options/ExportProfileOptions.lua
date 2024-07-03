local addonName, addonTable = ...
local addon = addonTable.addon
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LibDeflate = LibStub:GetLibrary("LibDeflate")

local options = {
  name = "", -- required field but will never be shown.
  handler = addon,
  type = "group",
  args = {
    text_field = {
      name = L["export_profile_input_title"],
      desc = "",
      type = "input",
      multiline = 24
      ,
      width = "full",
      get = function ()
        return addon:ShareProfile()
      end,
      set = function()
      end,
    }
  },
}

function addon:ShareProfile()
  --AceSerialize
  local serialized_profile = self:Serialize(self.db.profile)
  --LibDeflate
  local compressed_profile = LibDeflate:CompressZlib(serialized_profile)
  local encoded_profile = LibDeflate:EncodeForPrint(compressed_profile)
  return encoded_profile
end

function addon:GetExportProfileOptions()
  return options
end
