-- Monument of Souls: Displaying random fragments of player legacies
local monument = script.Parent
local legacyData = fetchLegacyCloudData()

function onTouch(player)
    local randomMessage = legacyData[math.random(#legacyData)]
    player.PlayerGui.HUD.Notification:Fire("VOICE FROM THE PAST: " .. randomMessage)
    print("A player has witnessed the legacy of another.")
end

monument.Touched:Connect(onTouch)
