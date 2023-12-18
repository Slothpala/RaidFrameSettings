# **Changelog**
### Version [2.18.0] - 2023-12-18
#### Added
* The addon with its core modules "Health Bars", "Fonts", "Range", "Role Icon" (wotlk only) has been ported for classic (wotlk and vanilla/sod)

### Version [2.17.3] - 2023-12-14
#### Changed
* Font module:
    * reworked how the flags "OUTLINE", "THICKOUTLINE" and "MONOCHROME" are handled for name and status. The user now has 3 check boxes that cover all possible combinations of these flags.

### Version [2.17.2] - 2023-12-04
#### Changed
* Debuffs module:
    * improved the clean icon texture so that it does not overlap to the next icon and the cooldown swipe now covers the entire border for better visual clarity
    * adjusted texture slice margins accordingly and added a 1% offset to avoid distortion on scaled icons

### Version [2.17.1] - 2023-12-01
#### Fixed
* Fixed an issue that prevented the user from changing the active profile to anything other than the current group profile.

#### Changed
* the addons ReloadConfig() process

### Version [2.17.0] - 2023-11-26
#### Added
* LibCanDispel
* Overabsorb module:
    * customizable alpha value for the absorb glow

#### Changed
* DebuffHighlight moudle:
    * switched to library LibCanDispel to determine if a debuff is dispellable by the player.


### Version [2.16.5] - 2023-11-20
#### Fixed
* Typo  
### Version [2.16.4] - 2023-11-17
#### Changed
* DebuffHightlight.lua
    * renamed makeHooks to HookFrame and moved it to module scope
    * removed CompactUnitFrame_UnregisterEvents hook and the associated table hooked
    * moved RemoveHandler(frame, "OnEvent") right before HookScript(frame, "OnEvent", callback)


### Version [2.16.3] - 2023-11-16
#### Fixed
* Roster.lua allow registration of CompactPartyFrames without units to solve an issue with DebuffHighlight.lua

### Version [2.16.2] - 2023-11-15
#### Added
* DebuffHighlight: eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED") added to detect when learning a passive spell without unlearning or learning any new spell e.g. learning an override spell as a healer 

### Version [2.16.1] - 2023-11-13
#### Removed
* padding for clean icon debuffs removed for now 

### Version [2.16.0] - 2023-11-11
#### Added 
* DebuffOverlay_clean_icons.tga
* Clean icons for debuffs
* Clean borders for debuffs when using clean icons by making use of the new texture slicing system
 
#### Changed
* Boss aura increase is now a factor 

### Version [2.15.1] - 2023-11-10
#### Fixed
* Friendly nameplate issue in intance content.

#### Changed
* Roster.lua - local speed referneces added.

### Version [2.15.0] - 2023-11-08
#### Removed
* DispelColor.lua module
* Hooks.lua

#### Added
* HookRegistry.lua
* Roster.lua 
* DebuffHighlight.lua new written module as a replacement for DispelColor.lua that should fix many of it's issues and gives more options to the user.
* BleedDB.lua with M+ Season 3 Bleeds 

#### Changed
* The core of how the addons works has been changed. Modules now use the newly added HookRegistry.lua to register callbacks 
* Making changes to a module no longer requires the entire addon to be reloaded, greatly reducing CPU usage spikes when using the addon settings and allowing changes to be applied without throttling.
* The options frame will close upon entering combat to avoid taint.
* Opening the addon settings in combat is no longer possible to avoid taint.

### Version [2.10.5] - 2023-11-07
#### Changed
* interface version updated to 100200

### Version [2.10.4] - 2023-10-19

#### Added
-CHANGELOG.md  
-New hook option added to Hooks.lua "DefaultCompactMiniFrameSetup" that can be used to change the appereance of party pet frames. (working on a good solution for raid pets)  
-Making use of the new hook in HealthBars.lua to add texture support for party pet frames.

#### Changed
-Back to manual changelog: all notable changes are listed here, but not all git commits.  
-Iterate Roster function now also changes the arena frame.
-improvements to isValidCompactFrame function

