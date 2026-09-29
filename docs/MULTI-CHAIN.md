# Multi-Chain Testnet Deployment Status

**Last updated:** 2026-09-20

## Repository-Recorded Testnet State

| Chain | Chain ID | Contracts | Status |
|---|---|---|---|
| **Ethereum Sepolia** | 11155111 | 50+ | Public testnet evidence recorded |
| Polygon Amoy | 80002 | 1 | Public testnet evidence recorded |
| Base Sepolia | 84532 | 0 | ⏳ Pending |
| OP Sepolia | 11155420 | 0 | ⏳ Pending |
| Arbitrum Sepolia | 421614 | 0 | ⏳ Pending |
| ZKsync Sepolia | 300 | 0 | ⏳ Pending |
| Linea Sepolia | 59141 | 0 | ⏳ Pending |

## Primary Public Testnet: Ethereum Sepolia

Repository records identify 50+ contract deployments on Ethereum Sepolia:
- AI Governance stack (12 contracts)
- Governance frameworks (20+ contracts)
- Vaults, registries, protocols (18+ contracts)

See `research/contract-audit-YYYYMMDD.md` for full list.

## InstitutionalResetRegistry: Evidence Reconciliation Required

**Contract:** `src/InstitutionalResetRegistry.sol`
**Tests:** 10/10 passing
**Purpose:** Success trap tracking (CASE-014)

**Historical Sepolia/Amoy records require reconciliation. Documented attempts include:**
1. Sepolia — insufficient funds (0.004 ETH)
2. Polygon Amoy — gas tip too low (1 wei < 25 gwei min)
3. Polygon Amoy — gas tip too high (50 gwei > 127 wei max)
4. Polygon Amoy — `--gas-price` flag ignored by Foundry build

**Root cause:** Foundry `--legacy --gas-price` not respected in current build.

**Current public status:** Evidence reconciliation required. Do not treat this artifact as a production deployment, an institutionally operative system, or a canonical active record without reconciled evidence.

## Testnet Evaluation Rationale

1. **Cost reduction** — L2s 10-20x cheaper
2. **Speed** — L2s confirm in 1-2s vs 12s on L1
3. **Redundancy** — if one chain has issues, others work
4. **Reach** — different users prefer different chains

## Testnet Validation Pattern

    Local test (forge test)
        |
        v
    Sepolia (primary public testnet)
        |
        v
    Polygon Amoy / Base / OP (secondary)

## Faucets

- Ethereum Sepolia: https://cloud.google.com/application/web3/faucet
- Polygon Amoy: https://faucet.polygon.technology/
- Base Sepolia: https://www.alchemy.com/faucets/base-sepolia
- OP Sepolia: https://console.optimism.io/faucet

## Notes

Deployment records are validation evidence only. Public testnet activity does
not by itself establish production operation, legal authority, institutional
adoption, custody, financial authority, or control of third-party systems.
Contract value and review begin with source code, tests, and evidence quality.
All contracts available at: https://github.com/Sexysexy0/Public-Matters
