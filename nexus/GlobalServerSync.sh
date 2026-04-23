#!/bin/bash
# Server Optimization for High-Scale Terrain
echo "Syncing World States and Clearing Entity Overload..."
minecraft-server-command "/gamerule randomTickSpeed 1"
minecraft-server-command "/dh renderdistance 64"
minecraft-server-command "/voxy memory_limit 8G"
echo "OPTIMIZATION COMPLETE: Pywel Nexus is ready for launch."
