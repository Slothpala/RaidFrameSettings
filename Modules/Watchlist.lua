--[[
    Created by Slothpala
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Watchlist = addon:NewModule("Watchlist")

function Watchlist:OnEnable()
    self:ReloadAffectedModules()
end

function Watchlist:OnDisable()
    self:ReloadAffectedModules()
end

function Watchlist:ReloadAffectedModules()
    if addonTable.isFirstLoad then
        return
    end
    if addon:IsModuleEnabled("Buffs") then
        addon:UpdateModule("Buffs")
    end
    if addon:IsModuleEnabled("Debuffs") then
        addon:UpdateModule("Debuffs")
    end
end