--[[
    Created by Slothpala
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Watchlist = addon:NewModule("Watchlist")

function Watchlist:OnEnable()
    for spellId, info in pairs(addon.db.profile.Watchlist) do
        addon:AppendAuraWatchlist(tonumber(spellId), info)
    end
    addon:Dump_cachedVisualizationInfo()
    addon:IterateRoster(CompactUnitFrame_UpdateAuras)
end

function Watchlist:OnDisable()
    for spellId, value in pairs(addon.db.profile.Watchlist) do
        addon:RemoveAuraFromWatchlist(tonumber(spellId))
    end
    addon:Dump_cachedVisualizationInfo()
    addon:IterateRoster(CompactUnitFrame_UpdateAuras)
end