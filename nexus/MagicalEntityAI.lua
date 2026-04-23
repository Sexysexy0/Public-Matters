-- Custom AI for Mythical Sky Guardians
local creature = script.Parent
local detectionRange = 500

function onPlayerDetected(player)
    local distance = (creature.Position - player.Character.PrimaryPart.Position).Magnitude
    if distance < detectionRange then
        creature:MoveTo(player.Character.PrimaryPart.Position + Vector3.new(0, 50, 0))
        print("GUARDIAN: Observing the traveler from the heights.")
    end
end

-- Ambient Behavior: Circle the mountain peaks
while true do
    circleMountainPeak()
    wait(10)
end
