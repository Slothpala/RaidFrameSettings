--[[
    Created by Slothpala
--]]
local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local Fonts = RaidFrameSettings:NewModule("Fonts")
local Media = LibStub("LibSharedMedia-3.0")

function Fonts:OnEnable()
    --Name
    local Name = {}
    Name.Font             = Media:Fetch("font",RaidFrameSettings.db.profile.Fonts.Name.font)
    Name.FontSize         = RaidFrameSettings.db.profile.Fonts.Name.fontsize
    Name.FontColor        = RaidFrameSettings.db.profile.Fonts.Name.fontcolor
    Name.Classcolored     = RaidFrameSettings.db.profile.Fonts.Name.useclasscolor
    Name.Outlinemode      = ( RaidFrameSettings.db.profile.Fonts.Name.outlinemode == 1 and "OUTLINE" ) or ( RaidFrameSettings.db.profile.Fonts.Name.outlinemode == 2 and "THICKOUTLINE" ) or ( RaidFrameSettings.db.profile.Fonts.Name.outlinemode == 3 and "MONOCHROME" ) or ( RaidFrameSettings.db.profile.Fonts.Name.outlinemode == 4 and "NONE" )
    Name.Position         = ( RaidFrameSettings.db.profile.Fonts.Name.position == 1 and "TOPLEFT" ) or ( RaidFrameSettings.db.profile.Fonts.Name.position == 2 and "CENTER" ) or ( RaidFrameSettings.db.profile.Fonts.Name.position == 3 and "TOP" ) or ( RaidFrameSettings.db.profile.Fonts.Name.position == 4 and "BOTTOM" )
    Name.JustifyH         = ( RaidFrameSettings.db.profile.Fonts.Name.position == 1 and "LEFT" ) or "CENTER"
    Name.X_Offset         = RaidFrameSettings.db.profile.Fonts.Name.x_offset
    Name.Y_Offset         = RaidFrameSettings.db.profile.Fonts.Name.y_offset
    --Status
    local Status = {}
    Status.Font           = Media:Fetch("font",RaidFrameSettings.db.profile.Fonts.Status.font)
    Status.FontSize       = RaidFrameSettings.db.profile.Fonts.Status.fontsize
    Status.FontColor      = RaidFrameSettings.db.profile.Fonts.Status.fontcolor
    Status.Classcolored   = RaidFrameSettings.db.profile.Fonts.Status.useclasscolor
    Status.Outlinemode    = ( RaidFrameSettings.db.profile.Fonts.Status.outlinemode == 1 and "OUTLINE" ) or ( RaidFrameSettings.db.profile.Fonts.Status.outlinemode == 2 and "THICKOUTLINE" ) or ( RaidFrameSettings.db.profile.Fonts.Status.outlinemode == 3 and "MONOCHROME" ) or ( RaidFrameSettings.db.profile.Fonts.Status.outlinemode == 4 and "NONE" )
    Status.Position       = ( RaidFrameSettings.db.profile.Fonts.Status.position == 1 and "TOPLEFT" ) or ( RaidFrameSettings.db.profile.Fonts.Status.position == 2 and "CENTER" ) or ( RaidFrameSettings.db.profile.Fonts.Status.position == 3 and "TOP" ) or ( RaidFrameSettings.db.profile.Fonts.Status.position == 4 and "BOTTOM" )
    Status.JustifyH       = ( RaidFrameSettings.db.profile.Fonts.Status.position == 1 and "LEFT" ) or "CENTER"
    Status.X_Offset       = RaidFrameSettings.db.profile.Fonts.Status.x_offset
    Status.Y_Offset       = RaidFrameSettings.db.profile.Fonts.Status.y_offset
    --Advanced Font Settings
    local Advanced = {}
    Advanced.shadowColor = RaidFrameSettings.db.profile.Fonts.Advanced.shadowColor
    Advanced.x_offset    = RaidFrameSettings.db.profile.Fonts.Advanced.x_offset
    Advanced.y_offset    = RaidFrameSettings.db.profile.Fonts.Advanced.y_offset
    --Callbacks 
    local function UpdateAllCallback(frame)
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
    RaidFrameSettings:RegisterOnUpdateAll(UpdateAllCallback)
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
    RaidFrameSettings:RegisterOnUpdateName(UpdateNameCallback)
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