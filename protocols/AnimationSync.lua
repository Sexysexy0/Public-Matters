-- Fix for Player-to-Mount Animation Blending
local function fixRidingStance(player, mount)
    local saddlePoint = mount:GetAttachment("Saddle_Socket")
    
    -- Force Inverse Kinematics to lock player's hips to the saddle
    player.HumanoidRootPart.CFrame = saddlePoint.CFrame
    player.AnimationController:Play("Riding_Idle_V2", 0.1) -- Smoother blend
    
    print("ANIMATION SYNC: Player " .. player.Name .. " is now properly seated.")
end
