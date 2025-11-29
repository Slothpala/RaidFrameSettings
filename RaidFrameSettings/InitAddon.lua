local addon_name, private = ...
local addon = {}
Mixin(addon, private.Mixins.AddonMixin)
_G[addon_name] = addon
