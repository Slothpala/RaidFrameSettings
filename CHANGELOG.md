# **Changelog**
<<<<<<< HEAD
### Version [4.3.0] - 2026-02-10
#### Added
* Added new module: Range. Customize the out of range alpha of unit frames.

#### Fixes
* OptionsFactory.lua: Fixed slider widget storing values as strings instead of numbers in the database, which caused errors with strict WoW API functions like SetAlpha.
=======
### Version [4.2.3] - 2026-02-08
#### Added
* Added a slider to scale the role icon.
>>>>>>> 6ca65fb57366ef5fdff4796cd2e251a30e4889e8

### Version [4.2.2] - 2026-02-03
#### Added
* Added a notification message and a check to ensure that the RaidFrameSettingsOptions addon is enabled before attempting to load it.
#### Fixes
* Fixed an issue that cuased the role icon to dissapear on CompactUnitFrame_UpdateRoleIcon.

### Version [4.2.1] - 2026-01-30
#### Added
* Added the option to select for which class the user want to see role icons.

### Version [4.2.0] - 2026-01-27
#### Added
* Added new module: SoloFrame. Displays the party frames even when playing solo.

### Version [4.1.0] - 2026-01-24
#### Added
* Added support for profiles.

#### Updated
* By default, all characters now share the same profile.

#### Fixes
* UnitCache.lua: Prevent unsafe usage of secret values with additional checks.


### Version [4.0.1] - 2026-01-23
#### Fixes
* FrameEnvironment.lua: Fixed an issue where the FRAME_ENV_CREATED event was triggered before the environment table was stored in the frame table. (This fixes the RaidMark module.)
* Added /rfs to the SlashCmdList table.

### Version [4.0.0] - 2026-01-20
* Initial Release of version 4.0.0 for the Midnight pre-patch.

