-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("CleanHighlight")

local highlight_tex_coords = {
	["Raid-AggroFrame"] = {  0.00781250, 0.55468750, 0.00781250, 0.27343750 },
	["Raid-TargetFrame"] = { 0.00781250, 0.55468750, 0.28906250, 0.55468750 },
}

-- Setup the module.
function module:OnEnable()
  local function set_highlight_texture(cuf_frame)
    cuf_frame.selectionHighlight:SetTexture(private.data_paths.textures.raid_frame_highlight)
    cuf_frame.selectionHighlight:SetTexCoord(unpack(highlight_tex_coords["Raid-TargetFrame"]))
    cuf_frame.selectionHighlight:SetAllPoints(cuf_frame)
    cuf_frame.aggroHighlight:SetTexture(private.data_paths.textures.raid_frame_highlight)
    cuf_frame.aggroHighlight:SetTexCoord(unpack(highlight_tex_coords["Raid-AggroFrame"]))
    cuf_frame.aggroHighlight:SetAllPoints(cuf_frame)
  end
  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", set_highlight_texture)
  private.IterateRoster(set_highlight_texture)
  if C_CVar.GetCVar("raidOptionDisplayPets") == "1" or C_CVar.GetCVar("raidOptionDisplayMainTankAndAssist") == "1" then
    self:HookFunc_CUF_Filtered("DefaultCompactMiniFrameSetup", set_highlight_texture)
    private.IterateMiniRoster(set_highlight_texture)
  end
end

function module:OnDisable()
  local function restore_defaults(cuf_frame)
    print("Restoring")
    cuf_frame.selectionHighlight:SetTexture("Interface\\RaidFrame\\Raid-FrameHighlights")
    cuf_frame.selectionHighlight:SetTexCoord(unpack(highlight_tex_coords["Raid-TargetFrame"]))
    cuf_frame.selectionHighlight:SetAllPoints(cuf_frame)
    cuf_frame.aggroHighlight:SetTexture("Interface\\RaidFrame\\Raid-FrameHighlights")
    cuf_frame.aggroHighlight:SetTexCoord(unpack(highlight_tex_coords["Raid-AggroFrame"]))
    cuf_frame.aggroHighlight:SetAllPoints(cuf_frame)
  end
  private.IterateRoster(restore_defaults)
  private.IterateMiniRoster(restore_defaults)
end
