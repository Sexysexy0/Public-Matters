#!/bin/bash
# Snapshot logic to preserve the 'Handcrafted' legacy of players
echo "Creating Deep Snapshot of Player Sector..."
tar -czf legacy_worlds/$(date +%F)_$PLAYER_UID.tar.gz ./world/playerdata/$PLAYER_UID
# Syncing to the 'Eternal Vault' (Cloud Backup)
rclone copy legacy_worlds/ remote:EternalVault/
echo "LEGACY SECURED: Your creation is now immortal."
