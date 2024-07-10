--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("Resizer")

local function set_raid_container_scale(factor)
  CompactRaidFrameContainer:SetScale(factor)
end

local function set_party_container_scale(factor)
  CompactPartyFrame:SetScale(factor)
end

local function set_arena_container_scale(factor)
  CompactArenaFrame:SetScale(factor)
end

function module:OnEnable()
  -- Get the database object
  local db_obj = CopyTable(addon.db.profile.Resizer)
  set_raid_container_scale(db_obj.raid_frame_container_scale_factor)
  set_party_container_scale(db_obj.party_frame_container_scale_factor)
  set_arena_container_scale(db_obj.arena_frame_container_scale_factor)
end

function module:OnDisable()
  set_raid_container_scale(1)
  set_party_container_scale(1)
  set_arena_container_scale(1)
end
