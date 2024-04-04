--[[
    Created by Slothpala
]]


local _, addonTable = ...


local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_REGEN_ENABLED" then
        addonTable.inCombat = false
    elseif event == "PLAYER_REGEN_DISABLED" then
        addonTable.inCombat = true
    else
        addonTable.inCombat = InCombatLockdown()
    end
end)
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")