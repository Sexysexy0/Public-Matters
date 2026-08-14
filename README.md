# Public-Matters Ecosystem

A sovereign, decentralized utility framework consisting of a 30-brick modular governance, sector registries, and public-interest infrastructure. Built with Solidity `0.8.35` and managed using Foundry.

## 🏛️ Ecosystem Architecture
The system isolates logic into specialized operational layers:
- Core Governance & Sovereignty: AnchorGovernanceVault, GenesisManifesto, PeopleSovereigntyCovenant
- Trust & Integrity: TrustIndex, TrustIntegrator, AntiCorruptionWhistleblowerVault
- Infrastructure & Monitoring: DependencyMonitor, PermissionlessBroadcast, CCTVTransparencyRegistry, InfrastructureProofRegistry
- Hardware Integration Layer: KnoxBypassProtocol (Signal-based system control)
- Public Sector & Proof Modules: TransientSupplyPassport (EIP-1153)
- Emergency Response & Civic Vaults: EmergencyResponderRegistry, CommunityFloodVault
- Oversight & Research Equity: ZKWhistleblowerOversight (Zero-Knowledge Merkle verification), DeSciManuscriptEquity

## 📍 Deployed Contracts (Sepolia Testnet)

All core contracts are live, active, and fully verified on Ethereum Sepolia (Chain ID: `11155111`) using the bleeding-edge Osaka EVM target execution layer:

| Contract Name | Deployed Address | Status |
| :--- | :--- | :---: |
| GlobalAssetRegistry | 0x68a3693c3Ba7c4d98be7dc7E0aa2471fCe89d933 | Verified |
| TrustIndex | 0x6A4c9087d91d7C95A596F96a052b8B94E7D9C088 | Verified |
| TrustIntegrator | 0xc353688b9a9dD36fed5043C0599e44A02B765690 | Verified |
| InfrastructureProofRegistry | 0xD678e15e59A0102Db9E1dFAC61F040DaE959B313 | Verified |
| TransientSupplyPassport | 0x75b298A6eacf2FbF52A8fFDCf8FA45141cdAc595 | Verified |
| EmergencyResponderRegistry | 0x9EA4dc9CC23C7E17c8934F0EB3EF61d310f28B5F | Verified |
| CommunityFloodVault | 0xDF8C7Ed42bC124ac022120FE97f28C8436ab4439 | Verified |
| ZKWhistleblowerOversight | 0x1069957FEdc2Fd99dE67a8E072f8E5AF224bc1A9 | Verified |
| DeSciManuscriptEquity | 0xDD0722F89702df3a2f75aC3977cAbEDA0c8eDfBA | Verified |
| VerificationCodex | 0x73CEb342B2729f43cD41D02c64395030502BCeA4 | Verified |
| AccountabilityArc | 0x1dBF326AF727A0aD3F7c1B0E2d062bF84C250717 | Verified |
| EvidenceRegistry | 0xa9A3BB7c891E88293a5ba83d024FF058d2631945 | Verified |
| SkepticismProtocol | 0x5e41A2fE650c098bf69ccF945EE38a09c3aEB235 | Pending |
| TransparencyLedger | 0xdb9cF8708eE2d2c604EAd84F90d910d4a660765A | Pending |
| IntellectualDiversity | 0xE7008f37c066726B644091B9FE3C4013528DA493 | Pending |
| MarketAccountability | 0x0e1582D384649a4592bF80D796D6A397c34796c5 | Pending |
| FundamentalEducation | 0x60c0B3C53eBB54630f62Bca880dAba8C25a2a5B6 | Pending |
| ResearchDecentralization | 0x82431253B44d2c96F20E6eE3E4AB1B3f8782C7D4 | Pending |
| FairGovernanceFramework | 0x44717152838ba186Ba96E4d53dF8f0495099A078 | Verified |


## 🛠️ Development & Testing

### Prerequisites
Ensure you have the Foundry toolchain installed.
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Compile & Test
Run the full unit test suite locally inside the EVM sandbox:
```bash
forge clean && forge build
forge test
```

### Local Simulation
To dry-run the 30-brick deployment sequence:
```bash
forge script script/DeployKingdom.s.sol
```

### Live Deployment Execution
To deploy to Sepolia testnet using sequential pacing without hitting RPC limits:
```bash
forge script script/DeployMasterArchitecture.s.sol:DeployMasterArchitecture \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com \
  --broadcast \
  --slow
```

## 📄 License
This ecosystem is open-source software provided under the terms of the Apache License 2.0.
### Newly Deployed Contracts (Aug 2026)
| Contract Name             | Deployed Address                                 | Status   |
|---------------------------|--------------------------------------------------|----------|
| TransparencyMandateRegistry | 0x3c056E19E423DE5346c79b7898A666E9Fd3475f1     | Verified |
| GovernanceBundle          | 0x8e3408344422ccb8131A1E796D5d66AaBb14981f       | Verified |
| PublicMattersCovenant     | 0x0f3Ef8a85D4E98B4a134a43141380A236305Ecd5       | Verified |

### Safeguards Contracts (Aug 2026)
| Contract Name        | Deployed Address                                 | Status   |
|----------------------|--------------------------------------------------|----------|
| VerificationCodex    | 0xd551526453b8F548D60eC59f4f3E764C42955DA5       | Verified |
| AccountabilityArc    | 0xB0DEa9cB49D96653Fd3dA6587986DD45Ef3fdB4c       | Verified |
| EvidenceRegistry     | 0x0EDA94D0B80D35040bDA1E0d270bb52CFc8667A3       | Verified |
| SkepticismProtocol   | 0x127Fdecfdc219Bb4AF65971AB81b50d83F107905       | Verified |
| TransparencyLedger   | 0xaD05Fb913062B22B1aFB51ac949F3fC3851C6329       | Verified |

### Covenant Governance Context
- PublicMattersCovenant Address: 0x0f3Ef8a85D4E98B4a134a43141380A236305Ecd5
- Supreme Steward: 0x6bDf6D887038AB97957c2f57d05eDd0eb338589A
- Jurisdictions encoded: Philippines, Singapore, Hong Kong SAR, Bermuda, United States, Global

### Reforms Contracts (Aug 2026)
| Contract Name             | Deployed Address                                 | Status   |
|---------------------------|--------------------------------------------------|----------|
| FundamentalEducation      | 0xd551526453b8F548D60eC59f4f3E764C42955DA5       | Verified |
| IntellectualDiversity     | 0xB0DEa9cB49D96653Fd3dA6587986DD45Ef3fdB4c       | Verified |
| MarketAccountability      | 0x0EDA94D0B80D35040bDA1E0d270bb52CFc8667A3       | Verified |
| ResearchDecentralization  | 0x127Fdecfdc219Bb4AF65971AB81b50d83F107905       | Verified |

### Neuroscience Contracts (Aug 2026) - For Scientific Research Integrity
| Contract Name             | Deployed Address                                 | Status   |
|---------------------------|--------------------------------------------------|----------|
| StudyDesignRegistry       | 0x651D8B3a79a1A83d7296971633e755Cd1F6efD52       | Verified |
| DataIntegrityLedger       | 0x939e23bBa929aa3e7C35dc93a1eba6E9E667C7bB       | Verified |
| AnalysisCodex             | 0xb6F00bfa8A9657328d60AfB9902c76884D047dc9       | Verified |
| ReputationToken           | 0x053C9aB669966A05fa3D29936b7b359057e071Bb       | Verified |
| PeerReviewOracle          | 0x25cF6318fCB1fEAfde827A2E4E7d22F8f08Ecd8e       | Verified |

### Prediction Market Contracts (Aug 2026) — Ethical & Transparent Markets
| Contract Name             | Deployed Address                                 | Status   |
|---------------------------|--------------------------------------------------|----------|
| MarketParticipantRegistry | 0xe180930C3d0062AF3216D873E44C68275CD969fd       | Verified |
| KnowledgeOracle           | 0x7acf092b39C0f858a794c601e057a2c416f8db98       | Verified |
| FairLiquidityPool         | 0x3A483a73991692d56BCd5E1A6DBF847Ae56B1D33       | Verified |
| MarketAuditLedger         | 0xd01595caB829527Dd33B480Da9Ea7597451d94F0       | Verified |
| RegulatoryCompliance      | 0xEc6aAC5eBb5082AD77BC57E0c9ce4ACbC1e1846b       | Verified |

### Community Sovereignty Contracts (Aug 2026) — Data Center Accountability
| Contract Name             | Deployed Address                                 | Status   |
|---------------------------|--------------------------------------------------|----------|
| PermitRegistry            | 0xCeb469C848e280F3472f737B501E77021cB2B1db       | Verified |
| ResourceStewardshipEscrow | 0xf97617401790bfbB975fca1968B526b5D1a7Ca6D       | Verified |
| LocalRevenueGuard         | 0x88932Afc3DB48B20e5A11d28C8EC89E7a887DF8C       | Verified |
| LocalHireConditional      | 0x3E0aFd48696d0b664Bbc8f00d2Fe13aa9578Df3c       | Verified |
| CommunityDAO              | 0x00Dd17280FD2cA7B51A938D77533702aC08637bc       | Verified |

## 🧩 Horizontal Progression (Evergreen Architecture)

Ang `Public-Matters` ecosystem ay idinisenyo bilang isang **"evergreen"** system—hindi ito nagre-reset, hindi ito "seasonal."

### Key Principles
- **Permanent Data:** Lahat ng contracts, commits, at transactions ay naka-store permanently sa blockchain at GitHub.
- **Layered Building:** Ang mga bagong features ay binuo sa ibabaw ng existing infrastructure—hindi pinapalitan.
- **No "Seasonal" Resets:** Walang "wipe" o "restart"—ang system ay patuloy na lumalaki.

### Examples
- `SovereignRegistry.sol` — permanenteng registry ng lahat ng contracts at entities.
- `TrustIntegrator.sol` — permanenteng trust scores na hindi na-reset.
- `CommunityDAO.sol` — permanenteng voting history ng mga proposals.
