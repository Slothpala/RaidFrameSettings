# **Changelog**
### Version [2.27.0] - 2024-04-02
#### Changed
* The SpellGetVisibilityInfo hook has been removed to fix an ongoing taint issue. To keep watchlist and blacklist working, I changed the aura frame processing for buffs and debuffs. As a side effect, the new method can now blacklist or whitelist any buff or debuff (the old method missed some, especially in pvp). Watchlist and Blacklist now rely on Buffs (for buff spellIds) and/or Debuffs (for debuff spellIds) to work.

### Version [2.26.1] - 2024-04-01
#### Added
* Option to color the aura duration timer by debuff color.

### Version [2.26.0] - 2024-03-30
#### Changed
* Reworked Debuffs for classic to match feature parity with retail.
* Changed the Default profile.
#### Fixes
* Changed how Blacklist and Watchlist are handeled on classic.

### Version [2.25.1] - 2024-03-30
#### Fixes
* Buffs, Debuffs and Buffs_Classic modules now hide the addon created aura indicator frames on disable.
#### Changed
* Renamed Auras to Auraframe Settings and added a desc field.


### Version [2.25.0] - 2024-03-29
#### Changed
* Reworked Buffs for classic to match feature parity with retail.

#### Fixes
* Fixed an issue with the roster cache building that affected the classic version if the user was not playing with KeepGroupsTogether, which also fixed an issue with the cache building when changing the edit mode layout between Separate Groups and Combine Groups.

### Version [2.24.2] - 2024-03-29
#### Added
* Minimap icon

#### Changed
* Once again, the Options Window will re-appear after combat ends. I don't know why I removed it in the first place.

### Version [2.24.1] - 2024-03-29
#### Added
* FrameColor Skin

### Version [2.24.0] - 2024-03-28
#### Fixes
* Watchlist and Blacklist modules no longer update currently affected auras. This was done to avoid a taint issue.

#### Added
* Aura position feature for debuffs.

#### Changed
* Extra debuff frames arrived.
    * The backend of the debuff module has been reworked. The user now has the option to adjust the number of debuff icons displayed on the raid frame (from 0 to 10). If you need more please let me know.
* Debuffs module now checks for blacklisted auras on top of AuraVisibilty util as some auras were still be shown.

### Version [2.23.0] - 2024-03-27
#### Changed
* Extra buff frames finally arrived! 
    * The backend of the buffs module has been reworked. The user now has the option to adjust the number of buff icons displayed on the raid frame (from 0 to 10). If you need more please let me know.
    * Auras set in Aura Position now have their own dedicated buff frame and will always be displayed when applied.
    * Auras set in Aura Position can now be scaled per aura.

#### Fixes
* Fixed some spellIds in the personal defensive list.

#### Author's Note
* Expect the same to happen with "Debuffs" in an upcoming update. Once "Debuffs" is done i will start porting the changes to classic.

### Version [2.22.7] - 2024-03-26
* Moved Aura Position one row up and added ab option to scale user placed auras.

### Version [2.22.6] - 2024-03-26
* Small visual improvements to the watchlist and an option to import the most important def CDs for all classes have been added.

### Version [2.22.5] - 2024-03-25
#### Changed
* AuraVisibility.lua now checks if a watchlist entry is flagged as debuff.
* Options.lua updated Watchlist module desc. Added a second input field to separate buffs and debuffs for the watchlist. Watchlist entrys spellIds are now color coded to indicate if they are a buff or a debuff.

### Version [2.22.4] - 2024-03-24
#### Added
* Utils -> AuraVisibilty.lua that can be used to blacklist or enable auras.
* Modules -> Watchlist.lua this module allows tracking buffs that are not shown by default + alter wether a watched buff should be shown only from you, in combat
* Modules -> Blacklist.lua this module replaces the old blacklist feature of the Buffs and Debuffs modules. The old blacklists will be imported.

#### Changed
* Modules -> Buffs.lua + Buffs_Classic.lua + Debuffs.lua + Debuffs_Classic.lua removed the module specific blacklist features.

### Version [2.22.3] - 2024-03-23
#### Changed
* Interface version updated to 100206

### Version [2.22.2] - 2024-02-24
#### Changed 
* Enabling an aura timer will now hide the OmniCC aura timer on that aura.

### Version [2.22.1] - 2024-02-15
#### Added
* Aura gap option for buff and debuff modules for retail and classic.

### Version [2.22.0] - 2024-02-12
#### Added
* Buffs / Debuffs modules for classic (vanilla/sod)
#### Changed 
* Buff and debuff stack text is now displayed above the swipe animation.

### Version [2.21.0] - 2024-01-31
#### Added
* Debuff aura increase
* Buffs/Debuffs wotlk
* descriptions for aura increase
* Option to select a battleground profile

#### Changed 
* Changed the method of how child groups get choosen under the "Auras" section from tabs to dropdown

### Version [2.20.2] - 2024-01-29
#### Changed 
* Aura Position & Blacklist entries now inculde the spellId

### Version [2.20.1] - 2024-01-26
#### Fixes
* Fixed a typo that caused the debuff blacklist to use the buff blacklist values.

### Version [2.20.0] - 2024-01-26
#### Added
* CooldownText.lua -> util to create and handle cooldown texts on "Cooldown" frames.
* Helper.lua -> utils file with 3 helper functions to reduce the lines of code in the modules themselves with the following functions for now:
    * ConvertDbNumberToOutlinemode
    * ConvertDbNumberToPosition
    * GetAuraGrowthOrientationPoints
* CPU Impact explanatory note added.

#### Changed 
* Overhauled Buffs & Debuffs module:
    * Buffs & Debuffs:
        * Overhauled Blacklist interface for Buffs & Debuffs, blacklist entries now have an icon in front of them and can be removed using the "remove" button.
        * Changed the way blacklisted auras are handled. They are now hidden instead of resized, and all other buff-/debuffframes are reanchored accordingly.
        * More anchor options have been added.
        * Options to control the behavior of the "Swipe" overlay have been added. 
        * Auras now have a duration timer text that can be disabled.
        * The display options panel got overhauled and options for the new duration timer and the stacks count have been added.
    * Buffs: 
        * New feature added "Aura Position", which allows certain auras to be freely placed on the frame, separate from the other buffs (similar feature coming soon for debuffs).
* HookRegistry.lua moved to Utils folder
* Updated modules CPU Impact notes. 

#### Fixes
* AuraHighlight: Missing auras will now only count in auras applied by the player.

### Version [2.19.3] - 2024-01-23
#### Fixes
* Fixed an issue that caused the options to be unusable on the classic versions.

### Version [2.19.2] - 2024-01-17
#### Fixes
* AuraHighlight: module works again without HealrhBars module enabled
* AuraHighlight: updateAurasFull seperated helpful harmful scans

### Version [2.19.1] - 2024-01-16
#### Updated 
* retail version updated to 100205 

### Version [2.19.0] - 2024-01-16
#### Changed
* Replaced module DebuffHighlight with AuraHighlight. The new modules allows for coloring based on a missing aura.

### Version [2.18.1] - 2024-01-07
#### Changed 
* moved information about group type profiles from _G to addon.db.global and added a new option for group type arena
* Added new Utils folder with GroupType.lua & ProfileSwitching.lua and moved profile switching and group type determination from core to these files.

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

