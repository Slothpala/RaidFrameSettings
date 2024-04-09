--[[
    Created by Slothpala
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
local UnitAura = addonTable.UnitAura

local Watchlist = addon:NewModule("Watchlist")

function Watchlist:OnEnable()
    UnitAura:UpdateWatchlist(true)
    self:ReloadAffectedModules()
end

function Watchlist:OnDisable()
    UnitAura:UpdateWatchlist(false)
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