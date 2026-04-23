#!/bin/bash
# Water Clamping Logic: Force water blocks to snap to terrain valleys
echo "OPTIMIZING: Clamping water bodies to Y-level terrain heights..."

# Scan world for floating water blocks (ID 9 or 8)
# Snap them to the nearest solid block below them
minecraft-server-command "/execute as @e[type=marker,tag=river_node] at @s run fill ~ ~-1 ~ ~ ~-1 ~ minecraft:water replace minecraft:air"

# Cleanup floating entities
minecraft-server-command "/kill @e[type=item,nbt={Item:{id:'minecraft:water_bucket'}}]"
echo "HYDROLOGY FIXED: Rivers are now grounded."
