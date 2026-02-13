-- Setup the env.
local addon_name, private = ...
local addon = _G[addon_name]

-- Create a module.
local module = addon:CreateModule("AuraSkin_Debuffs")

-- Setup the module.
function module:OnEnable()
  local db_obj = CopyTable(addon.db.profile.module_data.AuraSkin_Debuffs)
  local border_color = db_obj.border_color
  local border_size = db_obj.border_size
  local border_texture = "Interface\\Buttons\\WHITE8X8"

  local function create_border_edges(aura_frame)
    if aura_frame.RFS_AuraBorderEdges then
      return aura_frame.RFS_AuraBorderEdges
    end

    local edges = {}

    -- Top-left corner.
    edges.topleft = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.topleft:SetTexture(border_texture)
    edges.topleft:SetPoint("TOPLEFT", aura_frame, "TOPLEFT", 0, 0)

    -- Top-right corner.
    edges.topright = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.topright:SetTexture(border_texture)
    edges.topright:SetPoint("TOPRIGHT", aura_frame, "TOPRIGHT", 0, 0)

    -- Bottom-left corner.
    edges.bottomleft = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottomleft:SetTexture(border_texture)
    edges.bottomleft:SetPoint("BOTTOMLEFT", aura_frame, "BOTTOMLEFT", 0, 0)

    -- Bottom-right corner.
    edges.bottomright = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottomright:SetTexture(border_texture)
    edges.bottomright:SetPoint("BOTTOMRIGHT", aura_frame, "BOTTOMRIGHT", 0, 0)

    -- Top edge.
    edges.top = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.top:SetTexture(border_texture)
    edges.top:SetPoint("TOPLEFT", edges.topleft, "TOPRIGHT", 0, 0)
    edges.top:SetPoint("TOPRIGHT", edges.topright, "TOPLEFT", 0, 0)

    -- Bottom edge.
    edges.bottom = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.bottom:SetTexture(border_texture)
    edges.bottom:SetPoint("BOTTOMLEFT", edges.bottomleft, "BOTTOMRIGHT", 0, 0)
    edges.bottom:SetPoint("BOTTOMRIGHT", edges.bottomright, "BOTTOMLEFT", 0, 0)

    -- Left edge.
    edges.left = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.left:SetTexture(border_texture)
    edges.left:SetPoint("TOPLEFT", edges.topleft, "BOTTOMLEFT", 0, 0)
    edges.left:SetPoint("BOTTOMLEFT", edges.bottomleft, "TOPLEFT", 0, 0)

    -- Right edge.
    edges.right = aura_frame:CreateTexture(nil, "OVERLAY", nil, 7)
    edges.right:SetTexture(border_texture)
    edges.right:SetPoint("TOPRIGHT", edges.topright, "BOTTOMRIGHT", 0, 0)
    edges.right:SetPoint("BOTTOMRIGHT", edges.bottomright, "TOPRIGHT", 0, 0)

    aura_frame.RFS_AuraBorderEdges = edges
    return edges
  end

  local function style_debuff_frame(debuff_frame)
    local icon = debuff_frame.icon
    if not icon then
      return
    end

    -- Crop the icon to hide the default border.
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Hide the default Blizzard debuff type border if it exists.
    if debuff_frame.border then
      debuff_frame.border:Hide()
    end

    -- Create or reuse the border edge textures.
    local edges = create_border_edges(debuff_frame)

    -- Apply color and size to all edges and corners.
    for _, edge in pairs(edges) do
      edge:SetVertexColor(unpack(border_color))
      edge:Show()
    end

    -- Set sizes for edges.
    edges.top:SetHeight(border_size)
    edges.bottom:SetHeight(border_size)
    edges.left:SetWidth(border_size)
    edges.right:SetWidth(border_size)

    -- Set sizes for corners.
    edges.topleft:SetSize(border_size, border_size)
    edges.topright:SetSize(border_size, border_size)
    edges.bottomleft:SetSize(border_size, border_size)
    edges.bottomright:SetSize(border_size, border_size)

    -- Push the icon inward by border_size so the border edges are visible.
    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", debuff_frame, "TOPLEFT", border_size, -border_size)
    icon:SetPoint("BOTTOMRIGHT", debuff_frame, "BOTTOMRIGHT", -border_size, border_size)

    -- Make sure cooldown frame matches the icon.
    local cooldown = debuff_frame.cooldown
    if cooldown then
      cooldown:ClearAllPoints()
      cooldown:SetAllPoints(icon)
    end
  end

  local dispel_color_curve = C_CurveUtil.CreateColorCurve()
  dispel_color_curve:SetType(Enum.LuaCurveType.Step)
  dispel_color_curve:AddPoint(0, CreateColor(unpack(border_color)))  -- NONE
  dispel_color_curve:AddPoint(1, CreateColor(0.2, 0.6, 1.0, 1))  -- MAGIC
  dispel_color_curve:AddPoint(2, CreateColor(0.6, 0.0, 1.0, 1))  -- CURSE
  dispel_color_curve:AddPoint(3, CreateColor(0.6, 0.4, 0.0, 1))  -- DISEASE
  dispel_color_curve:AddPoint(4, CreateColor(0.0, 0.6, 0.0, 1))  -- POISON
  dispel_color_curve:AddPoint(11, CreateColor(0.8, 0, 0, 1))  -- BLEED

  local function set_border_to_debuff_color(cuf_frame, debuff_frame)
    local unit = cuf_frame.unit
    local edges = debuff_frame.RFS_AuraBorderEdges
    local aura_instance_id = debuff_frame.auraInstanceID

    if not unit or not edges or not aura_instance_id then return end

    local dispel_type_color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura_instance_id, dispel_color_curve)

    -- It's sometimes still nil. I might not have understood color curves
    for _, edge in pairs(edges) do
      edge:SetDesaturated()
      if dispel_type_color then
        edge:SetVertexColor(dispel_type_color:GetRGBA())
      else
        edge:SetVertexColor(unpack(border_color))
      end
    end
  end

  if db_obj.show_dispel_type_border then
    self:HookFunc("CompactUnitFrame_UtilSetDebuff", set_border_to_debuff_color)
  end


  local function on_frame_setup(cuf_frame)
    for _, debuff_frame in pairs(cuf_frame.debuffFrames) do
      style_debuff_frame(debuff_frame)
      if db_obj.show_dispel_type_border then
        set_border_to_debuff_color(cuf_frame, debuff_frame)
      end
    end
  end

  self:HookFunc_CUF_Filtered("DefaultCompactUnitFrameSetup", on_frame_setup)
  private.IterateRoster(on_frame_setup)
end

function module:OnDisable()

end
