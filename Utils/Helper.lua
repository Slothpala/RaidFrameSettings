local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

--[[
 
]]
function addon:ConvertDbNumberToOutlinemode(number)
    local outlinemodes = {
        [1] = "NONE",
        [2] = "OUTLINE",
        [3] = "THICKOUTLINE",
        [4] = "MONOCHROME",
        [5] = "MONOCHROMEOUTLINE",
        [6] = "MONOCHROMETHICKOUTLINE",
    }
    local outlinemode = outlinemodes[number]
    return outlinemode or ""
end

function addon:ConvertDbNumberToPosition(number)
    local positions = {
        [1] = "TOPLEFT",
        [2] = "TOP",
        [3] = "TOPRIGHT",
        [4] = "LEFT",
        [5] = "CENTER",
        [6] = "RIGHT",
        [7] = "BOTTOMLEFT",
        [8] = "BOTTOM",
        [9] = "BOTTOMRIGHT",
    }
    local position = positions[number]
    return position or ""
end

--[[

]]
--number = db value for growth direction 1 = Left, 2 = Right, 3 = Up, 4 = Down
function addon:GetAuraGrowthOrientationPoints(number) 
    local point, relativePoint
    if number == 1 then
        point = "BOTTOMRIGHT"
        relativePoint = "BOTTOMLEFT"
    elseif number == 2 then
        point = "BOTTOMLEFT"
        relativePoint = "BOTTOMRIGHT"
    elseif number == 3 then
        point = "BOTTOMLEFT"
        relativePoint = "TOPLEFT"
    else
        point = "TOPLEFT"
        relativePoint = "BOTTOMLEFT"
    end
    return point, relativePoint
end