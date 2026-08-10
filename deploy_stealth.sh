#!/usr/bin/env bash

echo "🥷 Initiating stealth deployment protocol..."

# Load environment variables silently
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ .env file missing. Aborting."
  exit 1
fi

echo "🚀 Executing deployment to Sepolia (Paced Mode)..."
forge script script/DeployMasterArchitecture.s.sol:DeployMasterArchitecture \
  --rpc-url $SEPOLIA_RPC \
  --private-key $DEPLOYER_PRIVATE_KEY \
  --broadcast \
  --slow

# 🧹 Wiping traces from the environment
echo "🧹 Scrubbing memory and shell history..."
unset SEPOLIA_RPC
unset DEPLOYER_PRIVATE_KEY
history -c
rm -f ~/.bash_history
history -w

echo "👻 Deployment complete. Operations secured. Zero digital footprints left behind."
