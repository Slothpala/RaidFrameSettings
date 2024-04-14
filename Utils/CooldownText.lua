local _, addonTable = ...
addonTable.cooldownText = {}
local CooldownText = addonTable.cooldownText

-- WoW Api
local SetScript = SetScript
local SetText = SetText
local Round = Round
local GetCooldownTimes = GetCooldownTimes
local GetCooldownDuration = GetCooldownDuration
-- Lua
local next = next
local string_format = string.format

-- Cooldown Formatting
local day = 86400
local hour = 3600
local min = 60

local function get_timer_text(number)
   if number < min then
      return Round(number)
   elseif number < hour then
      return string_format("%dm", Round( number / min ) )
   else
      return string_format("%dh", Round( number / hour ) )
   end
end

-- Cooldown Display
local cooldown_queue = {}

local on_update_frame = CreateFrame("Frame")

local interval = 0.25
local time_since_last_upate = 0

local function update_cooldowns(_, elapsed)
   time_since_last_upate = time_since_last_upate + elapsed
   if time_since_last_upate >= interval then
      time_since_last_upate = 0
      local current_time = GetTime()
      for cooldown in next, cooldown_queue do
         local time = ( cooldown:GetCooldownTimes() + cooldown:GetCooldownDuration() ) / 1000
         local left = time - current_time
         if left <= 0  then
            cooldown_queue[cooldown] = nil
         end 
         cooldown._rfs_cd_text:SetText(get_timer_text(left))
      end
      if next(cooldown_queue) == nil then
         on_update_frame:SetScript("OnUpdate", nil)
         time_since_last_upate = 0
         return
      end
   end
end

function CooldownText:StartCooldownText(cooldown)
   if not cooldown._rfs_cd_text then 
      return false
   end
   cooldown_queue[cooldown] = true
   if next(cooldown_queue) ~= nil then
      on_update_frame:SetScript("OnUpdate", update_cooldowns)
   end
end

function CooldownText:StopCooldownText(cooldown)
   cooldown_queue[cooldown] = nil
   if next(cooldown_queue) == nil then
      on_update_frame:SetScript("OnUpdate", nil)
   end
end

function CooldownText:DisableCooldownText(cooldown)
   if not cooldown._rfs_cd_text then 
      return 
   end
   self:StopCooldownText(cooldown)
   cooldown._rfs_cd_text:Hide()
end

-- The position of _rfs_cd_text on the frame aswell as the font should be set in the module
function CooldownText:CreateOrGetCooldownFontString(cooldown)
   if not cooldown._rfs_cd_text then
      cooldown._rfs_cd_text = cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
   end
   cooldown._rfs_cd_text:Show()
   return cooldown._rfs_cd_text
end