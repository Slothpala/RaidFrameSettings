local _, addonTable = ...
local addon = addonTable.addon

--------------------
--- Libs & Utils ---
--------------------

local UnitCache = addonTable.UnitCache

------------------
--- CUF Frames ---
------------------

function addon:IterateMiniRoster(callback, req_frame_env)
  CompactRaidFrameContainer:ApplyToFrames("mini", function(cuf_frame)
    if req_frame_env and not cuf_frame.RFS_FrameEnvironment then
      -- skip
    else
      callback(cuf_frame)
    end
   end)
end

function addon:IterateRoster(callback, req_frame_env)
  CompactRaidFrameContainer:ApplyToFrames("normal", function(cuf_frame)
    if req_frame_env and not cuf_frame.RFS_FrameEnvironment then
      -- skip
    else
      callback(cuf_frame)
    end
  end)
end
