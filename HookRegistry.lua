local _, addonTable = ...
addonTable.hooks = {}
local addon = addonTable.addon
local Hooks = addonTable.hooks

local _G = _G
local HookScript = HookScript
local hooksecurefunc = hooksecurefunc
local tostring = tostring
local string_sub = string.sub 
local next = next
local pairs = pairs

local doNothing = function() 
    return
end

local hooked = {}
local callbacks = {}
local registry = {}

function Hooks:HookScript(frame, handler, callback)
    local func = type(callback) == "string" and self[callback] or callback
    local id = tostring(self) .. tostring(frame) .. tostring(handler)
    if not callbacks[frame] then
        callbacks[frame] = {}
    end
    if not callbacks[frame][handler] then
        callbacks[frame][handler] = {}
    end
    callbacks[frame][handler][self] = func
    if not hooked[frame] or not hooked[frame][handler] then
        frame:HookScript(handler, function(...)
            for key, callback in next, callbacks[frame][handler] do
                callback(...)
            end
        end)
        if not hooked[frame] then
            hooked[frame] = {}
        end
        hooked[frame][handler] = true
    end
    if not registry[self] then
        registry[self] = {}
    end
    registry[self][id] = {
        ["key1"] = frame,
        ["key2"] = handler,
    }
end

function Hooks:HookFunc(arg1, arg2, arg3)
    local obj, functionName, hookfunc = nil, nil, nil
    if type(arg1) == "table" then
        obj = arg1
        functionName = arg2
        hookfunc = arg3
    else
        obj = _G
        functionName = arg1
        hookfunc = arg2
    end
    local id = tostring(self) .. tostring(obj) ..tostring(functionName)
    hookfunc = type(hookfunc) == "string" and self[hookfunc] or hookfunc
    if not callbacks[obj] then
        callbacks[obj] = {}
    end
    if not callbacks[obj][functionName] then
        callbacks[obj][functionName] = {}
    end
    callbacks[obj][functionName][self] = hookfunc
    if not hooked[obj] or not hooked[obj][functionName] then
        hooksecurefunc(obj, functionName, function(...)
            for key, callback in next, callbacks[obj][functionName] do
                callback(...)
            end
        end)
        if not hooked[obj] then
            hooked[obj] = {}
        end
        hooked[obj][functionName] = true
    end
    if not registry[self] then
        registry[self] = {}
    end
    registry[self][id] = {
        ["key1"] = obj,
        ["key2"] = functionName,
    }
end

function Hooks:HookFuncFiltered(arg1, arg2, arg3)
    local obj, functionName, hookfunc = nil, nil, nil
    if type(arg1) == "table" then
        obj = arg1
        functionName = arg2
        hookfunc = arg3
    else
        obj = _G
        functionName = arg1
        hookfunc = arg2
    end
    local id = tostring(self) .. tostring(obj) ..tostring(functionName)
    hookfunc = type(hookfunc) == "string" and self[hookfunc] or hookfunc
    if not callbacks[obj] then
        callbacks[obj] = {}
    end
    if not callbacks[obj][functionName] then
        callbacks[obj][functionName] = {}
    end
    callbacks[obj][functionName][self] = hookfunc
    if not hooked[obj] or not hooked[obj][functionName] then
        hooksecurefunc(obj, functionName, function(frame, ...)
            local frame = frame
            if not frame then
                return
            end
            local unit = frame.unit
            if not unit then 
                return
            end
            if not ( unit == "player" or string_sub(unit, 1, 4) == "raid" or string_sub(unit, 1, 5) == "party" ) then
                return
            end
            for key, callback in next, callbacks[obj][functionName] do
                callback(frame, ...)
            end
        end)
        if not hooked[obj] then
            hooked[obj] = {}
        end
        hooked[obj][functionName] = true
    end
    if not registry[self] then
        registry[self] = {}
    end
    registry[self][id] = {
        ["key1"] = obj,
        ["key2"] = functionName,
    }
end

function Hooks:Unhook(arg1, arg2)
    if not registry[self] then
        return
    end
    local obj, functionName = nil, nil
    if type(arg1) == "table" then
        obj = arg1
        functionName = arg2
    else
        obj = _G
        functionName = arg1
    end
    local id = tostring(self) .. tostring(obj) .. tostring(functionName)
    id = registry[self][id]
    if not id then
        return
    end
    callbacks[id.key1][id.key2][self] = doNothing
end

function Hooks:DisableHooks()
    if not registry[self] then
        return
    end
    for _,id in pairs(registry[self]) do
        callbacks[id.key1][id.key2][self] = doNothing
    end
end



