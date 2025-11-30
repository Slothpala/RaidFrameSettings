-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("HealthBarForeground_Texture")

-- Libs & Utils.
local media = LibStub("LibSharedMedia-3.0")

local DEFAULT_TEXTURE = "" --@TODO Find new default texture name.

-- Setup the module.
function module:OnEnable()
  local texture_name = addon.db.profile.health_bars.fg.texture
  if texture_name == DEFAULT_TEXTURE then return end
  local texture_path = media:Fetch("statusbar", texture_name)

  local function set_statusbar_texture(cuf_frame)
    cuf_frame.healthBar:SetStatusBarTexture(texture_path)
    cuf_frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
  end

  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", set_statusbar_texture)
  private.IterateRoster(set_statusbar_texture)

  if C_CVar.GetCVar("raidOptionDisplayPets") == "1" or C_CVar.GetCVar("raidOptionDisplayMainTankAndAssist") == "1" then
    -- Mini frames are the pet and tank target etc. frames
    local function set_mini_frame_textures(cuf_frame)
      cuf_frame.healthBar:SetStatusBarTexture(texture_path)
      cuf_frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
    end
    self:HookFunc_CUF_Filtered("DefaultCompactMiniFrameSetup", set_mini_frame_textures)
    private.IterateMiniRoster(set_mini_frame_textures)
  end
end

function module:OnDisable()

end
