--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon

local AceGUI = LibStub("AceGUI-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local function create_ace_container(parent_frame)
  local scroll_container = AceGUI:Create("ScrollFrame")
  scroll_container:SetLayout("Fill")
  scroll_container.frame:SetParent(parent_frame)
  scroll_container.frame:SetPoint("TOPLEFT", parent_frame, "TOPLEFT", 25, -55)
  scroll_container.frame:SetPoint("BOTTOMRIGHT", parent_frame, "BOTTOMRIGHT", -25, 25)
  scroll_container.content:SetPoint("TOPLEFT", parent_frame, "TOPLEFT", 25, -55)
  scroll_container.content:SetPoint("BOTTOMRIGHT", parent_frame, "BOTTOMRIGHT", -25, 25)
  scroll_container.frame:SetClipsChildren(true)
  scroll_container.frame:Show()
  return scroll_container
end

local function create_scale_slider(parent_frame)
  local slider = CreateFrame("Slider", nil, parent_frame, "MinimalSliderTemplate")
  slider:SetPoint("LEFT", parent_frame.TitleContainer, "LEFT", 3, -1)
  slider:SetFrameLevel(parent_frame.TitleContainer:GetFrameLevel() + 1)
  slider:SetSize(125, 10)
  slider:SetMinMaxValues(0.5, 1)
  slider:SetValue(addon.db.global.options_frame.scale)
  slider:SetValueStep(0.01)
  slider:SetObeyStepOnDrag(true)
  slider:SetScript("OnValueChanged", function(_, value)
    addon.db.global.options_frame.scale = value
  end)
  slider:SetScript("OnMouseUp", function()
    parent_frame:SetScale(addon.db.global.options_frame.scale)
  end)
  return slider
end

local function create_minimize_btn(parent_frame)
  local button = CreateFrame("Button", nil, parent_frame, "MaximizeMinimizeButtonFrameTemplate")
  button:SetPoint("RIGHT", parent_frame.CloseButton, "LEFT")
  button:SetOnMaximizedCallback(function()
    parent_frame.tab_system:Show()
    parent_frame.scale_slider:Show()
    parent_frame:SetHeight(550)
    parent_frame:SetWidth(950)
  end)
  button:SetOnMinimizedCallback(function()
    parent_frame.tab_system:Hide()
    parent_frame.scale_slider:Hide()
    parent_frame:SetHeight(75)
    parent_frame:SetWidth(400)
    addon:PopUpFrame_Hide() -- This will only hide the frame if it exists.
  end)
  return button
end

local function create_resize_handle(parent_frame)
  local resize_handle = CreateFrame("Button", addonName .. "OptionsResizeButton", parent_frame)
  resize_handle:SetPoint("BOTTOMRIGHT",-1,1)
  resize_handle:SetSize(26, 26)
  resize_handle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  resize_handle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  resize_handle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  resize_handle:SetScript("OnMouseDown", function(_, button)
    if button == "LeftButton" then
      parent_frame:StartSizing("BOTTOMRIGHT")
    end
  end)
  resize_handle:SetScript("OnMouseUp", function(_, button)
    if button == "LeftButton" then
      parent_frame:StopMovingOrSizing("BOTTOMRIGHT")
    end
  end)
end

local function create_tabs(parent_frame, ...)
  local tab_system = CreateFrame("Frame", nil, parent_frame, "TabSystemTemplate")
  local tabs = {}
  tab_system:SetTabSelectedCallback(function()end)
  tab_system:SetPoint("TOPLEFT", parent_frame, "BOTTOMLEFT", 15, 2)
  for k, v in pairs({...}) do
    tab_system:AddTab(v)
    local tab = tab_system:GetTabButton(k)
    local min_width = tab.Left:GetWidth() + tab.Middle:GetWidth() + tab.Right:GetWidth()
    local text_width = tab.Text:GetWidth() + 20
    tab:SetWidth(math.max(min_width, text_width))
    tabs[v] = tab
  end
  tab_system:SetTab(1)
  tab_system:SetFrameStrata("DIALOG")
  return tab_system, tabs
end

local function clear_frame(frame)
  addon:PopUpFrame_Hide()
  frame.container:ReleaseChildren()
end

local options_frame = nil
function addon:GetOptionsFrame()
  if options_frame then
    return options_frame
  end
  options_frame = CreateFrame("Frame", "RaidFrameSettingsOptions", UIParent, "PortraitFrameTemplate")
  local r,g,b = PANEL_BACKGROUND_COLOR:GetRGB()
  options_frame.Bg:SetColorTexture(r,g,b,0.9)
  options_frame:SetScale(addon.db.global.options_frame.scale)
  options_frame:Hide()
  table.insert(UISpecialFrames, options_frame:GetName())
  options_frame:SetFrameStrata("DIALOG")
  options_frame.title = _G["RaidFrameSettingsOptionsTitleText"]
  options_frame.title:SetText("RaidFrameSettings - (" .. "@project-version@)")
  RaidFrameSettingsOptionsPortrait:SetTexture("Interface\\AddOns\\RaidFrameSettings\\Textures\\Icon.tga")
  options_frame:SetSize(950,550)
  options_frame:SetPoint("TOPLEFT", UIParent, "CENTER", -475, 275)
  options_frame:SetMovable(true)
  options_frame:SetUserPlaced(true)
  options_frame:SetClampedToScreen(true)
  options_frame:SetClampRectInsets(400, -400, 0, 180)
  options_frame:SetResizable(true)
  options_frame:SetResizeBounds(950,550, 950)
  options_frame:RegisterForDrag("LeftButton")
  options_frame.scale_slider = create_scale_slider(options_frame)
  options_frame.minimize_button = create_minimize_btn(options_frame)
  options_frame.resize_handle = create_resize_handle(options_frame)
  options_frame.TitleContainer:SetScript("OnMouseDown", function()
    options_frame:StartMoving()
  end)
  options_frame.TitleContainer:SetScript("OnMouseUp", function()
    options_frame:StopMovingOrSizing()
  end)
  options_frame.container = create_ace_container(options_frame)

  options_frame.tab_system, options_frame.tabs = create_tabs(options_frame,
    L["general_options_tab_name"],
    L["module_selection_tab_name"],
    L["font_options_tab_name"],
    L["buff_frame_options_tab_name"],
    L["debuff_frame_options_tab_name"],
    L["defensive_overlay_options_tab_name"],
    L["aura_groups_tab_name"],
    L["addon_colors_tab_name"],
    L["profiles_options_tab_name"]
  )

  -- General
  options_frame.tabs[L["general_options_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_General_Options_Tab", options_frame.container)
  end)

  -- Module Selection
  options_frame.tabs[L["module_selection_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Module_Selection_Tab", options_frame.container)
  end)

  -- Font
  options_frame.tabs[L["font_options_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Font_Options_Tab", options_frame.container)
  end)

  -- BuffFrame
  options_frame.tabs[L["buff_frame_options_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Buff_Frame_Options_Tab", options_frame.container)
  end)

  -- DebuffFrame
  options_frame.tabs[L["debuff_frame_options_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Debuff_Frame_Options_Tab", options_frame.container)
  end)

  -- Defensive Overlay
  options_frame.tabs[L["defensive_overlay_options_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Defensive_Overlay_Options_Tab", options_frame.container)
  end)

  -- Aura Groups
  options_frame.tabs[L["aura_groups_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Aura_Group_Options_Tab", options_frame.container)
  end)

  -- AddOn Colors
  options_frame.tabs[L["addon_colors_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_AddOn_Colors_Tab", options_frame.container)
  end)

  -- Profiles
  options_frame.tabs[L["profiles_options_tab_name"]]:HookScript("OnClick", function()
    clear_frame(options_frame)
    ACD:Open("RaidFrameSettings_Profiles_Options_Tab", options_frame.container)
  end)

  options_frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
      options_frame:Hide()
      options_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
      self:Print(L["option_open_after_combat_msg"])
    elseif event == "PLAYER_REGEN_ENABLED" then
      options_frame:Show()
      options_frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
  end)
  options_frame:HookScript("OnShow", function()
    options_frame.tab_system:SetTab(1)
    ACD:Open("RaidFrameSettings_General_Options_Tab", options_frame.container)
    options_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
  end)

  options_frame:HookScript("OnHide",function()
    clear_frame(options_frame)
    options_frame:UnregisterEvent("PLAYER_REGEN_DISABLED")
  end)

  self:OptionsFrame_UpdateTabs()
  return options_frame
end

function addon:OptionsFrame_UpdateTabs()
  if not options_frame then
    return
  end

  if self:IsModuleEnabled("Font") or self:IsModuleEnabled("DefensiveOverlay") or self:IsModuleEnabled("BuffFrame") or self:IsModuleEnabled("DebuffFrame") or self:IsModuleEnabled("AuraGroups") then
    options_frame.tabs[L["font_options_tab_name"]]:Show()
  else
    options_frame.tabs[L["font_options_tab_name"]]:Hide()
  end

  if not self:IsModuleEnabled("DebuffFrame") then
    options_frame.tabs[L["debuff_frame_options_tab_name"]]:Hide()
  else
    options_frame.tabs[L["debuff_frame_options_tab_name"]]:Show()
  end

  if not self:IsModuleEnabled("BuffFrame") then
    options_frame.tabs[L["buff_frame_options_tab_name"]]:Hide()
  else
    options_frame.tabs[L["buff_frame_options_tab_name"]]:Show()
  end

  if not self:IsModuleEnabled("DefensiveOverlay") then
    options_frame.tabs[L["defensive_overlay_options_tab_name"]]:Hide()
  else
    options_frame.tabs[L["defensive_overlay_options_tab_name"]]:Show()
  end

  if not self:IsModuleEnabled("AuraGroups") then
    options_frame.tabs[L["aura_groups_tab_name"]]:Hide()
  else
    options_frame.tabs[L["aura_groups_tab_name"]]:Show()
  end

  local prev_tab = options_frame.tab_system:GetTabButton(1)
  for i=2, #options_frame.tab_system.tabs do
    local tab = options_frame.tab_system:GetTabButton(i)
    if tab:IsShown() then
      tab:ClearAllPoints()
      tab:SetPoint("LEFT", prev_tab, "RIGHT", 0, 0)
      prev_tab = tab
    end
  end
end

function addon:OptionsFrame_Clear()
  if not options_frame then
    return
  end
  clear_frame(options_frame)
end

function addon:HideOptionsFrame()
  if not options_frame then
    return
  end
  options_frame:Hide()
end
