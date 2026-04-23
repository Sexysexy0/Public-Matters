-- Portal Interaction Logic
local portalFrame = script.Parent
local TeleportService = game:GetService("TeleportService")

local function onPortalEnter(otherPart)
    local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
    if player then
        print("MIGRATING: " .. player.Name .. " is entering the AAA Portal.")
        -- Trigger Cinematic Overlay
        player.PlayerGui.CinematicUI.Enabled = true
        -- Send Save Token to AAA Server
        syncDataWithAAAServer(player.UserId)
    end
end

portalFrame.Touched:Connect(onPortalEnter)
