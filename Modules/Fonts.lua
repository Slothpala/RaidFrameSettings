--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local Fonts = RaidFrameSettings:NewModule("Fonts")
Mixin(Fonts, addonTable.hooks)
local Media = LibStub("LibSharedMedia-3.0")
local Cata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC

local ClearAllPoints = ClearAllPoints
local SetPoint = SetPoint
local SetFont = SetFont
local SetText = SetText
local SetWidth = SetWidth
local SetJustifyH = SetJustifyH
local SetShadowColor = SetShadowColor
local SetShadowOffset = SetShadowOffset
local SetVertexColor = SetVertexColor
local GetUnitName = GetUnitName
local UnitClass = UnitClass
local GetClassColor = GetClassColor

function Fonts:OnEnable()
    local dbObj = RaidFrameSettings.db.profile.Fonts
    --Name
    local Name = {}
    Name.Font             = Media:Fetch("font",dbObj.Name.font)
    Name.FontSize         = dbObj.Name.fontsize
    Name.FontColor        = dbObj.Name.fontcolor
    Name.Classcolored     = dbObj.Name.useclasscolor
    --OUTLINEMODE
    local flag1           = dbObj.Name.thick and "THICK" or ""
    local flag2           = dbObj.Name.outline and "OUTLINE" or ""
    local flag3           = dbObj.Name.monochrome and "MONOCHROME" or ""
    Name.Outlinemode      = ( flag1 .. flag2 .. ", " .. flag3 )
    Name.Position         = ( dbObj.Name.position == 1 and "TOPLEFT" ) or ( dbObj.Name.position == 2 and "CENTER" ) or ( dbObj.Name.position == 3 and "TOP" ) or ( dbObj.Name.position == 4 and "BOTTOM" )
    Name.JustifyH         = ( dbObj.Name.position == 1 and "LEFT" ) or "CENTER"
    Name.X_Offset         = dbObj.Name.x_offset
    Name.Y_Offset         = dbObj.Name.y_offset
    --Status
    local Status = {}
    Status.Font           = Media:Fetch("font",dbObj.Status.font)
    Status.FontSize       = dbObj.Status.fontsize
    Status.FontColor      = dbObj.Status.fontcolor
    Status.Classcolored   = dbObj.Status.useclasscolor
    --OUTLINEMODE
    local flag1           = dbObj.Status.thick and "THICK" or ""
    local flag2           = dbObj.Status.outline and "OUTLINE" or ""
    local flag3           = dbObj.Status.monochrome and "MONOCHROME" or ""
    Status.Outlinemode      = ( flag1 .. flag2 .. ", " .. flag3 )
    Status.Position       = ( dbObj.Status.position == 1 and "TOPLEFT" ) or ( dbObj.Status.position == 2 and "CENTER" ) or ( dbObj.Status.position == 3 and "TOP" ) or ( dbObj.Status.position == 4 and "BOTTOM" )
    Status.JustifyH       = ( dbObj.Status.position == 1 and "LEFT" ) or "CENTER"
    Status.X_Offset       = dbObj.Status.x_offset
    Status.Y_Offset       = dbObj.Status.y_offset
    --Advanced Font Settings
    local Advanced = {}
    Advanced.shadowColor = dbObj.Advanced.shadowColor
    Advanced.x_offset    = dbObj.Advanced.x_offset
    Advanced.y_offset    = dbObj.Advanced.y_offset
    --Callbacks 
    local function UpdateFont(frame)
        --Name
        frame.name:ClearAllPoints()
        frame.name:SetFont(Name.Font, Name.FontSize, Name.Outlinemode)
        frame.name:SetWidth((frame:GetWidth()))
        frame.name:SetJustifyH(Name.JustifyH)
        frame.name:SetPoint(Name.Position, frame, Name.Position, Name.X_Offset, Name.Y_Offset )
        frame.name:SetShadowColor(Advanced.shadowColor.r,Advanced.shadowColor.g,Advanced.shadowColor.b,Advanced.shadowColor.a)
        frame.name:SetShadowOffset(Advanced.x_offset,Advanced.y_offset)
        --Status
        frame.statusText:ClearAllPoints()
        frame.statusText:SetFont(Status.Font, Status.FontSize, Status.Outlinemode)
        frame.statusText:SetWidth((frame:GetWidth()))
        frame.statusText:SetJustifyH(Status.JustifyH)
        frame.statusText:SetPoint(Status.Position, frame, Status.Position, Status.X_Offset, Status.Y_Offset )
        frame.statusText:SetVertexColor(Status.FontColor.r,Status.FontColor.g,Status.FontColor.b)
        frame.statusText:SetShadowColor(Advanced.shadowColor.r,Advanced.shadowColor.g,Advanced.shadowColor.b,Advanced.shadowColor.a)
        frame.statusText:SetShadowOffset(Advanced.x_offset,Advanced.y_offset)
    end
    if (Cata) then
        self:HookFuncFiltered("CompactUnitFrame_UpdateVisible", UpdateFont)
    else
        self:HookFuncFiltered("DefaultCompactUnitFrameSetup", UpdateFont)
    end
    --
    local UpdateNameCallback
    if Name.Classcolored then
        UpdateNameCallback = function(frame) 
            local name = GetUnitName(frame.unit or "",true)
            if not name then return end
            local _, englishClass = UnitClass(frame.unit)
            local r,g,b = GetClassColor(englishClass)
            frame.name:SetVertexColor(r,g,b)
            frame.name:SetText(name:match("[^-]+")) --hides the units server. 
        end
    else
        UpdateNameCallback = function(frame) 
            local name = GetUnitName(frame.unit or "",true)
            if not name then return end
            frame.name:SetVertexColor(Name.FontColor.r,Name.FontColor.g,Name.FontColor.b)
            frame.name:SetText(name:match("[^-]+")) --hides the units server. 
        end
    end
    self:HookFuncFiltered("CompactUnitFrame_UpdateName", UpdateNameCallback)
    RaidFrameSettings:IterateRoster(function(frame)
        UpdateFont(frame)
        UpdateNameCallback(frame)
    end)
end

--parts of this code are from FrameXML/CompactUnitFrame.lua
function Fonts:OnDisable()
    local restoreFonts = function(frame)
        --Name
        frame.name:SetFont("Fonts\\FRIZQT__.TTF", 10,"NONE")
        frame.name:SetPoint("TOPLEFT", frame.roleIcon, "TOPRIGHT", 0, -1);
        frame.name:SetPoint("TOPRIGHT", -3, -3)
        frame.name:SetJustifyH("LEFT");
        frame.name:SetVertexColor(1,1,1)
        --Status
        local frameWidth = frame:GetWidth()
        local frameHeight = frame:GetHeight()
        frame.statusText:SetFont("Fonts\\FRIZQT__.TTF", 12,"NONE")
        frame.statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, frameHeight / 3 - 2)
        frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, frameHeight / 3 - 2)
        frame.statusText:SetVertexColor(0.5,0.5,0.5)
    end
    RaidFrameSettings:IterateRoster(restoreFonts)
end