-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("AuraSkin_Buffs")

-- Setup the module.
function module:OnEnable()
  local db_obj = CopyTable(addon.db.profile.module_data.AuraSkin_Buffs)
  local border_color = db_obj.border_color
  local border_size = db_obj.border_size

  local function create_border_edges(aura_frame)
    if aura_frame.RFS_AuraBorderEdges then
      return aura_frame.RFS_AuraBorderEdges
    end

    local edges = {}

    -- Top edge.
    edges.top = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.top:SetPoint("TOPLEFT", aura_frame, "TOPLEFT", 0, 0)
    edges.top:SetPoint("TOPRIGHT", aura_frame, "TOPRIGHT", 0, 0)

    -- Bottom edge.
    edges.bottom = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottom:SetPoint("BOTTOMLEFT", aura_frame, "BOTTOMLEFT", 0, 0)
    edges.bottom:SetPoint("BOTTOMRIGHT", aura_frame, "BOTTOMRIGHT", 0, 0)

    -- Left edge.
    edges.left = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.left:SetPoint("TOPLEFT", aura_frame, "TOPLEFT", 0, 0)
    edges.left:SetPoint("BOTTOMLEFT", aura_frame, "BOTTOMLEFT", 0, 0)

    -- Right edge.
    edges.right = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.right:SetPoint("TOPRIGHT", aura_frame, "TOPRIGHT", 0, 0)
    edges.right:SetPoint("BOTTOMRIGHT", aura_frame, "BOTTOMRIGHT", 0, 0)

    aura_frame.RFS_AuraBorderEdges = edges
    return edges
  end

  local function style_buff_frame(buff_frame)
    local icon = buff_frame.icon
    if not icon then
      return
    end

    -- Crop the icon to hide the default border.
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Create or reuse the border edge textures.
    local edges = create_border_edges(buff_frame)

    -- Apply color and size to all edges.
    for _, edge in pairs(edges) do
      edge:SetColorTexture(unpack(border_color))
      edge:Show()
    end
    edges.top:SetHeight(border_size)
    edges.bottom:SetHeight(border_size)
    edges.left:SetWidth(border_size)
    edges.right:SetWidth(border_size)

    -- Push the icon inward by border_size so the border edges are visible.
    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", buff_frame, "TOPLEFT", border_size, -border_size)
    icon:SetPoint("BOTTOMRIGHT", buff_frame, "BOTTOMRIGHT", -border_size, border_size)

    -- Make sure cooldown frame matches the icon.
    local cooldown = buff_frame.cooldown
    if cooldown then
      cooldown:ClearAllPoints()
      cooldown:SetAllPoints(icon)
    end
  end

  local function on_frame_setup(cuf_frame)
    for _, buff_frame in pairs(cuf_frame.buffFrames) do
      style_buff_frame(buff_frame)
    end
  end

  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", on_frame_setup)
  private.IterateRoster(on_frame_setup)
end

function module:OnDisable()

end
