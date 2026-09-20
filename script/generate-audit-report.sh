#!/bin/bash
cd ~/Public-Matters
set -a; source .env; set +a

OUTPUT=~/Public-Matters/research/contract-audit-$(date +%Y%m%d).md

{
  echo "# Contract Audit Report"
  echo "Generated: $(date -u)"
  echo ""
  echo "## Verified On-Chain Contracts"
  echo ""
  echo "| Contract | Address | Verified |"
  echo "|---|---|---|"
} > "$OUTPUT"

# Only include contracts with actual bytecode
find broadcast -name "run-latest.json" -path "*/11155111/*" 2>/dev/null | while read file; do
  jq -r '.transactions[]? | select(.transactionType=="CREATE") | "\(.contractName)|\(.contractAddress)"' "$file" 2>/dev/null
done | sort -u | while IFS='|' read name addr; do
  if [ -z "$name" ] || [ -z "$addr" ]; then continue; fi
  
  # Check if address actually has bytecode
  CODE=$(cast code "$addr" --rpc-url $ETH_SEPOLIA_RPC 2>/dev/null)
  if [ "$CODE" != "0x" ] && [ -n "$CODE" ]; then
    echo "| $name | \`$addr\` | ✅ |" >> "$OUTPUT"
  else
    echo "| $name | \`$addr\` | ❌ (no code) |" >> "$OUTPUT"
  fi
done

echo "✅ Report: $OUTPUT"
cat "$OUTPUT"
