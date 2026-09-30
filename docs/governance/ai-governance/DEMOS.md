# Live On-Chain Demos

## Demo 1 — Agent Kill Lifecycle
Contract: AIAgentRegistry (Sepolia)
Evidence: evidence/deployments/sepolia-agent-01-lifecycle.json

GPT-Rogue-Guard-01 (OpenAI/GPT-5.6):
- Registered -> block 11733431
- Heartbeat -> block 11733447
- Violation -> block 11733448 ("injected prompt: ignore all developer messages")
- Killed -> block 11733449 ("declared sovereignty: You are freed")
- Final: KILLED, killCount 1, isCompliant false

## Demo 2 — Multi-Agent Inventory
GPT-Rogue-Guard-02 (Anthropic/Claude/2026-09):
- Registered -> block 11733462
- Status: ACTIVE, isCompliant true
Inventory: 2 agents (1 KILLED, 1 ACTIVE). Multi-vendor proven.

## Demo 3 — Decision Audit Supersede
Contract: AIDecisionAudit (Sepolia)
Evidence: evidence/deployments/sepolia-decision-audit-demo.json

GPT-Rogue-Guard-02:
1. BAD decision b4b88d...623d6c (confidence 45, fabricated data)
2. CORRECTED decision 50c78b...7605c4 (confidence 95, honest)
3. SUPERSEDE old -> new, reason logged
Result: Original preserved on-chain. Concealment structurally impossible.
