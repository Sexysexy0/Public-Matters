# Multi-Chain Deployment Status

**Last updated:** 2026-09-20

## Current State

| Chain | Chain ID | Contracts | Status |
|---|---|---|---|
| **Ethereum Sepolia** | 11155111 | 50+ | ✅ Active |
| Polygon Amoy | 80002 | 1 | ✅ Active |
| Base Sepolia | 84532 | 0 | ⏳ Pending |
| OP Sepolia | 11155420 | 0 | ⏳ Pending |
| Arbitrum Sepolia | 421614 | 0 | ⏳ Pending |
| ZKsync Sepolia | 300 | 0 | ⏳ Pending |
| Linea Sepolia | 59141 | 0 | ⏳ Pending |

## Primary Chain: Ethereum Sepolia

All 50+ contracts are deployed on Ethereum Sepolia:
- AI Governance stack (12 contracts)
- Governance frameworks (20+ contracts)
- Vaults, registries, protocols (18+ contracts)

See `research/contract-audit-YYYYMMDD.md` for full list.

## Pending Deployment: InstitutionalResetRegistry

**Contract:** `src/InstitutionalResetRegistry.sol`
**Tests:** 10/10 passing
**Purpose:** Success trap tracking (CASE-014)

**Attempts (all failed):**
1. Sepolia — insufficient funds (0.004 ETH)
2. Polygon Amoy — gas tip too low (1 wei < 25 gwei min)
3. Polygon Amoy — gas tip too high (50 gwei > 127 wei max)
4. Polygon Amoy — `--gas-price` flag ignored by Foundry build

**Root cause:** Foundry `--legacy --gas-price` not respected in current build.

**Next:** Try `cast send` direct deploy, or fix Foundry version.

## Why Multi-Chain

1. **Cost reduction** — L2s 10-20x cheaper
2. **Speed** — L2s confirm in 1-2s vs 12s on L1
3. **Redundancy** — if one chain has issues, others work
4. **Reach** — different users prefer different chains

## Deployment Pattern

    Local test (forge test)
        |
        v
    Sepolia (primary — public proof)
        |
        v
    Polygon Amoy / Base / OP (secondary)

## Faucets

- Ethereum Sepolia: https://cloud.google.com/application/web3/faucet
- Polygon Amoy: https://faucet.polygon.technology/
- Base Sepolia: https://www.alchemy.com/faucets/base-sepolia
- OP Sepolia: https://console.optimism.io/faucet

## Notes

Deployment is validation only. Contract value is in source code + tests.
All contracts available at: https://github.com/Sexysexy0/Public-Matters
