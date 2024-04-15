local AddonName, addonTable = ...
local addon = addonTable.RaidFrameSettings

local spellCache = {}
addon.spellCache = spellCache

local cache = {}

spellCache.build = false

function spellCache.Set(data)
    cache = data
end

-- Builds a cache of name/icon pairs from existing spell data
-- This is a rather slow operation, so it's only done once, and the result is subsequently saved
function spellCache.Build()
    local co = coroutine.create(function()
        local id = 0
        local misses = 0
        while misses < 80000 do
            id = id + 1
            local name, _, icon = GetSpellInfo(id)

            if (icon == 136243) then -- 136243 is the a gear icon, we can ignore those spells
                misses = 0
            elseif name and name ~= "" and icon then
                cache[name] = cache[name] or {}

                if not cache[name].spells or cache[name].spells == "" then
                    cache[name].spells = id .. "=" .. icon
                else
                    cache[name].spells = cache[name].spells .. "," .. id .. "=" .. icon
                end
                misses = 0
                if addonTable.isVanilla and id == 81748 then -- jump around big hole with classic SoD
                    id = 219002
                end
            else
                misses = misses + 1
            end
            coroutine.yield()
        end
    end)

    local ticker
    ticker = C_Timer.NewTicker(0, function()
        -- Start timing
        local start = debugprofilestop()
        -- Resume as often as possible (Limit to 16ms per frame -> 60 FPS)
        while (debugprofilestop() - start < 16) do
            -- Resume or remove
            if coroutine.status(co) ~= "dead" then
                local ok, msg = coroutine.resume(co)
                if not ok then
                    geterrorhandler()(msg .. '\n' .. debugstack(co))
                    ticker:Cancel()
                end
            else
                ticker:Cancel()
                break
            end
        end
    end)

    spellCache.build = true
end

function spellCache.GetSpellsMatching(name)
    if cache[name] then
        if cache[name].spells then
            local result = {}
            for spell, icon in cache[name].spells:gmatch("(%d+)=(%d+)") do
                local spellId = tonumber(spell)
                local iconId = tonumber(icon)
                result[spellId] = icon
            end
            return result
        end
    end
end

-- This function computes the Levenshtein distance between two strings
-- It is used in this program to match spell icon textures with "good" spell names i.e.,
-- spell names that are very similar to the name of the texture
local function Lev(str1, str2)
    local matrix = {}
    for i = 0, str1:len() do
        matrix[i] = { [0] = i }
    end
    for j = 0, str2:len() do
        matrix[0][j] = j
    end
    for j = 1, str2:len() do
        for i = 1, str1:len() do
            if (str1:sub(i, i) == str2:sub(j, j)) then
                matrix[i][j] = matrix[i - 1][j - 1]
            else
                matrix[i][j] = math.min(matrix[i - 1][j], matrix[i][j - 1], matrix[i - 1][j - 1]) + 1
            end
        end
    end

    return matrix[str1:len()][str2:len()]
end

function spellCache.BestKeyMatch(nearkey)
    local bestKey = ""
    local bestDistance = math.huge
    local partialMatches = {}
    if cache[nearkey] then
        return nearkey
    end
    for key, value in pairs(cache) do
        if key:lower() == nearkey:lower() then
            return key
        end
        if (key:lower():find(nearkey:lower(), 1, true)) then
            partialMatches[key] = value
        end
    end
    for key, value in pairs(partialMatches) do
        local distance = Lev(nearkey, key)
        if (distance < bestDistance) then
            bestKey = key
            bestDistance = distance
        end
    end

    return bestKey
end

function spellCache.CorrectAuraName(input)
    local spellId = addon:SafeToNumber(input)
    if (spellId) then
        local name, _, icon = GetSpellInfo(spellId)
        if (name) then
            spellCache.AddIcon(name, spellId, icon)
            return name, spellId
        else
            return "Invalid Spell ID"
        end
    else
        local ret = spellCache.BestKeyMatch(input)
        if (ret == "") then
            return "No Match Found", nil
        else
            return ret, nil
        end
    end
end
