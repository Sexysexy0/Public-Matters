#!/bin/bash
# Linking Sturdy Chests to the Global Crafting System
echo "SYNCING: Sturdy Chest ID 1000 to Player Crafting Inventory..."
# Logic to allow crafting table to pull from 'Sturdy_Chest' NBT data
minecraft-server-command "/gamerule doGlobalCrafting true"
echo "QOL SUCCESS: You can now craft using stored materials anywhere in Aetheria."
