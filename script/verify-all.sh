#!/bin/bash
cd ~/Public-Matters
set -a; source .env; set +a

echo "════════════════════════════════════════════════════════"
echo "AUTO-VERIFY ALL CONTRACTS"
echo "════════════════════════════════════════════════════════"

# Read from broadcast files
for file in broadcast/Deploy*.json; do
  [ -f "$file" ] || continue
  jq -r '.transactions[]? | select(.transactionType=="CREATE") | "\(.contractName) \(.contractAddress)"' "$file" 2>/dev/null
done | sort -u | while read name addr; do
  echo ""
  echo "▶ Verifying $name at $addr"
  forge verify-contract \
    --chain 11155111 \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --constructor-args $(cast abi-encode "constructor(address)" $OPERATOR_PRIVILEGES_V2_ADDRESS) \
    $addr "src/${name}.sol:${name}" 2>&1 | tail -3
done
