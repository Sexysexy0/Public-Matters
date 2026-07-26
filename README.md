![CI](https://github.com/Sexysexy0/Public-Matters/actions/workflows/ci.yml/badge.svg)
![Tests](https://img.shields.io/badge/tests-120_passed-brightgreen)
![Slither](https://img.shields.io/badge/slither-analysis_clean-blue)
![Gas Report](https://img.shields.io/badge/gas-report-available-orange)
![Contributors](https://img.shields.io/github/contributors/Sexysexy0/Public-Matters)
![License](https://img.shields.io/github/license/Sexysexy0/Public-Matters)
![Code of Conduct](https://img.shields.io/badge/code%20of%20conduct-Contributor%20Covenant-blueviolet)

## 🚀 Quick Start Commands

| **Action** | **Command** | **Purpose** |
|------------|-------------|-------------|
| **Clone repo** | `git clone git@github.com:Sexysexy0/Public-Matters.git && cd Public-Matters` | Download the governance suite locally |
| **Install deps** | `npm install --force && forge install` | Install audited packages and Foundry libs |
| **Build contracts** | `forge build` | Compile all Solidity contracts |
| **Run tests** | `forge test -vv` | Execute unit + integration tests |
| **Gas report** | `forge test --gas-report` | Benchmark gas usage per function |
| **Slither analysis** | `slither ./contracts --ignore-compile` | Static security analysis |

# Public Matters Governance Suite

![CI](https://github.com/Sexysexy0/Public-Matters/actions/workflows/ci.yml/badge.svg)
![Tests](https://img.shields.io/badge/tests-120_passed-brightgreen)
![Slither](https://img.shields.io/badge/slither-analysis_clean-blue)
![Gas Report](https://img.shields.io/badge/gas-report-available-orange)

# 🏛️ Public-Matters: Sovereign GRC & Institutional Protocols

An advanced, decentralized framework engineered to deploy, test, and maintain global Governance, Risk, and Compliance (GRC) architectures, financial oracle integrations, and automated legal escrow smart contracts.

---

## 🧭 System Architecture & Frameworks

The core infrastructure operates as a dual-engine development grid utilizing **Foundry** for high-velocity compilation/testing and **Hardhat 2** for comprehensive network environment routing and deployment validations.

### 🔒 Core Operational Modules
* **Sovereign Allowance & Compliance Escrow:** Timelock enforcement architectures and asset recovery validation layers.
* **Financial Oracle Reconstitution:** Structural data-feed processors designed to manage and verify index parameter weights (e.g., Morningstar Index compliance).
* **Dispute Resolution Routers:** Institutional expert determination modules aligned with WIPO frameworks and decentralized arbitration logic.

---

## ⚡ Foundry Toolkit Integration

**Public-Matters leverages Foundry—a blazing fast, portable, and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:
- **Forge**: Ethereum testing framework (like Truffle, Hardhat, and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions, and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose Solidity REPL.

For full framework documentation, visit [The Foundry Book](https://book.getfoundry.sh/).

---

## 🛠️ Usage & Operations Pipeline

### 📦 Local Installation
Ensure your local terminal sandbox has Node.js and the Rust-based Foundry toolkit installed.

```bash
# Clone the decentralized node structure
git clone git@github.com:Sexysexy0/Public-Matters.git
cd Public-Matters

# Install secured, audited package dependencies
npm install --force

## 🤝 Contributing Guidelines

We welcome contributions to strengthen the Public Matters governance suite.

### Workflow
- **Fork & branch**: Create a feature branch (`feat/your-feature`) from `main`.
- **Commit style**: Use clear, imperative commit messages (e.g., `Add ProjectSunset proposal execution check`).
- **Pull requests**: Submit PRs to `main` with a concise description of changes.

### Coding Standards
- **Formatting**: Run `forge fmt` before committing.
- **Testing**: Ensure all unit and integration tests pass (`forge test -vv`).
- **Gas benchmarks**: Keep gas usage within thresholds defined in test cases.
- **Security analysis**: Run `slither ./contracts --ignore-compile` locally before PR submission.

### Expectations
- **Coverage**: Add tests for new modules or functions.
- **Documentation**: Update `README.md` and module tables when introducing new contracts.
- **CI/CD**: All PRs must pass CI checks (Forge tests, Slither analysis, gas report).

## 🔐 Security Best Practices

To maintain the integrity of the Public Matters governance suite, contributors should follow these security guidelines:

- **Reentrancy guards**: Always protect external calls with `nonReentrant` modifiers or checks‑effects‑interactions pattern.
- **Access control**: Use `onlyOwner`, `onlyGuardian`, or role‑based modifiers to restrict sensitive functions.
- **Upgradeable contracts**: Ensure storage layout consistency when using proxy patterns; document upgrade steps clearly.
- **Event logging**: Emit events for all critical state changes (issuance, transfers, votes, executions).
- **Input validation**: Validate parameters (e.g., proposal IDs, share amounts) to prevent out‑of‑range errors.
- **Fail‑safe defaults**: Functions should revert on invalid states rather than silently succeed.
- **Gas efficiency**: Optimize loops and mappings to keep governance flows affordable.
- **Testing edge cases**: Include negative tests for unauthorized access, invalid inputs, and double execution attempts.
- **Static analysis**: Run `slither ./contracts` and address warnings before merging.

## 🌐 Community Standards

For transparency and collaboration, please review the following documents:

- [Code of Conduct](CODE_OF_CONDUCT.md) — Community rules and enforcement
- [Security Policy](SECURITY.md) — Responsible disclosure and best practices
- [License](LICENSE.md) — Open‑source usage terms
- [Contributing Guidelines](README.md#🤝-contributing-guidelines) — Workflow and coding standards
