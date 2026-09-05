#!/bin/bash
set -e

README="README.md"
echo "## Deployment Ledger" > "${README}"
echo "" >> "${README}"

for file in broadcast/*/*/run-latest.json; do
  if [ -f "$file" ]; then
    suite=$(basename $(dirname "$file"))
    echo "### Suite: $suite" >> "${README}"
    
    # Extract contract deployments from the transactions array
    jq -r '.transactions[] | select(.contractName != null) | "- **" + .contractName + "**: `" + .contractAddress + "`"' "$file" >> "${README}"
    echo "" >> "${README}"
  fi
done

echo "Ledger updated with all broadcast contracts."
