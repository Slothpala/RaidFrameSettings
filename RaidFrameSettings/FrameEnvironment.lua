local addon_name, private = ...
local addon = _G[addon_name]

local CR = private.CallbackRegistry


local function create_frame_env()
  local env = {
    event_frame = CreateFrame("Frame"),
    callback_table = {}
  }


  function env:register_event_callback(name, event, callback)
    if not self.callback_table[event] then
      self.callback_table[event] = {}
    end
    self.event_frame:RegisterEvent(event)
    self.callback_table[event][name] = callback
  end

  function env:register_unit_event_callback(name, event, unit, callback)
    if not self.callback_table[event] then
      self.callback_table[event] = {}
    end
    self.event_frame:RegisterUnitEvent(event, unit)
    self.callback_table[event][name] = callback
  end

  function env:unregister_event_callback(name, event)
    if not self.callback_table[event] then
      return
    end
    self.callback_table[event][name] = nil
    if next(self.callback_table[event]) == nil then
      self.event_frame:UnregisterEvent(event)
    end
  end

  function env:Start()
    self.event_frame:SetScript("OnEvent", function(_, event, ...)
      for _, callback in pairs(self.callback_table[event]) do
        callback(...)
      end
    end)
  end

  function env:Stop()
    self.event_frame:SetScript("OnEvent", nil)
  end

  return env
end

function private.CreateOrUpdateFrameEnv()
  local function create_or_update_frame_env(cuf_frame)
    if not cuf_frame.RFS_FrameEnvironment then
      cuf_frame.RFS_FrameEnvironment = create_frame_env()
    end
  end

  -- Fire an event that notifies other modules that the frame environment has been updated.
  CR:Fire("FRAME_ENV_UPDATED", cuf_frame)

  if cuf_frame.unit then
    cuf_frame.RFS_FrameEnvironment:Start()
  else
    cuf_frame.RFS_FrameEnvironment:Stop()
  end

  CompactRaidFrameContainer:ApplyToFrames("normal", create_or_update_frame_env)
  CompactRaidFrameContainer:ApplyToFrames("mini", create_or_update_frame_env)
end
