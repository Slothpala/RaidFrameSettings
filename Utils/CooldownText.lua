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

local coTicker
local co = coroutine.create(function()
    while true do
        local currentTime = GetTime()
        if next(CooldownQueue) == nil then
            coroutine.yield(CooldownQueue)
        end
        for Cooldown in next, CooldownQueue do
            local time = (Cooldown:GetCooldownTimes() + Cooldown:GetCooldownDuration()) / 1000
            local left = time - currentTime
            if left <= 0 then
                CooldownQueue[Cooldown] = nil
            end
            Cooldown._rfs_cd_text:SetText(getTimerText(left))
            coroutine.yield(CooldownQueue)
        end
        coroutine.yield(CooldownQueue)
    end
end)

function CooldownText:run()
    if coTicker and not coTicker:IsCancelled() then
        return
    end
    local function run()
        local start = debugprofilestop()
        -- limit to 1ms
        while debugprofilestop() - start < 1 do
            if coroutine.status(co) ~= "dead" then
                local ok, queueLeft = coroutine.resume(co)
                if not ok then
                    geterrorhandler()(debugstack(co))
                    coTicker:Cancel()
                    break
                end
                if not queueLeft or next(queueLeft) == nil then
                    coTicker:Cancel()
                    break
                end
            else
                coTicker:Cancel()
                break
            end
        end
    end

    coTicker = C_Timer.NewTicker(0, run)
end

function CooldownText:StartCooldownText(Cooldown)
    if not Cooldown._rfs_cd_text then 
        return false
    end
    CooldownQueue[Cooldown] = true
    CooldownText:run()
end

function CooldownText:StopCooldownText(Cooldown)
    CooldownQueue[Cooldown] = nil
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
