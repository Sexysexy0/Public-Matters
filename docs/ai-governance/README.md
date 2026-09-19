# AI Governance Stack

On-chain infrastructure for AI agent governance. Addresses rogue AI failure
modes with enforced rules, not promises.

## Contracts

| Contract | Purpose |
|:---|:---|
| OperatorPrivileges | Role-based access, trust, safeguards |
| AIAgentRegistry | Identity, lifecycle, kill switch |
| AIDecisionAudit | Immutable decision log with supersede |
| AIAgentSandbox | Sandbox isolation before production |
| AIAgentBehaviorMonitor | Baseline + anomaly detection |
| GlobalEmergencyFreeze | 2-of-N global halt |
| AIAgentCommunicationGuard | Inter-agent message log |
| AIAgentReputation | Agent score, reward/slash |
| AIAgentTrainingRecord | Training + authorization proof |
| AIAgentResourceCap | Hard gas/value/action caps |
| AIGovernanceMultisig | N-of-M critical action approvals |
| AIAgentUpgradeTimelock | Time-delayed model swaps |

## Defense Layers

1. Prevention — sandbox, caps, training records
2. Detection — behavior monitor, comm guard
3. Response — kill switch, freeze, multisig
4. Accountability — audit, reputation, evidence

## Compliance

| Legislation | Counter |
|:---|:---|
| Stop Rogue AI Act | AIAgentRegistry |
| AI Kill Switch Act | killAgent, GlobalEmergencyFreeze |
| Anti-concealment | supersedeDecision preserves originals |
| Anti-fabrication | reasoningHash binds rationale |
| Unauthorized access | OperatorPrivileges gating |
