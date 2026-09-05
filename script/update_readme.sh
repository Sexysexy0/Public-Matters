#!/bin/bash
JSON="broadcast/ArcadeSuiteDeploy.s.sol/11155111/run-latest.json"

ARC=$(jq -r '.transactions[0].contractAddress' $JSON)
SYM=$(jq -r '.transactions[1].contractAddress' $JSON)
CPF=$(jq -r '.transactions[2].contractAddress' $JSON)

cat <<EOT > README.md

## Arcade Governance Suite Deployments
| Contract              | Address | Verified |
|-----------------------|---------|----------|
| ArcadeGovernance      | $ARC | ✅ |
| SymbolismFilter       | $SYM | ✅ |
| ChildProtectionFund   | $CPF | ✅ |

EOT
