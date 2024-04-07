--profile import / export functions
--[[
    the method to share and import profiles is based on:
    https://github.com/brittyazel/EnhancedRaidFrames/blob/main/EnhancedRaidFrames.lua
]]--
local _, addonTable = ...
local addon = addonTable.RaidFrameSettings
local LibDeflate = LibStub:GetLibrary("LibDeflate")

function addon:ShareProfile()
    --AceSerialize
	local serialized_profile = self:Serialize(self.db.profile) 
    --LibDeflate
	local compressed_profile = LibDeflate:CompressZlib(serialized_profile) 
	local encoded_profile    = LibDeflate:EncodeForPrint(compressed_profile)
	return encoded_profile
end

function addon:ImportProfile(input)
    --validate input
    --empty?
    if not input or input == "" then
        self:Print("No import string provided. Abort")
        return
    end
    --LibDeflate decode
    local decoded_profile = LibDeflate:DecodeForPrint(input)
    if decoded_profile == nil then
        self:Print("Decoding failed. Abort")
        return
    end
    --LibDefalte uncompress
    local uncompressed_profile = LibDeflate:DecompressZlib(decoded_profile)
    if uncompressed_profile == nil then
        self:Print("Uncompressing failed. Abort")
        return
    end
    --AceSerialize
    --deserialize the profile and overwirte the current values
    local valid, imported_Profile = self:Deserialize(uncompressed_profile)
    if valid and imported_Profile then
		for i,v in pairs(imported_Profile) do
            if type(v) == "table" then
                self.db.profile[i] = CopyTable(v)
            else
                local new_value = v
                self.db.profile[i] = new_value
            end
		end
    else
        self:Print("Invalid profile. Abort")
    end
end