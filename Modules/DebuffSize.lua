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

--parts of this code are from FrameXML/CompactUnitFrame.lua
function DebuffSize:OnDisable()
    UtilSetDebuff_Callback = function() end
    local restoreDebuffFrames = function(frame)
        local frameWidth = frame:GetWidth()
        local frameHeight = frame:GetHeight()
        local componentScale = min(frameWidth / NATIVE_UNIT_FRAME_HEIGHT, frameWidth / NATIVE_UNIT_FRAME_WIDTH)
        local buffSize = math.min(15, 11 * componentScale)
        for i=1,#frame.debuffFrames do  
            frame.debuffFrames[i]:SetSize(buffSize, buffSize)
        end
    end
    RaidFrameSettings:IterateRoster(restoreDebuffFrames)
end
