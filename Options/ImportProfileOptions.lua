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
      name = L["import_profile_input_title"] ,
      desc = "",
      type = "input",
      multiline = 24,
      width = "full",
      confirm = function()
        return L["import_profile_confirm_msg"]
      end,
      get = function ()
        return ""
      end,
      set = function(self, input)
        addon:ImportProfile(input)
        --ReloadUI() --@TODO uncomment after alpha
      end,
    }
  },
}

function addon:ImportProfile(input)
  -- validate the input
  --empty?
  if input == "" then
    self:Print(L["import_empty_string_error"])
    return
  end
  -- LibDeflate decode
  local decoded_profile = LibDeflate:DecodeForPrint(input)
  if decoded_profile == nil then
    self:Print(L["import_decoding_failed_error"])
    return
  end
  -- LibDefalte uncompress
  local uncompressed_profile = LibDeflate:DecompressZlib(decoded_profile)
  if uncompressed_profile == nil then
    self:Print(L["import_uncompression_failed_error"])
    return
  end
  -- AceSerialize
  -- deserialize the profile and overwirte the current values
  local valid, imported_profile = self:Deserialize(uncompressed_profile)
  local defaults = addon:GetDefaultDbValues()
  if not imported_profile.db_version or imported_profile.db_version < defaults.profile.db_version then
    self:Print(L["import_incompatible_profile_error"])
    return
  end
  if valid and imported_profile then
    for k, v in next, imported_profile do
      if type(v) == "table" then
        self.db.profile[k] = CopyTable(v)
      else
        self.db.profile[k] = v
      end
    end
  else
    self:Print(L["invalid_profile_error"])
  end
end

function addon:GetImportProfileOptions()
  return options
end
