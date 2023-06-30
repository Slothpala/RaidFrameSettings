--[[
    Created by Slothpala
    Full credit for this module goes to clicket, who created the add-on https://www.curseforge.com/wow/addons/healer-mana-only on which this module is based.
--]]
local HealerManaOnly = RaidFrameSettings:NewModule("HealerManaOnly")

function HealerManaOnly:OnEnable()
    if C_CVar.GetCVar("raidFramesDisplayPowerBars") == "0" then
        C_CVar.SetCVar("raidFramesDisplayPowerBars","1")
    end
    local UpdateAllCallback = function(frame)
        local barHeight = UnitGroupRolesAssigned(frame.displayedUnit) == "HEALER" and 8 or 0
        frame.healthBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1 + barHeight)
        frame.buffFrames[1]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, CUF_AURA_BOTTOM_OFFSET + barHeight)
        frame.debuffFrames[1]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, CUF_AURA_BOTTOM_OFFSET + barHeight)
    end
    RaidFrameSettings:RegisterOnUpdateAll(UpdateAllCallback)
end

function HealerManaOnly:OnDisable()

end