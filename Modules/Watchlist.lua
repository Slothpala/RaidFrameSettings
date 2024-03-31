--[[
    Created by Slothpala
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Watchlist = addon:NewModule("Watchlist")

function Watchlist:OnEnable()
    if addonTable.isRetail then
        for spellId, info in pairs(addon.db.profile.Watchlist) do
            addon:AppendAuraWatchlist(tonumber(spellId), info)
        end
        addon:Dump_cachedVisualizationInfo()
    end
    self:ReloadAffectedModules()
end

function Watchlist:OnDisable()
    if addonTable.isRetail then
        for spellId, value in pairs(addon.db.profile.Watchlist) do
            addon:RemoveAuraFromWatchlist(tonumber(spellId))
        end
        addon:Dump_cachedVisualizationInfo()
    end
    self:ReloadAffectedModules()
end

function Watchlist:ReloadAffectedModules()
    if addon:IsModuleEnabled("Buffs") then
        addon:UpdateModule("Buffs")
    end
    if addon:IsModuleEnabled("Debuffs") then
        addon:UpdateModule("Debuffs")
    end
end