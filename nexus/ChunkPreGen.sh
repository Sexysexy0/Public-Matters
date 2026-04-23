#!/bin/bash
# Pre-generating chunks for Terrain Diffusion to ensure playability
echo "Starting Voxy/Distant Horizons Pre-generation..."
minecraft-server-command "/chunky center 0 0"
minecraft-server-command "/chunky radius 5000"
minecraft-server-command "/chunky start"
echo "Chunks are being pre-baked. Pywel is forming..."
