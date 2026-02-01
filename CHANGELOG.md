# **Changelog**
### Version [4.2.2] - 2026-01-**
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

