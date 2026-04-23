-- Cross-Platform Transaction Guard
local function initiateMigration(playerID, targetPlatform)
    local sourceData = database:FetchProfile(playerID)
    local lockSuccess = database:SetLock(playerID, true) -- Lock profile during transit

    if lockSuccess then
        print("MIGRATION STARTED: Locking profile for " .. playerID)
        
        -- Double-check data integrity before pushing to target
        if sourceData.InventoryCount > 0 then
            local pushSuccess = targetPlatform:ReceiveData(sourceData)
            if pushSuccess then
                database:SetLock(playerID, false)
                print("MIGRATION SUCCESS: Data synced to " .. targetPlatform.Name)
            else
                -- ROLLBACK: If something fails, unlock and keep data on source
                database:SetLock(playerID, false)
                error("MIGRATION FAILED: Rolling back to source platform.")
            end
        end
    end
end
