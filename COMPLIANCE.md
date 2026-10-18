# Compliance References - Public-Matters Implementation

This organization aligns with the following standards:

- ISO/IEC 27001:2022 — Information Security Management System
- ISO/IEC 42001:2023 — Artificial Intelligence Management System
- SOC 3 — Trust Services Criteria for Security
- CSA STAR — Cloud Security Alliance Registry

## Certificates
- Certificate numbers and validity are documented in the compliance archive.
- All repositories must adhere to the controls defined in the Cloud Controls Matrix (CCM v4.1).

## ISO/IEC 27001:2022 Mapping
- A.9.2.3 Management of privileged access -> OperatorPrivilegesV2 (0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98)
- A.9.4.3 Secret management -> PrivacyGuard.sol + AIAgentCredentialGuardV2
- A.12.4 Logging & monitoring -> AIDecisionAudit.sol + agent-performance.log

## ISO/IEC 42001:2023 Mapping
- AI Agent Governance -> AIAgentRegistry.sol + AIGovernanceMultisig (0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6)
- AI Decision Audit -> AIDecisionAudit.sol (permanent on-chain trail)
- AI Action Control -> GovernedActionGate.sol (N-of-M council approval)

## SOC 3 Trust Criteria
- Security: Security Guardrails (.github/workflows/security.yml)
- Availability: Multi-chain RPC (Alchemy + Infura fallback - Sepolia, Base, OP, Arbitrum, Polygon, ZK, Linea)
- Confidentiality: PrivacyGuard.sol + AlignmentGuard.sol + TimelockBuffer.sol

## CSA STAR / CCM v4.1
- Cloud Controls: Multi-chain deployment (ETH, Base, OP, Arbitrum, Polygon, ZKsync, Linea)
- Evidence: All stage transitions recorded on-chain via BudgetAuditIntegrator v4

## Evidence (Sepolia Testnet)
- Commit: 7a29460ee33c1c9e3e3c15254ba13623e654d55e (HEAD -> main)
- Author: Emervin V. Gueco <gemervin14@gmail.com> - Proponent
- Integrator: BudgetAuditIntegrator v4 (0x6075F5E8...) now holds operator status on OperatorPrivilegesV2 (0x1ec4a1fB4e...EF98)
- Governance: Executed through AIGovernanceMultisig proposal id 2 with 2-of-3 signer approval (Solo Founder Multisig Pattern - pure ikaw lang din yan 😆)
- Audit: AIDecisionAudit trail for the budget registry is now fully wired: every stage transition recorded on-chain, permanent, queryable
- Constraint: Integrator holds operator status only for the audit hookup. It cannot propose, vote, or approve budget decisions (Principle of Least Privilege)

## Institutional Resilience
- OperatorConsciousnessLedger, AccountabilityArc, TransparencyLedger, BudgetDeliberationRegistry
- Security Guardrails: security.yml workflow active
- Capacity Building: Self-sovereign enterprise infrastructure

## Notes
- This is a solo-founder enterprise implementation (Vinvin) with 2-of-3 multisig for future institutional co-signers (Trump/Marcos executive model ready)
- All repositories must adhere to CCM v4.1
