local _, private = ...

-- Main Frame
local frame = CreateFrame("Frame", "RaidFrameSettingsOptions", UIParent, "PortraitFrameTemplate")

-- Set the title text.
frame.title = _G["RaidFrameSettingsOptionsTitleText"]
frame.title:SetText("RaidFrameSettings")

-- Inset Frame.
frame.inset_frame = CreateFrame("Frame", nil, frame, "InsetFrameTemplate")
frame.inset_frame:SetPoint("TOPLEFT", frame, "TOPLEFT", 25, -60)
frame.inset_frame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -25, 25)

-- Scroll Box.
frame.inset_frame.scroll_box = CreateFrame("Frame", nil, frame.inset_frame, "WowScrollBoxList")
frame.inset_frame.scroll_box:SetPoint("TOPLEFT", frame.inset_frame, "TOPLEFT", 4, -4)
frame.inset_frame.scroll_box:SetPoint("BOTTOMRIGHT", frame.inset_frame, "BOTTOMRIGHT", -4, 4)

-- Scroll Bar.
frame.inset_frame.scroll_bar = CreateFrame("EventFrame", nil, frame.inset_frame, "MinimalScrollBar")
frame.inset_frame.scroll_bar:SetPoint("TOPLEFT", frame.inset_frame, "TOPRIGHT", 7, 0)
frame.inset_frame.scroll_bar:SetPoint("BOTTOMLEFT", frame.inset_frame, "BOTTOMRIGHT", 7, 0)

-- Initialize the Scroll View.
frame.scroll_view = CreateScrollBoxListTreeListView()
frame.scroll_view:SetPadding(10, 10, 10, 10, 4)
ScrollUtil.InitScrollBoxListWithScrollBar(frame.inset_frame.scroll_box, frame.inset_frame.scroll_bar, frame.scroll_view)

frame.Bg:SetColorTexture(0.1,0.1,0.1,0.95)
frame:SetFrameStrata("DIALOG") -- @TODO: Check best options.
table.insert(UISpecialFrames, frame:GetName())
frame:SetSize(925,525)
frame:SetResizeBounds(925, 400)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetMovable(true)
frame:SetResizable(true)
frame.TitleContainer:SetScript("OnMouseDown", function()
  frame:StartMoving()
  frame:SetAlpha(0.9)
end)
frame.TitleContainer:SetScript("OnMouseUp", function()
  frame:StopMovingOrSizing()
  frame:SetAlpha(1)
end)

-- Resize Handle
frame.resizeHandle = CreateFrame("Button", nil, frame)
frame.resizeHandle:SetPoint("BOTTOMRIGHT",-1,1)
frame.resizeHandle:SetSize(26, 26)
frame.resizeHandle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
frame.resizeHandle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
frame.resizeHandle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
frame.resizeHandle:SetScript("OnMouseDown", function(_, button)
  if button == "LeftButton" then
    frame:StartSizing("BOTTOMRIGHT")
  end
end)
frame.resizeHandle:SetScript("OnMouseUp", function(_, button)
  if button == "LeftButton" then
    frame:StopMovingOrSizing()
  end
end)

--
function private.GetOptionsFrame()
  return frame
end
