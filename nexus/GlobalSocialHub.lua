-- Global Hub Chat & Interaction Sync
local MessagingService = game:GetService("MessagingService")

function syncGlobalChat(message, senderPlatform)
    local payload = {
        ["Sender"] = message.User,
        ["Content"] = message.Text,
        ["Platform"] = senderPlatform,
        ["Timestamp"] = os.time()
    }
    
    -- Syncing with Minecraft/Web Dashboard
    MessagingService:PublishAsync("GlobalNexusChat", payload)
    print("CHAT SYNC: [" .. senderPlatform .. "] " .. message.User .. ": " .. message.Text)
end
