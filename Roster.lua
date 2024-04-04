local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local _G = _G
local GetParent = GetParent
local IsInRaid = IsInRaid
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local IsForbidden = IsForbidden
local IsShown = IsShown
local next = next
local select = select

local Roster = {}
local needsUpdate = true

local function ShowSeparateGroups()
    local showSeparateGroups 
    if addonTable.isClassic then
        showSeparateGroups = CompactRaidFrameManager_GetSetting("KeepGroupsTogether")
    else
        showSeparateGroups = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups()
    end
    return showSeparateGroups
end

local function UpdateRosterCache()
    Roster = {}
    local showSeparateGroups = ShowSeparateGroups()
    local useRaid = ( IsInRaid() and not select(1,IsActiveBattlefieldArena()) ) or ( addonTable.isClassic and not showSeparateGroups ) --IsInRaid() returns true in arena even though we need party frame names
    if useRaid then 
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
                local unit = frame.unit or ""
                Roster[unit] = frame
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

local last_showSeparateGroups = ShowSeparateGroups() -- An event or cvar would be nicer but couldn't find one in event trace
local function CheckRosterCache()
    local current_showSeparateGroups = ShowSeparateGroups()
    if needsUpdate or ( last_showSeparateGroups ~= current_showSeparateGroups ) then
        UpdateRosterCache()
    end
    last_showSeparateGroups = current_showSeparateGroups
end

function addon:IterateRoster(callback)
    CheckRosterCache()
    for unit, frame in next, Roster do
        if not frame:IsForbidden() and frame:IsShown() and not addonTable.inCombat then
            callback(frame)
        end
    end
end

function addon:GetFrame(unit)
    CheckRosterCache()
    return Roster[unit]
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
    needsUpdate = true
end)