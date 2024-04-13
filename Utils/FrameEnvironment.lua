--[[
    -- TODO implement a method to pass an frame_env table as first argument to all callbacks containing information about the unit class etc.
    to reduce overhead
]]

local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
addonTable.FrameEnvironment = {}
local FrameEnvironment = addonTable.FrameEnvironment

local guid_cache = {}

function FrameEnvironment:GetEnv(guid)
    local frame_env = {}
    return frame_env
end