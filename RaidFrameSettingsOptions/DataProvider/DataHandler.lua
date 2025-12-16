local _, private = ...
local data_handler = {}
private.DataHandler = data_handler

local data_providers = {}

function data_handler.RegisterDataProvider(name, data_provider)
  data_providers[name] = data_provider
end

function data_handler.GetDataProvider(name)
  return data_providers[name]
end
