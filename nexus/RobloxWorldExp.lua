-- Gravity Boots Script for Windrose Prototype
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local function activateGravityBoots()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- High jump / Parkour mode
    bodyVelocity.MaxForce = Vector3.new(0, 10000, 0)
    bodyVelocity.Parent = rootPart
    
    print("GRAVITY BOOTS ACTIVE: You can now board floating ships!")
    
    wait(2) -- Power lasts for 2 seconds
    bodyVelocity:Destroy()
end

-- Hook to a magical item in the map
script.Parent.Activated:Connect(activateGravityBoots)
