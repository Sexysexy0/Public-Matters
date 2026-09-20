#!/bin/bash
set -a; source .env; set +a

echo "════════════════════════════════════════════════════════"
echo "MULTI-CHAIN BALANCE DASHBOARD"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Wallet: $WALLET_ADDRESS"
echo ""

chains=(
  "Ethereum Sepolia:$ETH_SEPOLIA_RPC"
  "Base Sepolia:$BASE_SEPOLIA_RPC"
  "OP Sepolia:$OP_SEPOLIA_RPC"
  "Arbitrum Sepolia:$ARB_SEPOLIA_RPC"
  "Polygon Amoy:$POLYGON_AMOY_RPC"
  "ZKsync Sepolia:$ZK_SEPOLIA_RPC"
  "Linea Sepolia:$LINEA_SEPOLIA_RPC"
)

for pair in "${chains[@]}"; do
  name="${pair%%:*}"
  rpc="${pair##*:}"
  balance=$(cast balance $WALLET_ADDRESS --rpc-url "$rpc" --ether 2>/dev/null || echo "N/A")
  printf "  %-20s %s ETH\n" "$name:" "$balance"
done
