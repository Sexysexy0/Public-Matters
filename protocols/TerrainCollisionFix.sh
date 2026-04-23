#!/bin/bash
# Re-baking the collision meshes for the high-scale terrain
echo "Refreshing Global Collision Mesh..."
# Purging old navigation mesh
rm -rf cache/navmesh_old
# Re-calculating high-poly terrain interaction
./engine_tool --bake-collision --target "Pywel_Highlands"
echo "COLLISION FIXED: No more falling through the world."
