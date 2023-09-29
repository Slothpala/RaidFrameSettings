--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local CustomScale = RaidFrameSettings:NewModule("CustomScale")

local function setPartyScale(scaleFactor)
    CompactPartyFrame:SetScale(scaleFactor)
end

local function setRaidScale(scaleFactor)
    CompactRaidFrameContainer:SetScale(scaleFactor)
end

local function setArenaScale(scaleFactor)
    CompactArenaFrame:SetScale(scaleFactor)
end


function CustomScale:OnEnable()
local partyScale = RaidFrameSettings.db.profile.MinorModules.CustomScale.Party
local raidScale  = RaidFrameSettings.db.profile.MinorModules.CustomScale.Raid
local arenaScale = RaidFrameSettings.db.profile.MinorModules.CustomScale.Arena
setPartyScale(partyScale)
setRaidScale(raidScale)
setArenaScale(arenaScale)
end

function CustomScale:OnDisable()
    setPartyScale(1)
    setRaidScale(1)
    setArenaScale(1)
end