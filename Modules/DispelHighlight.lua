--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local module = addon:NewModule("DispelHighlight")
Mixin(module, addonTable.hooks)
local UnitAura = addonTable.UnitAura
local LD = LibStub("LibDispel-1.0")

local dispel_types = {
    [1] = "Curse",
    [2] = "Disease",
    [3] = "Magic",
    [4] = "Poison",
    [5] = "Bleed",
}

local dispel_type_colors = LD:GetDebuffTypeColor()

local block_color_update = {}
local frame_auras = {}
local aura_id_dispel_type = {}


function module:OnEnable()

    local function restore_health_color(frame)
        block_color_update[frame] = nil
        local _, englishClass = UnitClass(frame.unit)
        local r,g,b = GetClassColor(englishClass)
        frame.healthBar:SetStatusBarColor(r,g,b)
    end

    local function to_dispel_type_color(frame, dispelType, auraInstanceID)
        block_color_update[frame] = auraInstanceID
        frame.healthBar:SetStatusBarColor(dispel_type_colors[dispelType].r, dispel_type_colors[dispelType].g, dispel_type_colors[dispelType].b)
    end

    -- TODO I have implemented it in a way that allows the auras to be processed in a priority by dispel type. 
    -- I have the order "random" for now, but if it is ever requested this is the place to go.
    local function update_color(frame)
        for dispelType, auraInstanceIDs in next, frame_auras[frame] do
            for auraInstanceID, _ in pairs(auraInstanceIDs) do
                to_dispel_type_color(frame, dispelType, auraInstanceID)
                return
            end
        end
        restore_health_color(frame)
    end

    local function on_dispel_apply(dispelType, aura, frame)
        if LD:IsDispellableByMe(dispelType) then
            frame_auras[frame] = frame_auras[frame] or {Curse = {}, Disease = {}, Magic = {}, Poison = {}, Bleed = {}}
            frame_auras[frame][dispelType][aura.auraInstanceID] = true
            aura_id_dispel_type[aura.auraInstanceID] = dispelType
            update_color(frame)
        end
    end

    local function on_dispel_removal(auraInstanceID, frame)
        if not frame_auras[frame] or not aura_id_dispel_type[auraInstanceID] then
            return
        end
        frame_auras[frame][aura_id_dispel_type[auraInstanceID]][auraInstanceID] = nil
        update_color(frame)
    end

    for _, type in pairs(dispel_types) do
        UnitAura:RegisterDispelTypeCallback(type, "DispelHighlight", on_dispel_apply, on_dispel_removal)
    end

    local on_update_health_color = function(frame) 
        local auraInstanceID = block_color_update[frame]
        if not auraInstanceID then
            return
        end
        -- Check if the aura is still present to avoid frames being stuck in dispel color
        local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(frame.unit, auraInstanceID)
        if aura then
            -- color to dispel type if present
            frame.healthBar:SetStatusBarColor(dispel_type_colors[aura.dispelName].r, dispel_type_colors[aura.dispelName].g, dispel_type_colors[aura.dispelName].b)
        else
            -- remove it if not
            if not frame_auras[frame] or not aura_id_dispel_type[auraInstanceID] then
                return
            end
            frame_auras[frame][aura_id_dispel_type[auraInstanceID]][auraInstanceID] = nil
        end
    end

    self:HookFuncFiltered("CompactUnitFrame_UpdateHealthColor", on_update_health_color)
end

function module:OnDisable()
    self:DisableHooks()
    for _, type in pairs(dispel_types) do
        UnitAura:UnregisterDispelTypeCallback(type, "DispelHighlight")
    end
end

