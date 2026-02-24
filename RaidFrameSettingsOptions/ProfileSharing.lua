local addon_name, private = ...
local main_addon = _G["RaidFrameSettings"]
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)
local LibDeflate = LibStub("LibDeflate")
local AceSerializer = LibStub("AceSerializer-3.0")

-----------------------------
--- Serialize / Deserialize
-----------------------------

local function ExportProfile()
  local serialized = AceSerializer:Serialize(main_addon.db.profile)
  local compressed = LibDeflate:CompressZlib(serialized)
  local encoded = LibDeflate:EncodeForPrint(compressed)
  return encoded
end

local function ImportProfile(input)
  if not input or input == "" then
    main_addon:Print(L["import_empty_string_error"])
    return false
  end

  local decoded = LibDeflate:DecodeForPrint(input)
  if not decoded then
    main_addon:Print(L["import_decoding_failed_error"])
    return false
  end

  local decompressed = LibDeflate:DecompressZlib(decoded)
  if not decompressed then
    main_addon:Print(L["import_decompression_failed_error"])
    return false
  end

  local valid, data = AceSerializer:Deserialize(decompressed)
  if not valid or not data then
    main_addon:Print(L["import_deserialization_failed_error"])
    return false
  end

  for k, v in pairs(data) do
    if type(v) == "table" then
      main_addon.db.profile[k] = CopyTable(v)
    else
      main_addon.db.profile[k] = v
    end
  end

  ReloadUI()
  return true
end

-----------------------------
--- Frame Helper
-----------------------------

local function CreateDialogFrame(name, title_text, width, height)
  local frame = CreateFrame("Frame", name, UIParent, "PortraitFrameTemplate")
  frame:SetSize(width, height)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:SetFrameStrata("DIALOG")
  frame:Hide()

  -- Portrait and title.
  _G[name .. "Portrait"]:SetTexture("Interface\\AddOns\\RaidFrameSettings\\Data\\Textures\\Icon.tga")
  _G[name .. "TitleText"]:SetText(title_text)

  -- Dark background to match main options frame.
  frame.Bg:SetColorTexture(0.1, 0.1, 0.1, 0.95)

  -- Movable via title bar.
  frame.TitleContainer:SetScript("OnMouseDown", function()
    frame:StartMoving()
  end)
  frame.TitleContainer:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
  end)

  -- Inset frame for content area.
  local inset = CreateFrame("Frame", nil, frame, "InsetFrameTemplate")
  inset:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -60)
  inset:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 45)
  frame.inset = inset

  -- Scrollable edit box.
  local input_scroll = CreateFrame("ScrollFrame", name .. "InputScroll", inset, "InputScrollFrameTemplate")
  input_scroll:SetPoint("TOPLEFT", inset, "TOPLEFT", 6, -6)
  input_scroll:SetPoint("BOTTOMRIGHT", inset, "BOTTOMRIGHT", -6, 6)
  input_scroll.CharCount:Hide()
  input_scroll.EditBox:SetAutoFocus(false)
  input_scroll.EditBox:SetWidth(input_scroll:GetWidth()-10)
  input_scroll.EditBox:SetFontObject("ChatFontNormal")
  input_scroll.EditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

  frame.edit_box = input_scroll.EditBox
  frame.input_scroll = input_scroll

  table.insert(UISpecialFrames, name)

  return frame
end

-----------------------------
--- Export Frame
-----------------------------

local export_frame = CreateDialogFrame("RaidFrameSettingsExportFrame", L["export_profile"], 500, 300)

-- Hint text.
local export_hint = export_frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
export_hint:SetPoint("BOTTOMLEFT", 16, 14)
export_hint:SetText(L["export_hint"])

function private.ShowExportFrame()
  local encoded = ExportProfile()
  export_frame.edit_box:SetText(encoded)
  export_frame:Show()
  export_frame.edit_box:SetFocus()
  export_frame.edit_box:HighlightText()
end

-----------------------------
--- Import Frame
-----------------------------

local import_frame = CreateDialogFrame("RaidFrameSettingsImportFrame", L["import_profile"], 500, 300)

-- Import button.
local import_button = CreateFrame("Button", nil, import_frame, "UIPanelButtonTemplate")
import_button:SetSize(100, 22)
import_button:SetPoint("BOTTOMRIGHT", -16, 12)
import_button:SetText(L["label_import"])
import_button:SetScript("OnClick", function()
  local input = import_frame.edit_box:GetText()
  local success = ImportProfile(input)
  if success then
    import_frame.edit_box:SetText("")
    import_frame:Hide()
    -- Refresh the profiles data provider.
    private.SetDataProvider("profiles_settings")
  end
end)

-- Hint text.
local import_hint = import_frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
import_hint:SetPoint("BOTTOMLEFT", 16, 14)
import_hint:SetText(L["import_hint"])

function private.ShowImportFrame()
  import_frame.edit_box:SetText("")
  import_frame:Show()
  import_frame.edit_box:SetFocus()
end

