local addon_name, private = ...

local function init_addon()
  -- Init Database
  private:InitDatabase()
end

local function load_addon()

end


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, name)
  if event == "ADDON_LOADED" and name == addon_name then
    init_addon()
  elseif event == "PLAYER_LOGIN" then
    load_addon()
  end
end)

-- Also used by addon compartment.
function RaidFrameSettings_OpenSettings()
  if InCombatLockdown() then
    return
  end

  if not C_AddOns.IsAddOnLoaded("RaidFrameSettingsOptions") then
    C_AddOns.LoadAddOn("RaidFrameSettingsOptions")
  end

  RaidFrameSettingsOptions:Show()
end
