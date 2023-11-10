local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local _G = _G
local GetParent = GetParent
local IsInRaid = IsInRaid
local IsActiveBattlefieldArena = IsActiveBattlefieldArena

local Roster = {}
local needsUpdate = true

local function updateRoster()
    Roster = {}
    local showSeparateGroups = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups()
    if IsInRaid() and not select(1,IsActiveBattlefieldArena()) then --IsInRaid() returns true in arena even though we need party frame names
        if showSeparateGroups then
            for i=1, 8 do
                for j=1, 5 do
                    local frame = _G["CompactRaidGroup" ..i.. "Member" .. j .. "HealthBar"]
                    if frame then
                        frame = frame:GetParent()
                        if frame.unit then
                            Roster[frame.unit] = frame
                        end
                    end
                end
            end
            for i=1, 40 do
                local frame = _G["CompactRaidFrame" ..i .. "HealthBar"]
                if frame then
                    frame = frame:GetParent()
                    if frame.unit then
                        Roster[frame.unit] = frame
                    end
                end
            end
        else
            for i=1, 80 do
                local frame = _G["CompactRaidFrame" ..i .. "HealthBar"]
                if frame then
                    frame = frame:GetParent()
                    if frame.unit then
                        Roster[frame.unit] = frame
                    end
                end
            end
        end
    else
        for i=1, 5 do
            local frame = _G["CompactPartyFrameMember" ..i .. "HealthBar"]
            if frame then
                frame = frame:GetParent()
                if frame.unit then
                    Roster[frame.unit] = frame
                end
            end
            local frame = _G["CompactPartyFramePet" ..i .. "HealthBar"]
            if frame then
                frame = frame:GetParent()
                if frame.unit then
                    Roster[frame.unit] = frame
                end
            end
            local frame = _G["CompactArenaFrameMember" ..i .. "HealthBar"]
            if frame then
                frame = frame:GetParent()
                Roster[frame.unit] = frame
            end
        end
    end
    needsUpdate = false
    return true
end

function addon:IterateRoster(callback)
    if needsUpdate then
        updateRoster()
    end
    for unit,frame in next, Roster do
        callback(frame)
    end
end

function addon:GetFrame(unit)
    if needsUpdate then
        updateRoster()
    end
    return Roster[unit]
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
    needsUpdate = true
end)