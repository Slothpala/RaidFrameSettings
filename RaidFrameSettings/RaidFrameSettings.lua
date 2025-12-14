local addon_name, private = ...
local addon = _G[addon_name]

local function init_addon()
  -- Init Database
  private:InitDatabase()
end

local function load_addon()
  for _, module in addon:IterateModules() do
    if addon.db.profile.module_status[module:GetName()] then
      module:Enable()
      print(module:GetName(), addon.db.profile.module_status[module:GetName()])
    end
  end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(self, event, name)
  if event == "ADDON_LOADED" and name == addon_name then
    init_addon()
  elseif event == "PLAYER_ENTERING_WORLD" then
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
