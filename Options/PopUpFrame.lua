--[[Created by Slothpala]]--
local addonName, addonTable = ...
local addon = addonTable.addon

local AceGUI = LibStub("AceGUI-3.0")

local function createAceContainer(parent)
  local scroll_container = AceGUI:Create("ScrollFrame")
  scroll_container:SetLayout("Fill")
  scroll_container.frame:SetParent(parent)
  scroll_container.frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, -40)
  scroll_container.frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, 25)
  scroll_container.frame:SetClipsChildren(true)
  scroll_container.frame:Show()

  return scroll_container
end

local function createCloseButton(parentFrame)
  local CloseButton = CreateFrame("Button", nil, parentFrame, "UIPanelCloseButton")
  CloseButton:SetPoint("TOPRIGHT", parentFrame, "TOPRIGHT", 1, 0)
  return CloseButton
end

local function applySkin(frame)
  local frameColor = {r=0.1,g=0.1,b=0.1,a=1}
  for _, texture in pairs({
    frame.NineSlice.TopEdge,
    frame.NineSlice.BottomEdge,
    frame.NineSlice.TopRightCorner,
    frame.NineSlice.TopLeftCorner,
    frame.NineSlice.RightEdge,
    frame.NineSlice.LeftEdge,
    frame.NineSlice.BottomRightCorner,
    frame.NineSlice.BottomLeftCorner,
  }) do
    texture:SetDesaturation(1)
    texture:SetVertexColor(frameColor.r,frameColor.g,frameColor.b,frameColor.a)
  end
  frame.Bg:SetColorTexture(0,0,0,0.9)
end


local frame = nil
function addon:GetPopUpFrame()
  if frame then
    return frame
  end
  local options_frame = addon:GetOptionsFrame()
  frame = CreateFrame("Frame", "RaidFrameSettingsTriggerFrame", options_frame, "DefaultPanelFlatTemplate")
  frame:Hide()
  frame:EnableMouse(true)
  createCloseButton(frame)
  frame.title = _G["RaidFrameSettingsTriggerFrameTitleText"]
  frame.Bg = frame:CreateTexture()
  frame.Bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -4)
  frame.Bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 3)
  local container = createAceContainer(frame)
  frame.container = container
  frame:SetPoint("TOPLEFT", options_frame, "TOPLEFT", 15, -55)
  frame:SetPoint("BOTTOMRIGHT", options_frame, "BOTTOMRIGHT", -15, 25)
  frame:HookScript("OnShow",function()
    frame:SetAlpha(0)
    local info = {
      duration = 0.28,
      start_alpha = 0,
      end_alpha = 1,
    }
    addon:Fade(frame, info)
  end)
  frame:HookScript("OnHide",function()
    container:ReleaseChildren()
  end)
  options_frame:HookScript("OnHide", function()
    frame:Hide()
  end)
  options_frame.pop_up_frame = frame
  applySkin(frame)
  return frame
end

function addon:PopUpFrame_Hide()
  if not frame then
    return
  end
  frame:Hide()
end
