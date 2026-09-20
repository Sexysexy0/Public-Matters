#!/bin/bash
cd ~/Public-Matters
set -a; source .env; set +a

OUTPUT=~/Public-Matters/research/wallet-history-$(date +%Y%m%d).csv
echo "block,tx_hash,to,from" > "$OUTPUT"

echo "▶ Fetching wallet history via Etherscan V2..."

# Use V2 API (new format)
curl -s "https://api.etherscan.io/v2/api?chainid=11155111&module=account&action=txlist&address=$WALLET_ADDRESS&startblock=0&endblock=99999999&sort=asc&apikey=$ETHERSCAN_API_KEY" \
  > /tmp/wallet-history.json

STATUS=$(jq -r '.status // "0"' /tmp/wallet-history.json)

if [ "$STATUS" = "1" ]; then
  jq -r '.result[] | "\(.blockNumber),\(.hash),\(.to // "CREATE"),\(.from)"' /tmp/wallet-history.json >> "$OUTPUT"
  TOTAL=$(tail -n +2 "$OUTPUT" | wc -l)
  echo "✅ Exported $TOTAL transactions"
  head -5 "$OUTPUT"
else
  echo "❌ API error: $(jq -r '.message // "unknown"' /tmp/wallet-history.json)"
  echo ""
  echo "▶ Fallback: Use cast to check current state"
  echo "  Current nonce: $(cast nonce $WALLET_ADDRESS --rpc-url $ETH_SEPOLIA_RPC)"
  echo "  Current balance: $(cast balance $WALLET_ADDRESS --rpc-url $ETH_SEPOLIA_RPC --ether) ETH"
fi
