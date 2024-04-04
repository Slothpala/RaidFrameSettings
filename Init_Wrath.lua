local _, addonTable = ...

addonTable.isClassic = true
addonTable.isWrath = true
addonTable.isFirstLoad = true

addonTable.texturePaths = {
    PortraitIcon = "Interface\\AddOns\\RaidFrameSettings\\Textures\\Icon\\Icon_Circle.tga",
}

addonTable.playableHealerClasses = {
    [1] = "PRIEST", 
    [2] = "PALADIN", 
    [3] = "SHAMAN", 
    [4] = "DRUID", 
}