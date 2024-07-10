--[[Created by Slothpala]]--
local _, addonTable = ...
local addon = addonTable.addon

local module = addon:NewModule("SoloFrame")

--------------------
--- Libs & Utils ---
--------------------

Mixin(module, addonTable.HookRegistryMixin)

------------------------
--- Speed references ---
------------------------

-- WoW Api
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup


function module:OnEnable()
  local function on_update_party_frame_visibility()
    if IsInGroup() then
      return
    end
    if InCombatLockdown() then
      self:RegisterEvent("PLAYER_REGEN_ENABLED", on_update_party_frame_visibility)
      return
    else
      self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
    CompactPartyFrame:SetShown(true)
    local cuf_frame = _G["CompactPartyFrameMember1HealthBar"]:GetParent()
    if cuf_frame and cuf_frame.RFS_FrameEnvironment then
      addon:CreateOrUpdateAuraScanner(cuf_frame)
    end
  end

  self:HookFunc(CompactPartyFrame, "UpdateVisibility", on_update_party_frame_visibility)
  on_update_party_frame_visibility()
  PartyFrame:UpdatePaddingAndLayout()
end

function module:OnDisable()
  self:DisableHooks()
  if IsInGroup() then
    return
  end
  CompactPartyFrame:SetShown(false)
  PartyFrame:UpdatePaddingAndLayout()
end


