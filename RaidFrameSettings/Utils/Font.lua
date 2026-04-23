local _, private = ...

local table_insert = table.insert
local table_concat = table.concat

function private.BuildFontFlags(font_flags)
  local flags = {}
  local has_outline = font_flags.OUTLINE ~= ""
  local has_thick = font_flags.THICK ~= ""
  local has_monochrome = font_flags.MONOCHROME ~= ""
  local has_slug = font_flags.SLUG ~= ""

  if has_outline and has_thick then
    table_insert(flags, "THICKOUTLINE")
  elseif has_outline then
    table_insert(flags, "OUTLINE")
  end

  if has_monochrome then
    table_insert(flags, "MONOCHROME")
  end

  if has_slug then
    table_insert(flags, "SLUG")
  end

  if #flags == 0 then
    return nil
  end

  return table_concat(flags, ",")
end

function private.NormalizeFontHeight(font_height, fallback)
  return tonumber(font_height) or fallback or 12
end
