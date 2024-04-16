--[[
    Created by Slothpala
]]

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings


local queue = {}
---callback function to be executed after combat
---@param function
function addon:DelayUntilAfterCombat(callback)
   table.insert(queue, callback)
end

local function on_combat_end()
   for i=1, #queue do
      queue[i]()
   end
   queue = {}
end


local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event)
   if event == "PLAYER_REGEN_ENABLED" then
      addonTable.inCombat = false
      on_combat_end()
   elseif event == "PLAYER_REGEN_DISABLED" then
      addonTable.inCombat = true
   else
      addonTable.inCombat = InCombatLockdown()
   end
end)
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")