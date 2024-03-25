--[[
    Created by Slothpala
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Blacklist = addon:NewModule("Blacklist")

function Blacklist:OnEnable()
    for spellId, value in pairs(addon.db.profile.Blacklist) do
        addon:AppendAuraBlacklist(tonumber(spellId))
    end
    addon:Dump_cachedVisualizationInfo()
    addon:IterateRoster(CompactUnitFrame_UpdateAuras)
end

function Blacklist:OnDisable()
    for spellId, value in pairs(addon.db.profile.Blacklist) do
        addon:RemoveAuraFromBlacklist(tonumber(spellId))
    end
    addon:Dump_cachedVisualizationInfo()
    addon:IterateRoster(CompactUnitFrame_UpdateAuras)
end