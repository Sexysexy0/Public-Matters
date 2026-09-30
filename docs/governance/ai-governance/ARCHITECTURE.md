# Architecture

## Authority

OperatorPrivileges is the single source of truth. All AI contracts call
privileges.isOperator(msg.sender). One place to add/remove operators.

## Defense in Depth

A rogue agent must bypass ALL layers:
1. Register (operator-only)
2. Pass sandbox (AIAgentSandbox)
3. Stay within caps (AIAgentResourceCap)
4. Avoid anomaly flag (AIAgentBehaviorMonitor)
5. Avoid unauthorized comm flag (AIAgentCommunicationGuard)
6. Avoid kill (killAgent)
7. Avoid global freeze (GlobalEmergencyFreeze)
8. Have valid training (AIAgentTrainingRecord)
9. Not have pending upgrade (AIAgentUpgradeTimelock)

## Upgrade Path

1. scheduleUpgrade(agentId, newModelHash, uri, delay)
2. Wait eta (min 1h, max 30d, default 2d)
3. executeUpgrade(agentId)
Cancellable any time before execution. Prevents silent swaps.
