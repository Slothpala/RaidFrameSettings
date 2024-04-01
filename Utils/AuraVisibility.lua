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

--[[
    The game build a cache in a local file named cachedVisualizationInfo https://github.com/Gethe/wow-ui-source/blob/094b732e38acfa3cd97113af8c142532e6d77a2e/Interface/FrameXML/AuraUtil.lua#L199
    The cache will be dumped on PLAYER_SPECIALIZATION_CHANGED since we can't access the cache directly we force the game to do it for us.
        from all: return true, false, true
        only from self: return true, true, false
]]
if addonTable.isRetail then
    function addon:Dump_cachedVisualizationInfo()
        if InCombatLockdown() then
            return
        end
        EventRegistry:TriggerEvent("PLAYER_SPECIALIZATION_CHANGED")
    end

    local orig_SpellGetVisibilityInfo = SpellGetVisibilityInfo
    SpellGetVisibilityInfo = function(spellId, visType)
        if blacklist[spellId] then
            return true, false, false
        end

        if watchlist[spellId] then
            local watchEntry = watchlist[spellId]
            if watchEntry.hideInCombat and visType == "RAID_INCOMBAT" then
                return true, false, false
            elseif watchEntry.ownOnly then
                return true, true, false
            elseif watchEntry.spellIsDebuff then
                return false
            else
                return true, false, true
            end        
        end

        return orig_SpellGetVisibilityInfo(spellId, visType)
    end
end
