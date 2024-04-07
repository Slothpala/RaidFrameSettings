--[[
    Created by Slothpala
    TODO
    make the blacklist work with all buffs without the Debuffs module
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Blacklist = addon:NewModule("Blacklist")

function Blacklist:OnEnable()
    self:ReloadAffectedModules()
end


function Blacklist:OnDisable()
    self:ReloadAffectedModules()
end

function Blacklist:ReloadAffectedModules()
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