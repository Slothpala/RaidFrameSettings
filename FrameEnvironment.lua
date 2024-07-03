local _, addonTable = ...
local addon = addonTable.addon

------------------------
--- Speed references ---
------------------------

-- Lua
local next = next
-- WoW Api
local IsInGroup = IsInGroup
local TableUtil_CreatePriorityTable = TableUtil.CreatePriorityTable
local AuraUtil_DefaultAuraCompare = AuraUtil.DefaultAuraCompare
local AuraUtil_UnitFrameDebuffComparator = AuraUtil.UnitFrameDebuffComparator
local TableUtil_Constants_AssociativePriorityTable = TableUtil.Constants.AssociativePriorityTable

-------------------------
--- Frame Environment ---
-------------------------

addonTable.on_create_frame_env_callbacks = {}

local function create_private_aura_indicator()
  local priv_indicator = CreateFrame("Frame")
  priv_indicator.border = priv_indicator:CreateTexture(nil, "BACKGROUND");
  return priv_indicator
end

local function create_frame_env(cuf_frame)
  local frame_env = {
    buffs = TableUtil_CreatePriorityTable(AuraUtil_DefaultAuraCompare, TableUtil_Constants_AssociativePriorityTable),
    debuffs = TableUtil_CreatePriorityTable(AuraUtil_UnitFrameDebuffComparator, TableUtil_Constants_AssociativePriorityTable),
    dispel_types = TableUtil_CreatePriorityTable(AuraUtil_DefaultAuraCompare, TableUtil_Constants_AssociativePriorityTable),
    grouped_auras = {
      BuffFrame = TableUtil_CreatePriorityTable(AuraUtil_DefaultAuraCompare, TableUtil_Constants_AssociativePriorityTable),
      DebuffFrame = TableUtil_CreatePriorityTable(AuraUtil_UnitFrameDebuffComparator, TableUtil_Constants_AssociativePriorityTable),
    },
    aura_frames = {},
    private_aura_indicators = { -- managed by the DebuffFrame module.
      [1] = create_private_aura_indicator(),
      [2] = create_private_aura_indicator(),
    },
  }
  cuf_frame.RFS_FrameEnvironment = frame_env
  for _, callback in next, addonTable.on_create_frame_env_callbacks do
    callback(cuf_frame)
  end
end

--- Create the frame environment, aura scanners and aura indicators or update them.
function addon:CreateOrUpdateFrameEnv()
  local in_group = IsInGroup() or addon:IsModuleEnabled("SoloFrame")
  if not in_group then
    return
  end
  CompactRaidFrameContainer:ApplyToFrames("normal", function(cuf_frame)
    -- Create the env if it doesnt exist.
    if not cuf_frame.RFS_FrameEnvironment then
      create_frame_env(cuf_frame)
    end
    -- Check if the aura scanner should start listening.
    local unit = cuf_frame.unit
    local is_visible = cuf_frame:IsVisible()
    -- Check if the unit auras should be updated or the scanner stopped.
    if ( unit and is_visible ) then
      addon:CreateOrUpdateAuraScanner(cuf_frame)
    else
      addon:StopAuraScanner(cuf_frame)
    end
  end)
end

--------------
--- Events ---
--------------

-- https://www.wowace.com/projects/ace3/pages/api/ace-bucket-3-0
-- GROUP_ROSTER_UPDATE gets spammed in certain scenarios (large groups with many people joining or leaving).
-- Buffering greatly reduces CPU usage spikes in these scenarios.
addon:RegisterBucketEvent("GROUP_ROSTER_UPDATE", 0.5, "CreateOrUpdateFrameEnv")
-- PLAYER_LOGIN is not sufficient, as the addon must perform a full update after reloading.
addon:RegisterEvent("PLAYER_ENTERING_WORLD", "CreateOrUpdateFrameEnv")


