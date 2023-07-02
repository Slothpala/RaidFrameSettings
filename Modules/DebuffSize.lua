--[[
    Created by Slothpala 
--]]
local DebuffSize = RaidFrameSettings:NewModule("DebuffSize")
local hooked = nil
local debuffsize_increase = BOSS_DEBUFF_SIZE_INCREASE
local minimum, maximum = min, max
local SetSize = SetSize
local IsForbidden = IsForbidden
local UtilSetDebuff_Callback

function DebuffSize:OnEnable()
    local width  = RaidFrameSettings.db.profile.MinorModules.DebuffSize.width
    local height = RaidFrameSettings.db.profile.MinorModules.DebuffSize.height
    UtilSetDebuff_Callback = function(debuffFrame, aura)
        if debuffFrame:IsForbidden() then return end
        if aura and aura.isBossAura then
            local boss_height = minimum(height + debuffsize_increase, debuffFrame.maxHeight)
            local boss_width  = maximum(width, boss_height)
            debuffFrame:SetSize(boss_width, boss_height)
        else
            debuffFrame:SetSize(width, height)
        end
    end
    if not hooked then
        hooksecurefunc("CompactUnitFrame_UtilSetDebuff", function(debuffFrame, aura) UtilSetDebuff_Callback(debuffFrame, aura) end)
        hooked = true
    end
    RaidFrameSettings:RegisterUpdateDebuffFrame(UtilSetDebuff_Callback)
end

function DebuffSize:OnDisable()
    UtilSetDebuff_Callback = function() end
end
