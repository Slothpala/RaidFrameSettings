--[[
   module copied rom https://github.com/excorp/RaidFrameSettings/blob/mod/Modules/Solo.lua
]]
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

local Solo = addon:NewModule("Solo")
Mixin(Solo, addonTable.hooks)

local last = false
function Solo:OnEnable()
   local function on_update_visibility()
      if addonTable.inCombat then
         addon:DelayUntilAfterCombat(on_update_visibility)
         return
      end

      local solo = true
      if IsInGroup() then
         solo = false
      end
      if solo == false and last == false then
         return
      end
      CompactPartyFrame:SetShown(solo)
      last = solo
   end
   self:HookFunc(CompactPartyFrame, "UpdateVisibility", on_update_visibility)

   if not IsInGroup() or not IsInRaid() then
      CompactPartyFrame:SetShown(true)
      PartyFrame:UpdatePaddingAndLayout()
   end
end

function Solo:OnDisable()
   self:DisableHooks()
   if not IsInGroup() or IsInRaid() then
      CompactPartyFrame:SetShown(false)
      PartyFrame:UpdatePaddingAndLayout()
      last = false
   end
end