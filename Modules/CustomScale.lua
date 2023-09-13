--[[
    Created by Slothpala
--]]
local CustomScale = RaidFrameSettings:NewModule("CustomScale")

local function setPartyScale(scaleFactor)
    CompactPartyFrame:SetScale(scaleFactor)
end

local function setRaidScale(scaleFactor)
    CompactRaidFrameContainer:SetScale(scaleFactor)
end


function CustomScale:OnEnable()
local partyScale = RaidFrameSettings.db.profile.MinorModules.CustomScale.Party
local raidScale  = RaidFrameSettings.db.profile.MinorModules.CustomScale.Raid
setPartyScale(partyScale)
setRaidScale(raidScale)
end

function CustomScale:OnDisable()
    setPartyScale(1)
    setRaidScale(1)
end