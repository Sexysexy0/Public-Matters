# Public-Matters Ecosystem

A sovereign, decentralized utility framework consisting of a 30-brick modular governance and public-interest infrastructure. Built with Solidity and managed using Foundry.

## 🪐 Ecosystem Architecture
The system isolates logic into specialized operational layers:
- **Core Governance & Sovereignty:** `AnchorGovernanceVault`, `GenesisManifesto`, `PeopleSovereigntyCovenant`
- **Trust & Integrity:** `TrustIndex`, `TrustIntegrator`, `AntiCorruptionWhistleblowerVault`
- **Infrastructure & Monitoring:** `DependencyMonitor`, `PermissionlessBroadcast`, `CCTVTransparencyRegistry`
- **Hardware Integration Layer:** `KnoxBypassProtocol` (Signal-based system control)

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

## 🚀 Live Deployment
To deploy to the Sepolia testnet without hitting RPC transaction throughput limits, always pass the sequential pacing flag:
```bash
forge script script/DeployKingdom.s.sol --rpc-url \$SEPOLIA_RPC_URL --broadcast --slow
```

## 📄 License
This ecosystem is open-source software provided under the terms of the Apache License 2.0.
