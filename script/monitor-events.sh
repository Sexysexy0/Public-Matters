#!/bin/bash
cd ~/Public-Matters
set -a; source .env; set +a

echo "════════════════════════════════════════════════════════"
echo "EVENT MONITOR — ALL BLOCKS"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Current block: $(cast block-number --rpc-url $ETH_SEPOLIA_RPC)"
echo ""

# List of active contracts
contracts=(
  "OperatorPrivilegesV2:$OPERATOR_PRIVILEGES_V2_ADDRESS"
  "OperatorPrivileges:$OPERATOR_PRIVILEGES_ADDRESS"
  "ProjectContinuityRegistry:0x9b450FFCc0F84EAa901C6Eb7532986BD2563c4E8"
  "ContinuityGuard:0x69C4B7523917B8Fe3c67aabd51dfA5a5DA3a7cA1"
  "InvestigatorShield:0x469Cc1625ccaEA148427d5B85B9FE3DcA7C6CeDc"
  "AIAgentRegistry:0xfb302dD14e235266A6EdedfdD2CDF709c55D7aF5"
  "AIDecisionAudit:0x9E93a6A3421AD0F8F029406aC3Ce3E21e8544074"
  "AIGovernanceMultisig:0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6"
)

for pair in "${contracts[@]}"; do
  name="${pair%%:*}"
  addr="${pair##*:}"
  
  echo "▶ $name ($addr)"
  
  # Check if contract exists
  CODE=$(cast code "$addr" --rpc-url $ETH_SEPOLIA_RPC 2>/dev/null)
  if [ "$CODE" = "0x" ] || [ -z "$CODE" ]; then
    echo "  (no code — not deployed)"
    echo ""
    continue
  fi
  
  echo "  ✅ Contract exists"
  echo ""
done
