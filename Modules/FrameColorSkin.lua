local _, addonTable = ...
local addon = addonTable.RaidFrameSettings

if IsAddOnLoaded("FrameColor") then
  local info = 
  {
    moduleName = "RaidFrameSettings",
    color1 = 
    {
      name = "Main",
      desc = "",
    },
    color2 = 
    {
      name = "Background",
      desc = "",
      hasAlpha = true,
    },
  }

  local module = FrameColor_CreateSkinModule(info)

  function module:OnEnable()
    local main_color = self:GetColor1()
    local bg_color = self:GetColor2()
    self:Recolor(main_color, bg_color, 1)
  end

  function module:OnDisable()
    local color = {r=1,g=1,b=1,a=1}
    self:Recolor(color, color, 0)
  end

  if addonTable.isRetail then
    function module:Recolor(main_color, bg_color, desaturation)
      local optionsFrame = addon:GetOptionsFrame()
      for _, texture in pairs(
        {
          optionsFrame.NineSlice.TopEdge,
          optionsFrame.NineSlice.BottomEdge,
          optionsFrame.NineSlice.TopRightCorner,
          optionsFrame.NineSlice.TopLeftCorner,
          optionsFrame.NineSlice.RightEdge,
          optionsFrame.NineSlice.LeftEdge,
          optionsFrame.NineSlice.BottomRightCorner,
          optionsFrame.NineSlice.BottomLeftCorner,  
        }
      ) do
        texture:SetDesaturation(desaturation)
        texture:SetVertexColor(main_color.r,main_color.g,main_color.b) 
      end
      local backgroundTexture = optionsFrame.Bg
      if backgroundTexture then
        backgroundTexture:SetDesaturation(desaturation)
        backgroundTexture:SetVertexColor(bg_color.r, bg_color.g, bg_color.b, bg_color.a)
      end
    end
  else
    function module:Recolor(main_color, bg_color, desaturation)
      for _, texture in pairs(
        {
          RaidFrameSettingsOptionsPortraitFrame,
          RaidFrameSettingsOptionsTopBorder,
          RaidFrameSettingsOptionsTopRightCorner,
          RaidFrameSettingsOptionsRightBorder,
          RaidFrameSettingsOptionsBotRightCorner,
          RaidFrameSettingsOptionsBtnCornerRight,
          RaidFrameSettingsOptionsBotLeftCorner,
          RaidFrameSettingsOptionsBtnCornerLeft,
          RaidFrameSettingsOptionsLeftBorder,
          RaidFrameSettingsOptionsBottomBorder,
        }
      ) do
        texture:SetDesaturation(desaturation)
        texture:SetVertexColor(main_color.r,main_color.g,main_color.b) 
      end
      local backgroundTexture = RaidFrameSettingsOptionsBg
      if backgroundTexture then
        backgroundTexture:SetDesaturation(desaturation)
        backgroundTexture:SetVertexColor(bg_color.r, bg_color.g, bg_color.b, bg_color.a)
      end
    end
  end
end