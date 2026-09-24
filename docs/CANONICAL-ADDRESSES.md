# Canonical On-Chain Addresses

**Last updated:** 2026-09-20
**Deployer (primary):** `0x6bDf6D887038AB97957c2f57d05eDd0eb338589A`
**Multisig (governance):** `0xe696bad9ee41affe5865344b1197c5a18dd7c7f6` (AIGovernanceMultisig)
**Networks:** Sepolia (11155111), Polygon Amoy (80002)
**Total live:** 50 contracts

---

## 🔑 CANONICAL (single source of truth)

### AI Agent Governance
| Contract | Address | Purpose |
|----------|---------|---------|
| **AIAgentRegistry** | `0xfb302dd14e235266a6ededfdd2cdf709c55d7af5` | Agent identity + kill switch |
| **AIDecisionAudit** | `0x9e93a6a3421ad0f8f029406ac3ce3e21e8544074` | Immutable decision log |
| **AIAgentBehaviorMonitor** | `0x7248d1048d3de2bbc657bb640a7adf4ea1448455` | Behavioral drift detection |
| **AIAgentCommunicationGuard** | `0x50ed57a9a787862adb7adb267292585f9906d09d` | Inter-agent comms policy |
| **AIAgentCredentialGuard** | `0x7f817129531d298158f3c155ee2cb0f0566bd9e7` | Credential isolation |
| **AIAgentIncidentRegistry** | `0x779a01ee2b95810e66e51bdfa2737efd3c05ea15` | Incident tracking |
| **AIAgentReputation** | `0x87ffb5d0d1c2143a838e4894670e2fe84417c115` | Reputation scoring |
| **AIAgentResourceCap** | `0x1d45281a3eb9800a5bf4d3093e301a24b3a25731` | Resource limits |
| **AIAgentSandbox** | `0xaf2979deba5b1aa43134762a4923b54d536dd56a` | Isolated execution |
| **AIAgentSunsetProtocol** | `0x4d280dfc9aab2abf0f5e3b467c83296f35ac7b3c` | Graceful shutdown |
| **AIAgentTrainingRecord** | `0x883adc79ccc7293fd132943ded6c31b6e1eb5884` | Training provenance |
| **AIAgentUpgradeTimelock** | `0x960cca9ab0a3d8fd8d15d776a78651eb0971523f` | Controlled upgrades |
| **AIDecisionChallenge** | `0xd92eec115dedba8ce41028a41e1472113d42958e` | Public dispute mechanism |

### Operator & Trust Layer
| Contract | Address | Purpose |
|----------|---------|---------|
| **OperatorPrivileges** (canonical) | `0x25e737b7ead518a84383a24b8653a946c6ea0097` | Operator registry (deployer-owned) |
| **OperatorPrivilegesV2** (governance) | `0x1ec4a1fb4e8d297de39b3995bcbbd8c5e7fcef98` | Operator registry (multisig-owned) |
| **OperatorConsciousnessLedger** | `0x104a96a7dc15fffbf4b26f03c54ad8b055251e79` | Action log |
| **TrustIndex** | `0xe3c25bdb5ca5412e14341364f963b57e29cee7f0` | Trust scores |
| **TrustIntegrator** | `0x0846d5722fae8792cbecce32cf64c5477e195c63` | Trust bridge |
| **TrustScoreDAO** | `0x4a6a14adecafea13a7fdc8863083170c4bff5b60` | Community trust voting |
| **SpeedOfTrust** | `0x94aabe78d927e87caadd07a01b6291f060e99e45` | Trust velocity tracking |

### Governance & Authority
| Contract | Address | Purpose |
|----------|---------|---------|
| **AIGovernanceMultisig** | `0xe696bad9ee41affe5865344b1197c5a18dd7c7f6` | Multi-sig council |
| **FairGovernanceFramework** | `0xfaeebeedc8b739e1db5a0487160c1fb200125187` | Governance core |
| **CitizenVotingDAO** | `0xad98f5bc5e9c44368a2035caeb6a92ad6e9535cc` | Citizen votes |
| **GlobalEmergencyFreeze** | `0x45e667daf3dd59e5da683642ab8901867847666c` | Emergency halt |
| **SovereignOracle** | `0xbd7b77212cdc21e575848cac48b27a048ce939f1` | Truth source |
| **PoliticalEndstate** | `0x9410f6df38c295bd5eab8fdd4404d9009ed24885` | Constitutional target |
| **ContinuityGuard** | `0x69c4b7523917b8fe3c67aabd51dfa5a5da3a7ca1` | Continuity enforcement |
| **ProjectContinuityRegistry** | `0x9b450ffcc0f84eaa901c6eb7532986bd2563c4e8` | Project persistence |

### Public Matters (Flood / Environment)
| Contract | Address | Purpose |
|----------|---------|---------|
| **FloodSolutionArbiter** | `0x4b5167e4d1a342939cb1afaa2d2430917c627126` | Flood dispute resolution |
| **CandabaImpoundingDAO** | `0x647639f24e16872212c49243b3d57425fef1b93a` | Candaba governance |
| **CandabaEcologicalGuardian** | `0xd25c1a9a941233a3b3277b74fec773803adeb3bd` | Ecological protection |
| **DredgingContractorRegistry** | `0x7844018311d102ac2de12e8e732c5427e93a6e49` | Contractor tracking |
| **FarmerCompensationVault** | `0x6d860784e3ca41e09a774173292958d90e917db4` | Farmer payouts |
| **ChildProtectionFund** | `0x49bffe54842dd3bf9c95866e63d59b8926cb8ee3` | Child welfare fund |

### Assets & Identity
| Contract | Address | Purpose |
|----------|---------|---------|
| **GlobalAssetRegistry** | `0x11b4d0fbe666584fed982efd767660c35b37d13e` | Global asset catalog |
| **NexusID** | `0x2af715bb1bfffccab09157bdccc72bd010fe2b46` | Sovereign identity |
| **InvestigatorShield** | `0x469cc1625ccaea148427d5b85b9fe3dca7c6cedc` | Whistleblower protection |
| **InspirationIntimidation** | `0x1f78c8595e3ff93203d2083efc183515923033ee` | Speech integrity |

### Misc / Advisory
| Contract | Address | Purpose |
|----------|---------|---------|
| **BluntAdvice** | `0xb161c551a3ae99086b583fe33c7ac1fb6d1fc4fa` | Direct feedback |
| **BrittleInstrument** | `0xf83c2bd30499c835324ee56a72d135bce7615d45` | Instrumentation |
| **CommandFeedback** | `0x689ff6b8e8357910860cdcdc98923d856ae0e4e8` | Command feedback |
| **DiplomaticNuance** | `0x0cf71ee75f58170b7e6a6313974f896559e3eba3` | Diplomatic registry |
| **HistoryLightedPath** | `0xe09199b37ac0823f69a7f8f9d0a7023cf7c7c003` | Decision history |
| **SymbolismFilter** | `0xf1f2fdfa422a262b79ec07eb939c24fde3ca4fb2` | Symbol flagging |
| **ArcadeGovernance** | `0xadc41d0eb3c886f656b1db28a240e91a319bbfaf` | Game governance |

---

## ⚠️ DEPRECATED (old versions — do not use for new integrations)

| Contract | Address | Superseded By |
|----------|---------|---------------|
| OperatorPrivileges | `0x6cf551ec6b5052ed535d3549af2dd4c2c3da7a65` | `0x25e737...` or `0x1ec4...` |
| OperatorPrivileges | `0x9b9c35bdfcc69478669b640c9e7d106dcf612dce` | `0x25e737...` or `0x1ec4...` |
| CoalitionBuilder | `0x280968b6465010879f2f75ad3ebaaba1dcb2f731` | `0x7433a170...` |
| AIAgentRegistryV2 | `0xb4f4d1828b60b94bf5ae6d3e1f492b79b5cc9ad9` | `0xfb302dd1...` (canonical) |

---

## ❌ DEAD (no code on-chain — needs redeploy)

| Contract | Attempted Address | Status |
|----------|-------------------|--------|
| InstitutionalResetRegistry | `0xb41444ad384ebf3fc7612043fa3187e11f9b0c00` | ❌ No code |

---

## 📋 OWNERSHIP MAP

| Owner | Contracts Owned |
|-------|-----------------|
| `0x6bDf6D887038AB97957c2f57d05eDd0eb338589A` (deployer) | OperatorPrivileges v1, v1.5, v1.7 (3 versions) |
| `0xe696bad9ee41affe5865344b1197c5a18dd7c7f6` (multisig) | OperatorPrivilegesV2 |

**Governance evolution:** v1 → single key → v2 → **multisig council** ✅

---

## 🔗 EXPLORERS

- Sepolia: https://sepolia.etherscan.io
- Amoy: https://amoy.polygonscan.com

---

*Generated from on-chain verification sweep 2026-09-20.*
*50 live contracts. 4 deprecated. 1 dead.*

---

## 🧪 LOCAL (Anvil, chain 31337) — DEVELOPMENT ONLY

| Contract | Address | Notes |
|----------|---------|-------|
| **InstitutionalResetRegistry** | `0x5039f21a1D0F6465f33002F40F420A863d24Ad7c` | Local dev — on-chain redeploy pending faucet |

**Testnet deploy pending:**
- Sepolia: short 0.0026 ETH
- Amoy: short 0.125 POL

Faucets:
- https://faucet.polygon.technology/
- https://sepoliafaucet.com/

---

## EIP-7702 DELEGATION LAYER

**Wallet:** `0x6bDf6D887038AB97957c2f57d05eDd0eb338589A`
**Delegator:** `0x63c0c19a282a1B52b07dD5a65b58948A07DAE32B`
**Name:** EIP7702StatelessDeleGator
**Version:** 1.3.0
**Standard:** EIP-7702 (EOA-to-smart-account)
**Framework:** MetaMask Delegation Framework

### Network Components
| Component | Address | Standard |
|-----------|---------|----------|
| EntryPoint | `0x0000000071727De22E5E9d8BAf0edAc6f37da032` | ERC-4337 v0.7 |
| DelegationManager | `0xdb9B1e94B5b69Df7e401DDbedE43491141047dB3` | MetaMask Delegation Framework |

### Capabilities
- `enableDelegation` - authorize delegates with caveats
- `disableDelegation` - revoke authorization
- `redeemDelegations` - execute batched calls under constraints
- `isDelegationDisabled` - check status

### Caveat Enforcers (policy primitives)
- Time bounds (onlyActiveUntil)
- Function allowlists (allowedMethods)
- Value caps (valueLte)
- Balance requirements (erc20BalanceGte)
- Multi-sig thresholds

### Governance Stack (top to bottom)

```
[0] Wallet          0x6bDf6D887038AB97957c2f57d05eDd0eb338589A
[1] Delegator       0x63c0c19a282a1B52b07dD5a65b58948A07DAE32B
[2] OperatorPriv    0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98
[3] Multisig        0xe696bad9ee41affe5865344b1197c5a18dd7c7f6
[4] AI Stack        50 contracts (see sections above)
[5] Legal           research/entity-setup-roadmap.md
```

### Security Properties
- Single-key compromise cannot bypass caveats + multisig
- Every delegation revocable, inspectable, immutable on-chain
- Batched execution possible via EntryPoint
- ERC-4337 compatible with paymasters for gas abstraction

### Defense Modules (Sepolia Verified 2026-09-24)
| Contract            | Address                                      | Purpose                  |
|---------------------|----------------------------------------------|--------------------------|
| InvestigatorShield  | 0x9F0C85e7Fa1442ACCb96243e4DaA51e045F3b170   | Whistleblower protection |
| ContinuityGuard     | 0x69C4B7523917B8Fe3c67aabd51dfA5a5DA3a7cA1   | Continuity enforcement   |
| AIDecisionChallenge | 0x34d130B174F4a30A846FED7C02FCF53A19a4c2B6   | Public dispute mechanism |

### Governance Core (Sepolia Verified 2026-09-24)
| Contract               | Address                                      | Purpose                |
|------------------------|----------------------------------------------|------------------------|
| PublicMattersCovenant  | 0xDAa47BE34e1f76353E4198Cf106E36bd8895832e   | Covenant principles    |
| GovernanceBundle       | 0x610970c1280cE9380f75Be5aD599F768fDEcB6c5   | Governance suite       |
| ProjectContinuityReg.  | 0x1b8094a487dc98e6cd936445a57f41d2c120372e   | Project persistence    |
| GlobalAssetRegistry    | 0x29f4d4e36412c374d3fF9aba2c8Ff72C32A29C0c   | Global asset catalog   |
| OperatorPrivileges     | 0x3F2ac68b192041fc82593dF6d9ebDB07c08063FE   | Operator registry      |
