local addonName = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhTW", false, true)
if not L then return end

-- AddOn Messages
L["combat_lockdown_msg"] = "在戰鬥中你不能這樣做。請先結束戰鬥。"
L["rfs_option_not_enabled_msg"] = "RaidFrameSettingsOptions 插件當前已停用。您可以在插件列表中啟用它。"
