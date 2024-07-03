local _, addonTable = ...
local addon = addonTable.addon

local next = next
local animation_queue = {}
local animation_on_update_frame = CreateFrame("Frame")

local function Animation_OnUpdate(_, elapsed)
  for id, info in next, animation_queue do
    if not info.playing then
      info.playing = true
      info.elapsed = 0
      info.current_alpha = info.start_alpha
    end
    info.elapsed = info.elapsed + elapsed
    if info.elapsed < info.duration then
      local alpha = info.start_alpha + ( ( info.end_alpha - info.start_alpha ) * ( info.elapsed / info.duration) )
      info.current_alpha = alpha
      for _, frame in next, info.frames do
        frame:SetAlpha(alpha)
      end
    else
      info.current_alpha = info.end_alpha
      if info.onAnimationFinished then
        info.onAnimationFinished(info)
      end
      for _, frame in next, info.frames do
        frame:SetAlpha(info.end_alpha)
      end
      animation_queue[id] = nil
    end
  end
  if next(animation_queue) == nil then
    animation_on_update_frame:SetScript("OnUpdate", nil)
    return
  end
end

function addon:Fade(frame, info)
  local info = info
  info.frames = {frame}
  animation_queue[frame] = info
  if next(animation_queue) ~= nil then
    animation_on_update_frame:SetScript("OnUpdate", Animation_OnUpdate)
  end
end

function addon:StopAnimation(frame)
  animation_queue[frame] = nil
  if next(animation_queue) == nil then
    animation_on_update_frame:SetScript("OnUpdate", nil)
  end
end
