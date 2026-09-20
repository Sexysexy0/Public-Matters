#!/bin/bash
cd ~/Public-Matters
set -a; source .env; set +a

echo "════════════════════════════════════════════════════════"
echo "MULTI-CHAIN BALANCE DASHBOARD"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Wallet: $WALLET_ADDRESS"
echo ""

show_balance() {
  local name="$1"
  local rpc="$2"
  if [ -z "$rpc" ]; then
    printf "  %-20s %s\n" "$name:" "(no RPC)"
    return
  fi
  local balance=$(cast balance $WALLET_ADDRESS --rpc-url "$rpc" --ether 2>/dev/null)
  if [ -z "$balance" ]; then
    balance="N/A"
  fi
  printf "  %-20s %s ETH\n" "$name:" "$balance"
}

show_balance "Ethereum Sepolia" "$ETH_SEPOLIA_RPC"
show_balance "Base Sepolia" "$BASE_SEPOLIA_RPC"
show_balance "OP Sepolia" "$OP_SEPOLIA_RPC"
show_balance "Arbitrum Sepolia" "$ARB_SEPOLIA_RPC"
show_balance "Polygon Amoy" "$POLYGON_AMOY_RPC"
show_balance "ZKsync Sepolia" "$ZK_SEPOLIA_RPC"
show_balance "Linea Sepolia" "$LINEA_SEPOLIA_RPC"

echo ""
echo "════════════════════════════════════════════════════════"
