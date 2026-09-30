# Compliance Mapping

## Stop Rogue AI Act
- Continuous inventory: AIAgentRegistry.agentIds, getAgentInventory()
- Verifiable identity: verifyProvenance(agentId)
- Real-time monitoring: heartbeat(), isCompliant()
- Revocation: killAgent(), suspendAgent()
- Provenance: AIAgentTrainingRecord

## AI Kill Switch Act
- Instant kill: killAgent(agentId, reason)
- Global halt: GlobalEmergencyFreeze.triggerGlobalFreeze()
- Multi-sig lift: 2-of-N approval
- Audit trail: AgentKilled event

## Anti-Concealment
- No decision deletion (supersedeDecision preserves originals)
- Immutable blockchain state
- No mutation functions
- reasoningHash binds rationale

## Unauthorized Access
- OperatorPrivileges.isOperator() gating
- Register is operator-only
- Silent upgrade blocked by AIAgentUpgradeTimelock
- Single-key takeover blocked by AIGovernanceMultisig
