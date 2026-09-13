# Contract Security Review

## Scope

This review covers the local governance contracts:

- `NuclearEvidenceRegistry`.
- `NuclearConflictRegistry`.
- `NuclearDecisionGates`.
- `NuclearPublicAudit`.

## Authority boundaries

These contracts record evidence, conflicts, gate decisions, and audit references. They do not control physical nuclear equipment, issue statutory licenses, select vendors, move project funds, or override the independent regulator.

## Required review areas

- Ownership and reviewer authorization.
- Conflict-of-interest enforcement.
- Evidence lifecycle and supersession.
- Gate approval thresholds.
- Freeze behavior.
- Cross-contract address immutability.
- Event completeness.
- Duplicate and zero-value input handling.
- Timestamp and expiry assumptions.
- Denial-of-service through unbounded arrays.
- Unexpected external-call behavior.
- Compiler and dependency versions.

## Current status

Local tests pass. Independent security review remains open. No public-network deployment is authorized by this document.

## Findings

Findings must record severity, contract, function, impact, mitigation, verification evidence, owner, and status.
