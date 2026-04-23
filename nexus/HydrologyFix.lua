-- Manual River Generation based on Elevation Valleys
local function generateRivers(mapData)
    for x, z in pairs(mapData) do
        if mapData[x][z].elevation < 64 then -- If it's a valley
            placeBlock(x, 62, z, "minecraft:water")
            print("Carving river at valley: " .. x .. ", " .. z)
        end
    end
end

-- Hooking into the TD Explore data link
Events.OnWorldLoad:Connect(generateRivers)
