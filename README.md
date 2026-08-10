# Public-Matters Ecosystem

A sovereign, decentralized utility framework consisting of a 30-brick modular governance, sector registries, and public-interest infrastructure. Built with Solidity `0.8.35` and managed using Foundry.

## 🏛️ Ecosystem Architecture
The system isolates logic into specialized operational layers:
- **Core Governance & Sovereignty:** `AnchorGovernanceVault`, `GenesisManifesto`, `PeopleSovereigntyCovenant`
- **Trust & Integrity:** `TrustIndex`, `TrustIntegrator`, `AntiCorruptionWhistleblowerVault`
- **Infrastructure & Monitoring:** `DependencyMonitor`, `PermissionlessBroadcast`, `CCTVTransparencyRegistry`, `InfrastructureProofRegistry`
- **Hardware Integration Layer:** `KnoxBypassProtocol` (Signal-based system control)
- **Public Sector & Proof Modules:** `TransientSupplyPassport` (EIP-1153)
- **Emergency Response & Civic Vaults:** `EmergencyResponderRegistry`, `CommunityFloodVault`
- **Oversight & Research Equity:** `ZKWhistleblowerOversight` (Zero-Knowledge Merkle verification), `DeSciManuscriptEquity`

## 📍 Deployed Contracts (Sepolia Testnet)

All core contracts are live, active, and fully verified on Ethereum Sepolia (Chain ID: `11155111`) using the bleeding-edge Osaka EVM target execution layer:

| Contract Name | Deployed Address | Status |
| :--- | :--- | :---: |
| **`GlobalAssetRegistry`** | `0x68a3693c3Ba7c4d98be7dc7E0aa2471fCe89d933` | Verified |
| **`TrustIndex`** | `0x6A4c9087d91d7C95A596F96a052b8B94E7D9C088` | Verified |
| **`TrustIntegrator`** | `0xc353688b9a9dD36fed5043C0599e44A02B765690` | Verified |
| **`InfrastructureProofRegistry`** | `0xD678e15e59A0102Db9E1dFAC61F040DaE959B313` | Verified |
| **`TransientSupplyPassport`** | `0x75b298A6eacf2FbF52A8fFDCf8FA45141cdAc595` | Verified |
| **`EmergencyResponderRegistry`** | `0x9EA4dc9CC23C7E17c8934F0EB3EF61d310f28B5F` | Verified |
| **`CommunityFloodVault`** | `0xDF8C7Ed42bC124ac022120FE97f28C8436ab4439` | Verified |
| **`ZKWhistleblowerOversight`** | `0x1069957FEdc2Fd99dE67a8E072f8E5AF224bc1A9` | Verified |
| **`DeSciManuscriptEquity`** | `0xDD0722F89702df3a2f75aC3977cAbEDA0c8eDfBA` | Verified |

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
