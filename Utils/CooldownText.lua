local _, addonTable = ...
addonTable.cooldownText = {}
local CooldownText = addonTable.cooldownText

--WoW Api
local SetScript = SetScript
local SetText = SetText
local Round = Round
local GetCooldownTimes = GetCooldownTimes
local GetCooldownDuration = GetCooldownDuration
--Lua
local next = next
local string_format = string.format

--Cooldown Formatting
local day = 86400
local hour = 3600
local min = 60

local function getTimerText(number)
    if number < min then
        return Round(number)
    elseif number < hour then
        return string_format("%dm", Round( number / min ) )
    else
        return string_format("%dh", Round( number / hour ) )
    end
end

--Cooldown Display
local CooldownQueue = {}

local CooldownOnUpdateFrame = CreateFrame("Frame")

local interval = 0.25
local time_since_last_upate = 0

local function updateFontStrings(_, elapsed)
    time_since_last_upate = time_since_last_upate + elapsed
    if time_since_last_upate >= interval then
        time_since_last_upate = 0
        local currentTime = GetTime()
        for Cooldown in next, CooldownQueue do
            local time = ( Cooldown:GetCooldownTimes() + Cooldown:GetCooldownDuration() ) / 1000
            local left = time - currentTime
            if left <= 0  then
                CooldownQueue[Cooldown] = nil
            end 
            Cooldown._rfs_cd_text:SetText(getTimerText(left))
        end
        if next(CooldownQueue) == nil then
            CooldownOnUpdateFrame:SetScript("OnUpdate", nil)
            time_since_last_upate = 0
            return
        end
    end
end

function CooldownText:StartCooldownText(Cooldown)
    if not Cooldown._rfs_cd_text then 
        return false
    end
    CooldownQueue[Cooldown] = true
    if next(CooldownQueue) ~= nil then
        CooldownOnUpdateFrame:SetScript("OnUpdate", updateFontStrings)
    end
end

function CooldownText:StopCooldownText(Cooldown)
    CooldownQueue[Cooldown] = nil
    if next(CooldownQueue) == nil then
        CooldownOnUpdateFrame:SetScript("OnUpdate", nil)
    end
end

function CooldownText:DisableCooldownText(Cooldown)
    if not Cooldown._rfs_cd_text then 
        return 
    end
    self:StopCooldownText(Cooldown)
    Cooldown._rfs_cd_text:Hide()
end

--The position of _rfs_cd_text on the frame aswell as the font should be set in the module
function CooldownText:CreateOrGetCooldownFontString(Cooldown)
    if not Cooldown._rfs_cd_text then
        Cooldown._rfs_cd_text = Cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    end
    Cooldown._rfs_cd_text:Show()
    return Cooldown._rfs_cd_text
end

