# Deployment notes

## forge 1.8.3 constructor-arg bug

`forge create` and `forge script` in forge 1.8.3 miscount constructor
arguments when passed via `--constructor-args`. The reported count is
wrong (reports N+2 for any N-arg constructor). Broadcast then reverts
after consuming the full gas limit, which looks like OOG but is
actually argument decoding.

Workaround: use `--constructor-args-path` with a JSON array.

    echo '["0xabc...", "0xdef..."]' > /tmp/args.json
    forge create src/My.sol:My \
      --rpc-url $RPC_URL \
      --private-key $PRIVATE_KEY \
      --constructor-args-path /tmp/args.json \
      --broadcast

Do not use `--constructor-args` on this forge version.

## Sepolia deployment (2026-10-11)

Registry:   0x948e9059c465980b5bE186212d09720F5D1D03f4
Integrator: 0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11

Constructor args:
- Registry:   OperatorPrivilegesV2 = 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98
- Integrator: OperatorPrivilegesV2,
              AIDecisionAudit    = 0x9E93a6A3421AD0F8F029406aC3Ce3E21e8544074,
              Registry           = 0x948e9059c465980b5bE186212d09720F5D1D03f4

Deployer: 0x6bDf6D887038AB97957c2f57d05eDd0eb338589A
Owner of OperatorPrivilegesV2: 0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6

## Post-deploy step (pending)

The integrator must be registered as an operator before it can write
audit records. The call is:

    addOperator(0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11)

on OperatorPrivilegesV2 (0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98).

Requires the owner (0xE696...c7F6). Interface unknown as of this
writing; registration not performed.

Until executed, the registry functions standalone. Audit records do
not populate. This is a post-deploy step, not a blocker.

Verify registration after executing:

    cast call 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98 \
      "isOperator(address)(bool)" \
      0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11 \
      --rpc-url $RPC_URL

## Multisig registration status

AIGovernanceMultisig (0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6)
owns OperatorPrivilegesV2 (0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98).
Threshold: 2-of-3.

Signers:
  0xF66b23603160dd880Ad1f77E459E014aFfcc6511
  0xF580403f2Fb2075984a36FF41504b6ADD151C721
  0x4b902973767F2315758CC051A78089f90981a820

Deployer (0x6bDf6D887038AB97957c2f57d05eDd0eb338589A) is NOT a signer.

## Register BudgetAuditIntegrator as operator (pending)

Through the multisig:

    MSIG=0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6
    OPV2=0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98
    INTEGRATOR=0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11

    DATA=$(cast calldata "addOperator(address)" $INTEGRATOR)

    # From signer 1 wallet:
    cast send $MSIG "createProposal(address,uint256,bytes,string)" \
      $OPV2 0 $DATA "Register BudgetAuditIntegrator as operator"

    # From signer 1 and signer 2 wallets (each approves; auto-executes at 2/3):
    cast send $MSIG "approve(uint256)" <PROP_ID>

Verify:
    cast call $OPV2 "isOperator(address)(bool)" $INTEGRATOR

## First live proposal (Sepolia)

Proposal ID: 0xb0d8e5ac9542abc54f977947a0848ec1aae5926faf6b75cccdfd0c95cb56e27f
Registry:    0x948e9059c465980b5bE186212d09720F5D1D03f4
Title:       Universal Healthcare 2027
Category:    health
Amount:      1 ETH (test)
Tier:        OPERATOR
Tx:          0xf2f0264cad9eab5f5cb9c84ff51469b08536d34ea9b17299bfd4ce01763e22df

Query at:
  https://sepolia.etherscan.io/address/0x948e9059c465980b5bE186212d09720F5D1D03f4

## Superseded deployment 1

0x948e9059c465980b5bE186212d09720F5D1D03f4 deployed before the
recordAudit stage guard was added. Contains one proposal
(0xb0d8e5ac...) that was marked AUDITED from DELIBERATING stage,
demonstrating the bug in a live record. Left on-chain as a
historical artifact.

## Superseded deployment 2

0xB41D91751D209859037FE850A86b886AB9796e70 deployed during a
patch attempt where the source edit failed before broadcast.
Bytecode is identical to deployment 1. No proposals.

## Full lifecycle demo — fixed registry (2026-10-11)

Registry: 0x8E4f12c712E9d995a6C226a2d7a79c8403E5De53 (with recordAudit guard)

Proposal 0x369e92b34fa6a1fce76708ad18df4597b64ec7fd72a12ea6b592af809c5ad935:

  stage:            AUDITED
  requiredTier:     OPERATOR
  votesFor:         2
  boardVotesFor:    1
  disbursedAmount:  1 ETH
  disbursements:    Q1 Hospitals 0.6 ETH (evidence 0x9f9f74f1...)
                    Q2 Clinics   0.4 ETH (evidence 0x5423975c...)
  auditVerdict:     "PASSED - funds used as intended"

Verification of the fix — an attempt to audit the proposal from
APPROVED stage (before disbursement) was made at block 11889696.
Result: status 0, revertReason "Not completed". The guard fires.

Category summary for "health":
  proposed:  1e18
  approved:  1e18
  disbursed: 1e18

Full lifecycle query from any block explorer:
  https://sepolia.etherscan.io/address/0x8E4f12c712E9d995a6C226a2d7a79c8403E5De53

This is the worked example from BUDGET-TRANSPARENCY-001, running.

## Supermajority demo — sole-actor flag (2026-10-11)

Registry: 0x8E4f12c712E9d995a6C226a2d7a79c8403E5De53

Configured composition: 3 board seats, 10000 bps stockholders.
Created proposal at Tier.SUPERMAJORITY (enum 3).
Deployer cast 2/3 board votes AND 7000 bps stockholder vote.
Approval required: board >= 2 AND stockholders >= 6667 bps.

Result: proposal APPROVED. getAction() shows soleActor = deployer.

This is Option C in practice: the contract does not block a single
actor from carrying a supermajority tier. It records it, permanently,
in the audit trail. A citizen querying the action sees both the tier
required and the fact that one address alone satisfied it.

When additional operators and stockholders are registered, the flag
stops firing on its own — no contract change required.

## Canonical deployment v4 (2026-10-11)

Registry:   0xcC0Bc1a6CF61De621952b5d74983577b306c2930
Integrator: 0x6075F5E8cA4975094347f7D5F9F843324Bb58367

Both source-verified on Etherscan.

Includes two fixes discovered during live testing:

1. recordAudit stage guard (from v3)
   - reverts with "Not completed" unless the proposal reached COMPLETED
   - verified live on v3 at block 11889696

2. meetsThreshold fail-closed (new in v4)
   - non-OPERATOR tiers cannot be satisfied when boardTotal or
     stockholderTotal is 0
   - verified live on v4 at block 11889848: proposal 0x01686651...
     reverted with "Tier not achieved" before composition was set;
     same proposal approved after setComposition(3, 10000)

Superseded deployments (all left on-chain as historical records):
  0x948e9059c4...  v1, first deploy, recordAudit unguarded
  0xB41D9175...    v2, bytecode identical to v1 (patch failed to apply)
  0x8E4f12c7...    v3, recordAudit guarded, meetsThreshold fail-open
  0x7C332bbEfe...  integrator v1, points at v1 registry

## TaxTransparencyRegistry (2026-10-11)

Registry: 0xdc1ec6d8C78DF97fA09AAE37Dcb07C1F76639D5C
Constructor: OperatorPrivilegesV2 = 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98
Deployer: 0x6bDf6D887038AB97957c2f57d05eDd0eb338589A
Tx: 0xd491a7f66d12f146b2306e81a548c83d4c375e785221093e1777a0c9436d52b8

Source-verified on Etherscan.

Two submission channels:
  - BIR_OPERATOR: onlyOperator (gated by OperatorPrivilegesV2)
  - TAXPAYER: permissionless, permanently attributed on-chain

Salted taxpayer hash, shared reduction base for two-sided rate
comparison. Reduction rates readable via getRDOReductionRate,
getExaminerReductionRate, getCategoryReductionRate.

Mission doc: docs/missions/TAX-TRANSPARENCY-001.md

## TaxTransparencyRegistry demo (2026-10-11)

Registry: 0xdc1ec6d8C78DF97fA09AAE37Dcb07C1F76639D5C

Data filed:
  Assessment 0x9f3df4d8... — RDO-039, examiner-042, MSME, PHP 5,000
    recordedBy: 0x6bDf...589A (BIR operator)
  Reduction (BIR):     500 (10%)  — recordedBy: 0x6bDf...589A
  Reduction (taxpayer): 4000 (80%) — recordedBy: 0xD489...2A01
  Payment:             1000       — recordedBy: 0xD489...2A01

Read back:
  getRDOReductionRate(RDO-039, BIR_OPERATOR)  -> 1000 bps (10%)
  getRDOReductionRate(RDO-039, TAXPAYER)      -> 8000 bps (80%)
  getCategoryReductionRate(MSME, BIR_OPERATOR) -> 1000 bps
  getCategoryReductionRate(MSME, TAXPAYER)     -> 8000 bps
  getTotals()                                  -> (5000, 4500, 1000)
  Counts                                       -> (1, 2, 1)

Two-sided reduction rates against a shared base assessment. The gap
between the two submitters is the signal. This is the mission of
TAX-TRANSPARENCY-001, demonstrated end-to-end on Sepolia.

Gas observations (for future demos):
  recordAssessment:  estimate 1.92M, actual ~1.9M  (use 2.5M limit)
  recordReduction:   estimate 2.04M, actual 2.02M  (use 3.0M limit)
  recordPayment:     estimate 1.36M, actual 1.35M  (use 2.0M limit)

Estimates are accurate; add 50% headroom, do not double.

## Four neutral accountability registries (2026-10-15)

All bound to OperatorPrivilegesV2 at 0x1ec4a1fB4e...EF98.
All deployed with forge create --constructor-args-path.

EnergyProductionRegistry:     0x486AEa41d529148a9577d1DCE4f24ef3E956bCa7
ImmigrationProcessingRegistry: 0x4FA55c4474Fb3f1664E6c2E91EF79649984D3d72
CitizenshipReviewRegistry:     0x8c61C1Ae301c5Ee664EF15bEF959C7a459e02Df2
PublicSafetyMetricsRegistry:   0x1871aA62a3870E9BAC7c2B3161dEd7F4Df7dd3f5

Four registries, same access pattern as budget and tax:
  - Writes gated by OperatorPrivileges.isOperator
  - Reads permissionless
  - No hardcoded owner; authority rotation is a single
    addOperator/removeOperator call on the shared registry

Tests: 49 passing across the four.

## Governance contracts v2 - operator-based (2026-10-16)

Rewritten to use OperatorPrivilegesV2 at 0x1ec4a1fB4e...EF98 instead
of hardcoded msg.sender. Previous versions had no transfer path.

AccessControlGovernance:     0x540Ac52035EdB24e25A9E5e85B0a0dAC7bb5FE99
CorporateUBOControl:         0xb3dDCc239375EF3cB86C332a84eeC0d0a4d6D8d9
SovereigntyPolicyRegistry:   0xE2516746fdBf0823d9A144229b662C2B83D4Ef8a

Changes:
- AccessControlGovernance: rootGovernor removed; role grants gated by
  OperatorPrivileges.isOperator
- CorporateUBOControl: multiple UBOs per entity; aggregate ownership
  enforced <= 10000 bps; verifier must differ from recorder
- SovereigntyPolicyRegistry: supersede chain added; policies never
  deleted; revokePolicy retained for cancellation without successor

Superseded (hardcoded msg.sender, no transfer path):
  AccessControlGovernance v1: 0xC1C2630076cC8Ada5544506B38C900d3D7506e64
  CorporateUBOControl v1:     0xB4eB4B01b6e2C3e8cD092891306626dC831F82f9
  SovereigntyPolicyRegistry v1: 0xb23ef644c6696Dc9C6eCeEEd36596418ccFbE338

Tests: 30 passing.

## Integrator v4 registered as operator (2026-10-16)

BudgetAuditIntegrator v4: 0x6075F5E8cA4975094347f7D5F9F843324Bb58367

Registered via AIGovernanceMultisig (0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6),
2-of-3 threshold, targeting OperatorPrivilegesV2 (0x1ec4a1fB4e...EF98).

Proposal id: 2
Signer 1 approval:   block 11923661
Signer 2 approval:   block 11923663 (auto-executed)
OperatorAdded event: 0x1ec4a1fB4e...EF98 block 11923663

Verified:
  cast call OPV2 "isOperator(address)(bool)" 0x6075F5E8...
  -> true

The budget audit trail is now fully wired. Every budget stage transition
that flows through BudgetDeliberationRegistry and then
BudgetAuditIntegrator will populate AIDecisionAudit with a permanent,
queryable record. The integrator holds operator status for that purpose
only; it cannot propose, vote, or approve budget decisions.

## AI Agent Safety Layer (2026-11-06)

Two new contracts addressing multi-agent behavioral failures:

AgentPermissionsManager:     0xFfe66D73C94C139d3082f99E9Bd3C93A48a3E72F
AIAgentBehaviorMonitorV2:    0xc712eD388BB7848A356121436d6FBFcc2E793a01

Both bound to OperatorPrivilegesV2 at 0x1ec4a1fB4e...EF98.

1. AgentPermissionsManager
   - Hard rate limits per agent (per-tx and per-24h).
   - validateAction() reverts if exceeded.
   - Prevents runaway state changes (arson/theft equivalents).

2. AIAgentBehaviorMonitorV2
   - recordAction() tracks liveness (7-day dormancy threshold).
   - recordViolation() auto-freezes agent after configured strikes.
   - Operators can manually freeze/unfreeze.

Combined with GovernedActionGate (N-of-M approvals) and AIDecisionAudit
(immutable reasoning log), the stack enforces safety at the contract
layer, not the prompt layer.

## Reporting & Naval Registries (2026-11-06)

TakedownReportRegistry: 0x56381C5aFd9Fe799F766a3C3df04B944EB707e85
NavalVesselRegistry:    0xBBfe9Aa9E5EA7bfF348156742AdC05094D66c50F

Both bound to OperatorPrivilegesV2 at 0x1ec4a1fB4e...EF98.

TakedownReportRegistry:
- Two-operator resolution for takedowns
- External filing tracking (registrar/platform/case number)
- 27 tests

NavalVesselRegistry:
- Large ships unlock bedroom, galley, armory, cargo
- Small ships cargo only
- Actions (sleep, cook, craft, deposit) gated by room status
- 8 tests

## Game & Industry Registries (2026-11-06)

WorkerDeploymentRegistry:          0xC9ce1B410F3f606c8bd06d6282Ba5C932f7235Af
PropertyMaintenanceRegistry:       0xAe9eAd1fE35d48458b0D303C571577EcA1CbE5d4
AIContentProvenanceRegistry:       0xA33b60D5cA4d9c36199DBa362D0be8578A4bf824
SecurityIncidentResponseRegistryV2:0xB1C5BA39fDDc1Db645F4212D18E2f07D838c7771
HardwareAllocationRegistry:        0xfBF2bBA3F68cc2b7AD4c524C46E24eA9C2ed547d

All bound to OperatorPrivilegesV2 at 0x1ec4a1fB4e...EF98.

WorkerDeploymentRegistry:
- Prevents NPC vanishing. Unassigned workers remain queryable on-chain.

PropertyMaintenanceRegistry:
- Community dirty-zone reporting. 3 reports flags a property for operator review.

AIContentProvenanceRegistry:
- Tracks AI vs human-made assets. Requires independent operator verification.

SecurityIncidentResponseRegistryV2:
- Incident lifecycle tracking (Reported -> Investigating -> Contained -> Resolved).

HardwareAllocationRegistry:
- Tracks manufacturing vs distribution to prevent hoarding and scalping.

## Dynamic Fleet Compliance (2026-11-07)

DynamicFleetComplianceRegistry: 0x2b1E220bE3B6351CE38F80B04186E917732034bB
Constructor: OperatorPrivilegesV2 = 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98

Source-verified on Etherscan.
Dynamic caps prevent arbitrary fleet limits while ensuring rider compliance.

## Agent Telemetry Registry (2026-11-07)

AgentTelemetryRegistry: 0x361F1C7415c9c7d4c7Ace1403EA5833F78F118a1
Constructor: OperatorPrivilegesV2 = 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98

Source-verified on Etherscan.

Bridges off-chain JavaScript logs (agentPerformance.js) directly to the blockchain.
Every time an AI agent or system persona performs a task, the metrics hash, status, and timestamp are permanently recorded on-chain.

Event confirmed:
Tx: 0xf0359b6cefc7ee9191b1a381c0c0a546aa5d095b8989e74eadaadf28fc88298c
Record ID: 1
Agent: machiavelli-agent
Status: success
