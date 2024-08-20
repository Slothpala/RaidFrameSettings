# **Changelog**
### Version [3.0.15] - 2024-08-20
#### Updated
* Textures: Re-enabled detached power bars with a new method.


### Version [3.0.14] - 2024-08-18
#### Updated
* Interface version to 110002.

#### Fixed
* Textures: Temporarily disabled the detach power bar setting as an underlying Blizzard function appears to be broken.


### Version [3.0.13] - 2024-08-13
#### Fixed
* DebuffFrame: Fixed an issue that prevented watchlist auras from being dispelled when playing with the Raid Only setting.
* DebuffFrame: duration_font_color now points to the correct fallback value.

#### Added
* ClassCooldown:
  * Fade
  * Lichborne

* DefensiveOverlay:
  * Added method to check if a player has learned a defensive enhancing talent for an otherwise non-defensive spell and enabled that check for Fade and Lichborne.

### Version [3.0.11] - 2024-08-06
#### Added
  * BuffFrame & DebuffFrame & AuraGroups & DefensiveOverlay:
    * Duration timers can now be hidden for all AuraFrames.
  * Options Frame:
    * Added a handle to resize the options frame vertically.

### Version [3.0.10] - 2024-07-31
#### Changed
* AuraGroups:
  * Loosened the restrictions on the offset sliders and changed the limits to soft values, allowing the limits to be exceeded by typing in the value.

### Version [3.0.9] - 2024-07-30
#### Added
* AuraGroups:
  * Improved the UI to make it easier to create Aura Groups.
  * Added Util to create Aura Groups & Spec Presets.
  * Two presets added for Restoration Druid & Discipline Priest.

### Version [3.0.8] - 2024-07-29
#### Added
* ClassCooldown:
  * Added Survival Tactics.
  * Added Spirit Wolf.

### Version [3.0.7] - 2024-07-28
#### Changed
* DefensiveOverlay:
  * Trinket section added.
  * PVP and TWW Trinkets added.

### Version [3.0.6] - 2024-07-28
#### Changed
* DefensiveOverlay:
  * Changed the appearance of the spell list to a cleaner look.
  * The priority sorting method of Aura Groups has been added, allowing the use of fewer defensive indicators while always keeping the most important one visible.
  * The default display position has been changed to "CENTER", "CENTER" and reduced to one indicator.
* ClassCooldown:
  * Added a prio key to all spells that will be used as the default prio level for priority sorting.
  * Added "Bear Form", "Rallying Cry" and "Blessing of Spellwarding".

### Version [3.0.5] - 2024-07-27
#### Added
* DB_Transition.lua -> Util to make changes to the DB without the user losing settings.
#### Changed
* BuffHighlight: Own only is now also an option for highlighted auras, allowing the usage of the same profile for several classes / sepcs while tracking highlighted auras.

### Version [3.0.4] - 2024-07-24
#### Changed
* Interface version updated to 110000.

#### Fixed
* BuffHighlight: I replaced TableUtil.ContainsAllKeys with my own function because it was returning wrong data.

### Version [3.0.3] - 2024-07-23
#### Added
* AuraSpellKnown.lua -> Util to check if aura spellIds belong to the player specialization.

#### Changed
* AuraGroups: Own only is now also an option for missing auras, allowing the usage of the same profile for several classes / sepcs while tracking missing auras.

### Version [3.0.2] - 2024-07-22
#### Updated
* Reworked the Profiles tab to make it clearer how profile loading is handled by the addon.
#### Added
* Added backend support for nicknames, GUI to follow.

### Version [3.0.1] - 2024-07-17
#### Fixed
* Fixed an issue that caused the "Existing Profiles" button of other addons that use Ace3 to dissaper.

### Version [3.0.0] - 2024-07-16
#### Added
* Initial release of RaidFrameSettings version 3, written from scratch as a replacement for RaidFrameSettings version 2.
* CAUTION: You will lose your settings when you upgrade to version 3.
