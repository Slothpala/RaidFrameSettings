local _, addonTable = ...
local RaidFrameSettings = addonTable.RaidFrameSettings
local RaidMark = RaidFrameSettings:NewModule("RaidMark")
Mixin(RaidMark, addonTable.hooks)

local width, height
local x_offset, y_offset
local point
local alpha

function RaidMark:UpdateRaidMarker(frame)
    if not frame.raidmark then
        return
    end

    if not RaidFrameSettings.db.profile.Module.RaidMark then
        frame.raidmark:Hide()
        return
    end

    local index = GetRaidTargetIndex(frame.unit)
    if index and index >= 1 and index <= 8 then
        local texture = UnitPopupRaidTarget1ButtonMixin:GetIcon() or "Interface\\TargetingFrame\\UI-RaidTargetingIcons"
        local coords = _G["UnitPopupRaidTarget" .. index .. "ButtonMixin"]:GetTextureCoords()
        frame.raidmark:Show()
        frame.raidmark:SetTexture(texture, nil, nil, "TRILINEAR")
        frame.raidmark:SetTexCoord(coords.tCoordLeft, coords.tCoordRight, coords.tCoordTop, coords.tCoordBottom)
    else
        frame.raidmark:Hide()
    end
end

function RaidMark:UpdateAllRaidmark()
    RaidFrameSettings:IterateRoster(function(frame)
        RaidMark:UpdateRaidMarker(frame)
    end)
end

function RaidMark:OnEnable()
    local dbRaidMark = RaidFrameSettings.db.profile.MinorModules.RaidMark
    width, height = dbRaidMark.width, dbRaidMark.height
    x_offset, y_offset = dbRaidMark.x_offset, dbRaidMark.y_offset
    point = (dbRaidMark.position == 1 and "TOPLEFT") or (dbRaidMark.position == 2 and "TOP") or (dbRaidMark.position == 3 and "TOPRIGHT") or
        (dbRaidMark.position == 4 and "LEFT") or (dbRaidMark.position == 5 and "CENTER") or (dbRaidMark.position == 6 and "RIGHT") or
        (dbRaidMark.position == 7 and "BOTTOMLEFT") or (dbRaidMark.position == 8 and "BOTTOM") or (dbRaidMark.position == 9 and "BOTTOMRIGHT")
    alpha = dbRaidMark.alpha

    local function initRaidMark(frame, force)
        if not frame.raidmark then
            frame.raidmark = frame:CreateTexture(nil, "OVERLAY")
            force = true
        end
        if force then
            frame.raidmark:Hide()
            frame.raidmark:ClearAllPoints()
            frame.raidmark:SetPoint(point, x_offset, y_offset)
            frame.raidmark:SetSize(width, height)
            frame.raidmark:SetAlpha(alpha)
        end
    end
    self:HookFuncFiltered("DefaultCompactUnitFrameSetup", initRaidMark)

    RaidFrameSettings:IterateRoster(function(frame)
        initRaidMark(frame, true)
    end)
    self:UpdateAllRaidmark()

    self:RegisterEvent("RAID_TARGET_UPDATE", function()
        self:UpdateAllRaidmark()
    end)
end

function RaidMark:OnDisable()
    self:UnregisterEvent("RAID_TARGET_UPDATE")
    self:UpdateAllRaidmark()
end
