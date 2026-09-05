#!/bin/bash
set -e

README="README.md"

echo "## Deployment Ledger" > "${README}"
echo "" >> "${README}"

for file in broadcast/*/*/run-latest.json; do
  suite=$(basename $(dirname "$file"))
  echo "### $suite" >> "${README}"
  jq -r '.receipts[] 
    | "- " + .contractName + ": " + .contractAddress 
    + "\n  Block: " + (.blockNumber|tostring) 
    + " | Gas: " + (.gasUsed|tostring) 
    + " | Paid: " + (.gasCost|tostring) + " ETH"' "$file" >> "${README}"
  echo "" >> "${README}"
done

echo "Ledger updated with all broadcast contracts."
