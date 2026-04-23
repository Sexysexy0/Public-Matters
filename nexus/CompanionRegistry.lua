-- Pet Renaming and Breeding Logic
local function renameCompanion(companionID, newName)
    local companion = database:GetEntity(companionID)
    companion.Name = newName
    companion.IdentityTag = "CITIZEN_OF_PYWEL_" .. newName
    
    print("REGISTRY: Your companion is now officially named " .. newName)
end

-- New Bird Recruitment via 'Special Food' item
Events.OnItemUse:Connect(function(item, target)
    if item.Name == "Golden_Seed" and target.Type == "Bird" then
        recruitCompanion(target)
    end
end)
