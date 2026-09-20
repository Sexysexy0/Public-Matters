#!/bin/bash
set -a; source .env; set +a

OUTPUT=~/Public-Matters/research/wallet-history-$(date +%Y%m%d).csv

echo "timestamp,block,tx_hash,to,function,value_eth" > "$OUTPUT"

curl -s "https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$WALLET_ADDRESS&startblock=0&endblock=99999999&sort=asc&apikey=$ETHERSCAN_API_KEY" \
  | jq -r '.result[]? | "\(.timeStamp),\(.blockNumber),\(.hash),\(.to // "CREATE"),\(.functionName // "transfer"),\(.value)"' \
  >> "$OUTPUT"

TOTAL=$(tail -n +2 "$OUTPUT" | wc -l)
echo "✅ Exported $TOTAL transactions to $OUTPUT"
head -5 "$OUTPUT"
