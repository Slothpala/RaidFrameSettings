local addon_name, private = ...
_G[addon_name] = {}

private.FRAME_POINTS = {
  ["frame_point_top_left"] = "TOPLEFT",
  ["frame_point_top"] = "TOP",
  ["frame_point_top_right"] = "TOPRIGHT",
  ["frame_point_right"] = "RIGHT",
  ["frame_point_bottom_right"] = "BOTTOMRIGHT",
  ["frame_point_bottom"] = "BOTTOM",
  ["frame_point_bottom_left"] = "BOTTOMLEFT",
  ["frame_point_left"] = "LEFT",
  ["frame_point_center"] = "CENTER",
}
