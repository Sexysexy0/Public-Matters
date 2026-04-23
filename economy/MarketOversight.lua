-- Market Circuit Breaker Logic
local function monitorMarketHealth(itemID, currentPrice, lastPrice)
    local priceDrop = (lastPrice - currentPrice) / lastPrice
    
    -- If price drops more than 30% in 1 hour, trigger Circuit Breaker
    if priceDrop > 0.30 then
        Marketplace.LockTrading(itemID)
        notifyAdmins("CRITICAL: Market crash detected on item " .. itemID)
        print("CIRCUIT BREAKER: Trading halted to prevent Archegos-style collapse.")
    end
end
