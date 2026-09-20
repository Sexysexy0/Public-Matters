#!/bin/bash
set -a; source .env; set +a

OUTPUT=~/Public-Matters/research/contract-audit-$(date +%Y%m%d).md

echo "# Contract Audit Report" > "$OUTPUT"
echo "Generated: $(date -u)" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## Contracts from Broadcast Files" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Name | Address | Creator | Block | Verified |" >> "$OUTPUT"
echo "|---|---|---|---|---|" >> "$OUTPUT"

for file in ~/Public-Matters/broadcast/Deploy*.json; do
  [ -f "$file" ] || continue
  jq -r '.transactions[]? | select(.transactionType=="CREATE") | "\(.contractName)|\(.contractAddress)"' "$file" 2>/dev/null
done | sort -u | while IFS='|' read name addr; do
  info=$(curl -s "https://api-sepolia.etherscan.io/api?module=contract&action=getcontractcreation&contractaddresses=$addr&apikey=$ETHERSCAN_API_KEY")
  creator=$(echo "$info" | jq -r '.result[0].contractCreator // "?"')
  txhash=$(echo "$info" | jq -r '.result[0].txHash // "?"')
  verified="⏳"
  echo "| $name | $addr | $creator | $txhash | $verified |" >> "$OUTPUT"
done

echo "✅ Report: $OUTPUT"
cat "$OUTPUT"
