# Public-Matters

**An on-chain governance framework for civic, AI, and institutional systems.**

## Status (2026-09-20)

| Metric | Value |
|---|---|
| Live contracts | 50+ |
| Test suites | 78 |
| Tests passing | 354/354 |
| Deployments | Sepolia (primary) |
| Tags | v1.0.0 → v1.9.0 |
| License | MIT |

## What's Inside

### AI Governance Stack
- `AIAgentRegistry` — agent identity + kill switch
- `AIDecisionAudit` — immutable decision log
- `OperatorPrivileges` — role-based access
- `AIAgentCredentialGuard` — credential attack defense
- `GlobalEmergencyFreeze` — 2-of-N halt
- `AIGovernanceMultisig` — N-of-M approvals
- + 6 more contracts

### Governance Frameworks
- `CabinetDAO`, `PresidentialPolicyDAO`, `GovNexusBridge`
- `CommunityTaxVault`, `CommunityFund`, `TrustIntegratorV2`
- `TransparencyLedger`, `LocalGovernance`, `ResourceCommons`
- + 20 more

### Vaults & Protocols
- `MultiSigEscrowVault`, `HospitalClaimEscrow`, `ScholarshipEscrow`
- `MorrisResilienceProtocol`, `NuclearConflictRegistry`
- `InstitutionalResetRegistry` (pending deploy)
- + 15 more

## Quick Start

    git clone https://github.com/Sexysexy0/Public-Matters
    cd Public-Matters
    forge install
    forge test

## Documentation

- `ARCHITECTURE.md` — system overview
- `docs/ai-governance/` — AI governance docs
- `docs/signals/` — world observations
- `docs/MULTI-CHAIN.md` — deployment status
- `docs/SUCCESS-TRAP-FRAMEWORK.md` — meta-framework
- `research/` — research reports
- `evidence/` — deployment evidence

## Deployment

See `docs/MULTI-CHAIN.md` for current status and pending deployments.

## Testing

    forge test              # 354 tests
    forge test --gas-report # gas analysis
    forge fmt               # format code

## Related Repos

- [ph-reform](https://github.com/Sexysexy0/ph-reform) — national policy framework (14 cases)
- Domain-specific ph-* repos

## License

MIT — see LICENSE file.
