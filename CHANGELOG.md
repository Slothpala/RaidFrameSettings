# **Changelog**
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

