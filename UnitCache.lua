local _, addonTable = ...
local addon = addonTable.addon
addonTable.UnitCache = {}
local UnitCache = addonTable.UnitCache

------------------------
--- Speed references ---
------------------------

-- Lua

-- WoW Api
local UnitGUID = UnitGUID
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetRealmName = GetRealmName
local UnitClass = UnitClass
local UnitName = UnitName

-------------
--- Cache ---
-------------

local unit_cache = {}

local fallback_cache_entry = {
  name = "Missing data",
  nickname = "Missing data",
  name_and_realm_name = "Missing data",
  realm = "Missing data",
  class = "PRIEST",
}

local nicknames = {}

--- Update the nicknames table
---@param new_nicknames table
function addon:UpdateNicknames(new_nicknames)
  nicknames = nicknames
  if addon:IsModuleEnabled("Font") then
    addon:ReloadModule("Font")
  end
end

--- For cases were GetPlayerInfoByGUID doesn't work
---@param guid string The units GUID
local function get_unit_token_from_guid(guid)
  local unit_token
  if guid == UnitGUID("player") then
    return "player"
  end
  for i=1, 4 do
    unit_token = "party" .. i
    if guid == UnitGUID(unit_token) then
      return unit_token
    end
  end
  for i=1, 40 do
    unit_token = "raid" .. i
    if guid == UnitGUID(unit_token) then
      return unit_token
    end
  end
  return false
end

local function validate_cache(cache)
  local is_valid_name = type(cache.name) == "string"
  local is_valid_nickname = type(cache.nickname) == "string"
  local is_valid_realm = type(cache.realm) == "string"
  local is_valid_class = ( type(cache.class) == "string" ) and ( addonTable.colors.class_colors[cache.class] ~= nil )
  return is_valid_name and is_valid_nickname and is_valid_realm and is_valid_class
end


---@param guid string the GUID of the unit.
---@return table unit_cache the new unit cache entry or fallback.
local function new_unit_cache(guid)
  if not guid then
    return fallback_cache_entry
  end
  -- This data appears to be cached by the game and may not always be immediately available.
  local _, english_class, _, _, _, name, realm_name = GetPlayerInfoByGUID(guid)
  -- If the data isn't available jet find the designated unit token and use this.
  if not english_class then
    local unit_token = get_unit_token_from_guid(guid)
    if not unit_token then
      return fallback_cache_entry
    else
      english_class = select(2, UnitClass(unit_token))
      name, realm_name = UnitName(unit_token)
    end
  end
  -- realm_name is an empty string if the player is from the same realm.
  local realm_name = ( realm_name and #realm_name > 0 ) and realm_name or GetRealmName()
  local name_and_realm_name = name .. "-" .. realm_name
  local cached_unit = {
    name = name,
    nickname = nicknames[name_and_realm_name] or name,
    name_and_realm_name = name_and_realm_name,
    realm = realm_name,
    class = english_class,
  }
  local is_valid = validate_cache(cached_unit)
  if not is_valid then
    return fallback_cache_entry
  end
  unit_cache[guid] = cached_unit
  return cached_unit
end

--- Get a units cache by GUID or build one if not existing.
---@param guid string The GUID of the unit.
---@return table unit_cache The cached data for the unit
function UnitCache:Get(guid)
  return unit_cache[guid] or new_unit_cache(guid)
end

--- Dump the cache
function UnitCache:Dump()
  unit_cache = {}
end
