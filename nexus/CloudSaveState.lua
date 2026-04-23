-- Roblox Side: Syncing Save State to Central Cloud
local HttpService = game:GetService("HttpService")
local URL = "https://api.pywel-nexus.com/v1/save-state"

local function savePlayerData(playerID, data)
    local jsonData = HttpService:JSONEncode(data)
    local response = HttpService:PostAsync(URL .. "/" .. playerID, jsonData)
    
    if response then
        print("SAVE SUCCESS: Player data migrated to Cloud.")
    end
end

-- Triggers on player leave or manual "Save" button click
