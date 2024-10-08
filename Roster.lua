--[[Created by Slothpala]]--
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

function addon:IterateArenaFrames(callback, req_frame_env)
  for i=1, 3 do
    local cuf_frame = _G["CompactArenaFrameMember" .. i]
    if cuf_frame then
      if req_frame_env and not cuf_frame.RFS_FrameEnvironment then
        -- skip
      else
        callback(cuf_frame)
      end
    end
  end
end
