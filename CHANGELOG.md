# **Changelog**
### Version [3.4.4] - 2025-02-25
#### Updated
* Interface version to: 110100.

### Version [3.4.3] - 2024-01-20
#### Authors Note
* Due to the profile fix, the user will have to select the profile again.
#### Fixed
* Fixed a problem where two specs of different classes with the same spec name would overwrite each other's group profile setting.
#### Updated
* Interface version to: 11000.
#### Added
* ClassCooldown:
  * Warrior:
    * Shield Block: DD Only
    * Ignore Pain: DD Only
  * Priest:
    * Protective Light

### Version [3.4.2] - 2024-10-27
#### Updated
* Changed the default name font to an open source font that supports Cyrillic characters. (If you have problems with your language/alphabet, please contact me, I don't want to exclude anyone).
* RestorationDruid.lua -> added a missing spellId for Lifebloom.

### Version [3.4.1] - 2024-10-26
#### Added
* An option got added to set a max length for the name font string.

### Version [3.4.0] - 2024-10-25
#### Added
* RaidFrameColor.lua -> The units power color can now be used as the background color of the power bar and is the new default.
* Performance improvements for users that use BuffFrame, DebuffFrame & DebuffHighlight together. When these 3 modules are enabled, the UNIT_AURA event is now unregistered from the default frames, preventing unnecessary aura processing.

#### Updated
* enUS.lua
  * the value of "module_raid_frame_color_name" got changed from "Health Color Settings" to "Color Settings".
  * the key "health_bar_background_class_color_darkening_factor_name" got changed to "color_darkening_factor_name".
  * the key "health_bar_background_class_color_darkening_factor_desc" got changed to "color_darkening_factor_desc".
* The interface version got updated to 110005.
* OptionsFrame.lua -> The options frame now fades to alpha 0.5 when clicking the titele bar and now only registers LeftButton clicks.

### Version [3.3.2] - 2024-10-20
#### Fixed
* AuraFrame.lua -> Aura indicators with enabled tooltip now have SetPropagateMouseMotion set to true for click cast and condition macros to work. Aura indicators without tooltips now have EnableMouse set to false.

### Version [3.3.1] - 2024-10-19
#### Added
* Texture.lua -> I created new flat textures for the aggro highlight and selection highlight, which are used when playing with the texture module.

### Version [3.3.0] - 2024-10-19
#### Added
* RaidFrameColor.lua -> The unit class color can now be used as the background color and is the new default.

### Version [3.2.0] - 2024-10-17
#### Added
* ClassCooldown:
  * Warrior:
    * Defensive Stance: DD Only
* The CompactArenaFrames now respect the texture and color settings of the addon.

#### Updated
* ClassCooldown:
  * Druid:
    * Bear Form is now only shown for DAMAGER group role.
* AuraFrame.lua -> Aura indicators are now anchored to the health bar rather than the entire frame to not overlap power bars.
* Texture.lua -> CompactArenaFrame support added, powerbar and healthbar no longer have a set draw layer.
* RaidFrameColor.lua -> CompactArenaFrame support added.

### Version [3.1.0] - 2024-09-29
#### Added
* New Module: Raid Mark - Display a unit's target marker icon on the raid frame.

#### Updated
* The default duration timer font size got reduced.

### Version [3.0.24] - 2024-09-26
#### Added
* ClassCooldown:
  * Mage:
    * Mass Barrier
    * Prismatic Barrier
    * Blazing Barrier
    * Ice Barrier

#### Updated
* The default position of the Defensive Overlay got changed to not overlap with the default private aura anchor position.

### Version [3.0.23] - 2024-09-26
#### Fixed
* UnitCache.lua -> Changes have been made to reduce the likelihood of names being displayed as Unknown when playing with AI companions such as Brann or in Follower dungeons. The cached names are now also updated, so if a name is still shown as Unknown, it will automatically be fixed the next time the frame is updated.

### Version [3.0.22] - 2024-09-25
#### Updated/Fixed
* Changes have been made to the font options of all modules. The JusitfyV option has been removed from all modules as it serves no purpose when the anchor can be set freely.
* All font strings now have a set width, so they cannot grow out of the frame unless specifically set by offset. The width of the FontString is equal to the width of the frame on which it is placed + the absolute value of the horizontal offset.
* Because the font strings now have a fixed width, the JustifyH option now works as expected.

#### Removed
* The Detach option for the power bar was removed from the texture module as it was broken in its current state.

#### Updated
* The background color of the options frame got changed.

### Version [3.0.21] - 2024-09-09
#### Updated
* AuraIndicatorMixin.lua -> Changed how the get_timer_text function calculates the remaining time to match Blizzard's default style. Numbers less than 1 hour are rounded using math.floor, while numbers greater than 1 hour are rounded using math.ceil.

### Version [3.0.20] - 2024-08-30
#### Fixed
* DebuffFrame.lua -> Removed debug code.

#### Added
* DebuffHighlight -> Added an option to set a highlight texture.

### Version [3.0.19] - 2024-08-30
#### Added
* FrameEnvironment.lua -> CreateOrUpdateFrameEnv now fires a FRAME_ENV_UPDATED event with the cuf_frame as an argument.

#### Fixed
* DebuffFrame.lua -> Private Aura anchors will now update their unit on FRAME_ENV_UPDATED, fixing an issue where the private aura anchor would get stuck on the unit it was originally created for.

### Version [3.0.18] - 2024-08-22
#### Added
* ClassCooldown:
  * Stone Bulwark Totem

### Version [3.0.17] - 2024-08-22
#### Fixed
* AuraIndicatorMixin.lua -> Moved from now removed GetSpellInfo to C_Spell.GetSpellInfo.
* FrameEnvironment.lua -> Set cuf_frame at the parent of priv_indicator to respect the scale.
* DebuffFrame.lua -> Fixed a configuration issue that incorrectly set the cuf_frame as the parent for the private aura anchor, causing the entire frame to become unclickable.

### Version [3.0.16] - 2024-08-21
#### Fixed
* DebuffFrame: Attempted to fix an issue that made unit frames unclickable when a private aura was present.

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
