--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local module = RaidFrameSettings:NewModule("TestModule")
Mixin(module, addonTable.hooks)
local UnitAura = addonTable.UnitAura
local LCG = LibStub("LibCustomGlow-1.0")

local glow_options = {
    color = {0.2, 0.6, 1, 1},
    startAnim = false,
    frameLevel = 1,
}

local glow_frame_register = {}

function module:OnEnable()
    local function on_magic_applied(aura, frame)
        print("aura with name: " .. aura.name .. " has been applied to " .. frame.unit)
        LCG.ProcGlow_Start(frame, glow_options)
        glow_frame_register[aura.auraInstanceID] = glow_frame_register[aura.auraInstanceID] or {}
        table.insert(glow_frame_register[aura.auraInstanceID], frame)
    end
    local function on_magic_removed(auraInstanceID)
        print("magic with ID: " .. auraInstanceID .. " has been removed")
        for k, frame in pairs(glow_frame_register[auraInstanceID]) do
            LCG.ProcGlow_Stop(frame)
        end
        glow_frame_register[auraInstanceID] = nil
    end
    UnitAura:RegisterDispelTypeCallback("Magic", "TestModule", on_magic_applied,  on_magic_removed)
end

function module:OnDisable()

end