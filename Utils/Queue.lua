local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
addonTable.Queue = {}
local Queue = addonTable.Queue

local C_Timer = C_Timer
local SafePack = SafePack
local SafeUnpack = SafeUnpack
local tinsert = tinsert
local debugprofilestop = debugprofilestop
local debugstack = debugstack
local geterrorhandler = geterrorhandler

local coroutine = coroutine


local queue = {}
local ticker

local co = coroutine.create(function()
    while true do
        for k = 1, #queue do
            local v = queue[k]
            v.func(SafeUnpack(v.args))
            coroutine.yield(#queue)
        end
        local count = #queue
        for i = 0, count do queue[i] = nil end
        coroutine.yield(0)
    end
end)

function Queue:add(func, ...)
    queue[#queue + 1] = {
        func = func,
        args = SafePack(...),
    }
end

function Queue:run()
    if ticker and not ticker:IsCancelled() then
        return
    end
    local function run()
        local start = debugprofilestop()
        while debugprofilestop() - start < 2 do
            if coroutine.status(co) ~= "dead" then
                local ok, queueLeft = coroutine.resume(co)
                if not ok then
                    geterrorhandler()(debugstack(co))
                    ticker:Cancel()
                    break
                end
                if queueLeft == 0 then
                    ticker:Cancel()
                    break
                end
            else
                ticker:Cancel()
                break
            end
        end
    end
    ticker = C_Timer.NewTicker(0, run)
end

function Queue:flush()
    if ticker and not ticker:IsCancelled() then
        ticker:Cancel()
    end
    while true do
        if coroutine.status(co) ~= "dead" then
            local ok, queueLeft = coroutine.resume(co)
            if not ok then
                geterrorhandler()(debugstack(co))
                break
            end
            if queueLeft == 0 then
                break
            end
        else
            break
        end
    end
end
