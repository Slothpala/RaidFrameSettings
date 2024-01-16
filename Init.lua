local _, addonTable = ...

addonTable.isRetail = true

addonTable.texturePaths = {
    PortraitIcon = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Icon\\Icon.tga",
}

addonTable.playerClass = select(2, UnitClass("player"))

addonTable.playableHealerClasses = {
    [1] = "PRIEST", 
    [2] = "PALADIN", 
    [3] = "SHAMAN", 
    [4] = "DRUID", 
    [5] = "MONK", 
    [6] = "EVOKER",
}