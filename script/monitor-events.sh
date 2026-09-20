#!/bin/bash
set -a; source .env; set +a

echo "════════════════════════════════════════════════════════"
echo "EVENT MONITOR — LAST 1000 BLOCKS"
echo "════════════════════════════════════════════════════════"

CURRENT=$(cast block-number --rpc-url $ETH_SEPOLIA_RPC)
FROM=$((CURRENT - 1000))

# Monitor key events
echo ""
echo "▶ OperatorAdded events:"
curl -s "https://api-sepolia.etherscan.io/api?module=logs&action=getLogs&address=$OPERATOR_PRIVILEGES_V2_ADDRESS&fromBlock=$FROM&toBlock=latest&apikey=$ETHERSCAN_API_KEY" \
  | jq -r '.result[]? | "  Block \(.blockNumber) | Tx \(.transactionHash[:10])..."' | head -10

echo ""
echo "▶ ProjectRegistered events:"
curl -s "https://api-sepolia.etherscan.io/api?module=logs&action=getLogs&address=0x9b9C35BDFcc69478669B640c9E7D106dCF612dCE&fromBlock=$FROM&toBlock=latest&apikey=$ETHERSCAN_API_KEY" \
  | jq -r '.result[]? | "  Block \(.blockNumber) | Tx \(.transactionHash[:10])..."' | head -10
