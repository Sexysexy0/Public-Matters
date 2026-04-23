-- Hangar Blueprint & Assembly Logic
local function assembleStarterGlider(player, hangarLocation)
    local blueprint = "Pywel_Scout_V1"
    print("ASSEMBLING: " .. player.Name .. "'s first aeronautic vehicle at " .. hangarLocation)
    
    -- Triggers the 'Create' mod mechanical assembly
    spawnMechanicalBearing(hangarLocation + Vector3.new(0, 5, 0))
    attachWings("Canvas_Light")
    attachEngine("Steam_Boiler_T1")
    
    return "FLIGHT READY: Check your propeller clearance!"
end
