# Static Analysis Record

## Scope

Local nuclear governance contracts, deployment script, and tests:

- src/NuclearEvidenceRegistry.sol
- src/NuclearConflictRegistry.sol
- src/NuclearDecisionGates.sol
- src/NuclearPublicAudit.sol
- script/NuclearGovernanceLocalDeploy.s.sol
- test/nuclear/*

## Verification results

### Formatting

Command: forge fmt --check

Result: passed

forge fmt normalized formatting across the source, deployment script, and nuclear tests. The reviewed source diff contains formatting-only changes.

### Tests

Command: forge test

Result: 56 test suites; 164 tests passed; 0 failed; 0 skipped.

### Diff integrity

Commands: git diff --check; git diff --word-diff=plain -- src script

Result: passed

The reviewed changes are formatter-only; no Solidity behavior changes were identified in the inspected diff.

## Slither result

Slither was not installed in the local environment on 2026-09-14. No Slither analysis was performed, and no security conclusion is drawn from its absence.

## Limitations

Passing tests and formatter checks do not constitute an independent security review. No public-network deployment, physical-equipment control, or statutory licensing decision is authorized by this record.

## Status

Open pending independent security review.
