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
function addon:GetAuraGrowthOrientationPoints(number, gap)
    if gap == nil then
        gap = 0
    end
    local point, relativePoint, offsetX, offsetY
    if number == 1 then
        point = "BOTTOMRIGHT"
        relativePoint = "BOTTOMLEFT"
        offsetX = -gap
        offsetY = 0
    elseif number == 2 then
        point = "BOTTOMLEFT"
        relativePoint = "BOTTOMRIGHT"
        offsetX = gap
        offsetY = 0
    elseif number == 3 then
        point = "BOTTOMLEFT"
        relativePoint = "TOPLEFT"
        offsetX = 0
        offsetY = gap
    else
        point = "TOPLEFT"
        relativePoint = "BOTTOMLEFT"
        offsetX = 0
        offsetY = -gap
    end
    return point, relativePoint, offsetX, offsetY
end

function addon:GetPersonalCooldowns()
    local defensives = {}
    if addonTable.isRetail then
        for _, spellId in pairs({
            --DK
            48707, -- Anti Magic Shell
            48792, -- Icebound Fortitude
            --DH
            212800, -- Blur
            196555, -- Netherwalk
            187827, -- Metamorphosis
            --Druid
            22812, -- Barkskin
            200851, -- Rage of the Sleeper
            61336, -- Survival Instincts
            --Evoker
            363916, -- Obsidian Scales
            374348, -- Renewing Blaze
            --Hunter
            186265, -- Aspect of the Turtle
            264735, -- Survival of the Fittest
            --Mage
            45438, -- Ice Block
            342246, -- Alter Time
            113862, -- Greater Invisibility
            414658, -- Ice Cold
            --Monk
            125174, -- Touch of Karma
            122278, -- Dampen Harm
            122783, -- Diffuse Magic
            120954, -- Fortifying Brew
            --Paladin
            642, -- Divine Shield
            31850, -- Ardent Defender
            403876, -- Divine Protection Retri
            498, -- Divine Protection Holy
            86659, -- Guardian of Ancient Kings
            212641, -- Guardian of Ancient Kings + Glyph of Queens
            184662, -- Shield of Vengance
            -- Priest
            19236, -- Desperate Prayer
            47585, -- Dispersion
            -- Rogue
            31224, -- Cloak of Shadows
            5277, -- Evasion
            1966, -- Feint
            -- Shaman
            108271, -- Astral Shift
            -- Warlock
            108416, -- Dark Pact
            104773, -- Unending Resolve
            -- Warrior
            118038, -- Die by the Sword
            184364, -- Enraged Regeneration
            12975, -- Last Stand
            871, -- Shield Wall
            23920, -- Spell Reflection
        }) do 
            table.insert(defensives, tostring(spellId))
        end
    elseif addonTable.isWrath then

    elseif addonTable.isVanilla then

    end
    return defensives
end

function addon:GetSpellIdsByName(name)
    local spellIds = {}
    local list = addon.spellCache.GetSpellsMatching(addon.spellCache.CorrectAuraName(name))
    if list then
        for spellId in pairs(list) do
            tinsert(spellIds, spellId)
        end
    else
        local spellId = select(7, GetSpellInfo(name))
        if spellId then
            tinsert(spellIds, spellId)
        end
    end
    return spellIds
end

function addon:SafeToNumber(input)
    local nr = tonumber(input)
    return nr and (nr < 2147483648 and nr > -2147483649) and nr or nil
end
