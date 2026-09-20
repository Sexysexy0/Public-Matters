#!/bin/bash
cd ~/Public-Matters
set -a; source .env; set +a

echo "════════════════════════════════════════════════════════"
echo "AUTO-VERIFY ALL CONTRACTS"
echo "════════════════════════════════════════════════════════"

# Find all run-latest.json in broadcast subdirs
COUNT=0
find broadcast -name "run-latest.json" -path "*/11155111/*" 2>/dev/null | while read file; do
  jq -r '.transactions[]? | select(.transactionType=="CREATE") | "\(.contractName)|\(.contractAddress)"' "$file" 2>/dev/null
done | sort -u | while IFS='|' read name addr; do
  if [ -z "$name" ] || [ -z "$addr" ]; then continue; fi
  COUNT=$((COUNT + 1))
  echo ""
  echo "▶ [$COUNT] $name"
  echo "   Address: $addr"
  echo "   Verifying..."
  forge verify-contract \
    --chain 11155111 \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    "$addr" "src/${name}.sol:${name}" 2>&1 | tail -2
done

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Verify script done"
echo "════════════════════════════════════════════════════════"
