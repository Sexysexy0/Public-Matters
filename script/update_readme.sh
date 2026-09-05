#!/bin/bash
set -e

echo "## Deployment Ledger" > README.md

for f in broadcast/*/*/run-latest.json; do
  suite=$(basename $(dirname $f))
  echo -e "\n### Suite: $suite" >> README.md

  jq -r '
    .transactions[]
    | select(.contractName != null)
    | "\(.contractName)|\(.contractAddress)|\(.blockNumber // "N/A")|\(.gasUsed // "N/A")|\(.contractVerified // false)"
  ' $f \
  | sort -u \
  | awk -F'|' '{status=($5=="true"?"✅":"❌"); printf "- **%s**: `%s` (Block: %s, Gas: %s, Verified: %s)\n",$1,$2,$3,$4,status}' >> README.md
done

echo -e "\n---\n## Governance Context\n" >> README.md
cat docs/governance_sections.md >> README.md
