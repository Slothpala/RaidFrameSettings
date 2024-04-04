--[[
    Created by Slothpala
]]


local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

--[[Watchlist]]

local watchlist = {}

function addon:AppendAuraWatchlist(spellId, info) --number
    watchlist[spellId] = info or {}
end

function addon:RemoveAuraFromWatchlist(spellId) --number
    watchlist[spellId] = nil
end

function addon:GetWatchlist()
    return watchlist
end

--[[Blacklist]]

local blacklist = {}

function addon:AppendAuraBlacklist(spellId, info) --number
    blacklist[spellId] = info or {}
end

function addon:RemoveAuraFromBlacklist(spellId) --number
    blacklist[spellId] = nil
end

function addon:GetBlacklist()
    return blacklist
end
