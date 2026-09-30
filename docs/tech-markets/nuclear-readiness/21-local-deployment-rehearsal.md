# Local Deployment Rehearsal

## Scope

Deploy the four governance contracts only to a local Foundry test environment.

## Required sequence

1. Deploy `NuclearEvidenceRegistry`.
2. Deploy `NuclearConflictRegistry`.
3. Deploy `NuclearDecisionGates` with both registry addresses.
4. Deploy `NuclearPublicAudit`.
5. Authorize reviewers and auditors.
6. Register and accept evidence.
7. Create a gate and attach accepted evidence.
8. Declare an active conflict and verify approval is blocked.
9. Revoke or expire the conflict and verify approval succeeds.
10. Record the decision in the public audit registry.
11. Freeze selected records.
12. Verify no external network or real-world system is contacted.

## Exit condition

The rehearsal passes only when the full integration test and full Forge suite pass.
