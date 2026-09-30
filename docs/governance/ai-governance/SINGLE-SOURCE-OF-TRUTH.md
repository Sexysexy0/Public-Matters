# Single Source of Truth

## The Problem (V1)

Two independent admin paths:

- OperatorPrivileges.owner - single EOA, no transfer
- AIAgentRegistry.admin - separate EOA, independent

Risks:

- Single-key compromise affects both paths
- No way to migrate to multisig
- Operator changes in Privileges don't affect Registry admin

## The Solution (V2)

### OperatorPrivilegesV2

- Adds pendingOwner + acceptOwnership() (2-step transfer)
- Owner can be transferred to AIGovernanceMultisig
- Preserves all V1 functions

### AIAgentRegistryV2

- Removed separate admin variable
- All authorization flows through privileges.isOperator()
- killSwitchAuthorized mapping still exists for delegated kill authority
- Operators automatically have kill authority

## Migration Path

1. Deploy OperatorPrivilegesV2 (initial owner = current EOA)
2. Deploy AIAgentRegistryV2 (points to V2)
3. Call transferOwnership(multisigAddress) on V2
4. Multisig calls acceptOwnership()
5. Result: Multisig owns everything; single source of truth

## Authority Flow

    AIGovernanceMultisig (2-of-3)
        |
        +-- owns --> OperatorPrivilegesV2
                        |
                        +-- isOperator[] --> AIAgentRegistryV2
                        +-- isOperator[] --> AIAgentSandbox
                        +-- isOperator[] --> AIAgentBehaviorMonitor
                        +-- isOperator[] --> GlobalEmergencyFreeze
                        +-- isOperator[] --> AIAgentCommunicationGuard
                        +-- isOperator[] --> AIAgentReputation
                        +-- isOperator[] --> AIAgentTrainingRecord
                        +-- isOperator[] --> AIAgentResourceCap
                        +-- isOperator[] --> AIAgentUpgradeTimelock

All AI contracts read from one authority. One place to change. One place to audit.

## V1 Compatibility

V1 contracts remain live. V2 is the canonical authority for future
deployments and multisig-controlled operations. No breaking changes
to existing V1 deployments.
