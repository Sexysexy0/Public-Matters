-- Viral Moment Detection Logic
local function detectEpicStunt(velocity, altitude, interaction)
    if velocity > 100 and altitude > 500 and interaction == "MidAir_Mount_Switch" then
        -- Trigger Cinematic Camera for 5 seconds
        playCinematicEffect("SlowMotion_Impact")
        displayViralPrompt("TIKTOK READY: That stunt was Legendary! 🎬")
    end
end

-- Hooking into the player's movement state
player.Character.Humanoid.StateChanged:Connect(detectEpicStunt)
