local addonName, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings

local AceGUI = LibStub("AceGUI-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local frame = CreateFrame("Frame", "RaidFrameSettingsOptions", UIParent, "PortraitFrameTemplate")

local function addResizeButton()
    local resizeButton = CreateFrame("Button", addonName .. "OptionsResizeButton", frame)
    resizeButton:SetPoint("BOTTOMRIGHT",-1,1)
    resizeButton:SetSize(26, 26)
    resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resizeButton:SetScript("OnMouseDown", function(_, button) 
        if button == "LeftButton" then
            frame:StartSizing("BOTTOMRIGHT")
        end
    end)
    resizeButton:SetScript("OnMouseUp", function(_, button)
        if button == "LeftButton" then
            frame:StopMovingOrSizing("BOTTOMRIGHT")
        end
    end)
end

local function createAceContainer()
    local container = AceGUI:Create("SimpleGroup")
    container.frame:SetParent(frame)
    container.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -60)
    container.frame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 25)
    container.frame:SetClipsChildren(true)
    container.frame:Show()
    return container
end

frame:Hide()
local r,g,b = PANEL_BACKGROUND_COLOR:GetRGB()
frame.Bg:SetColorTexture(r,g,b,0.9)
frame:SetScript("OnEvent", frame.Hide)
tinsert(UISpecialFrames, frame:GetName())
frame.title = _G["RaidFrameSettingsOptionsTitleText"]
frame.title:SetText(addonName)
frame:SetFrameStrata("DIALOG")
frame:SetSize(950,500)
frame:SetPoint("CENTER", UIparent, "CENTER")
frame:SetMovable(true)
frame:SetResizable(true)
frame:SetUserPlaced(true)
frame:SetResizeBounds(800,200)
frame:SetClampedToScreen(true)
frame:SetClampRectInsets(400, -400, 0, 180)
frame:RegisterForDrag("LeftButton")
--classic PortraitFrameTemplate 
if not frame.TitleContainer then
    frame.TitleContainer = CreateFrame("Frame", nil, frame)
    frame.TitleContainer:SetAllPoints(frame.TitleBg)
end
frame.TitleContainer:SetScript("OnMouseDown", function()
    frame:StartMoving()
end)
frame.TitleContainer:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
end)
RaidFrameSettingsOptionsPortrait:SetTexture("Interface\\AddOns\\RaidFrameSettings\\Textures\\Icon\\Icon.tga")
addResizeButton()
local container = createAceContainer()
frame.container = container
frame:HookScript("OnShow",function()
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    ACD:Open("RaidFrameSettings_options",container)
end)
frame:HookScript("OnHide",function()
    frame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    container:ReleaseChildren()
end)

function RaidFrameSettings:GetOptionsFrame()
    return frame
end