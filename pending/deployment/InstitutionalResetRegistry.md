# InstitutionalResetRegistry — Deployment Pending

## Status
- Created: 2026-09-20
- Contract: `src/InstitutionalResetRegistry.sol`
- Tests: 10/10 passing
- Deployment attempts: 4 FAILED
- Result: NOT DEPLOYED

## Attempts Log
1. Ethereum Sepolia — insufficient funds (0.004 vs 0.007)
2. Polygon Amoy — gas tip too low (1 wei vs 25 gwei min)
3. Polygon Amoy — gas tip too high (50 gwei > 127 wei max)
4. Polygon Amoy — flag `--gas-price 30gwei` ignored, still 107 gwei

## Root Cause
Foundry version `--legacy --gas-price` flag is not being respected
in this build. RPC overrides with its own gas estimate.

## Current Balances
- Ethereum Sepolia: 0.004056 ETH (insufficient)
- Polygon Amoy: 0.104808 POL (sufficient, but gas flag issue)
- Base/OP/Arb/ZKsync/Linea: 0 ETH

## Predicted Addresses (NOT deployed)
- Sepolia: 0xB41444AD384EBF3fc7612043fA3187E11f9B0C00
- Polygon Amoy: 0xE8E0e4F795A1A285395F6F8d5EA80adEf8c076F1

## What Works
- Contract source code: ✅ complete
- Tests: ✅ 10/10 passing
- Local build: ✅ compiles
- Repo commit: ✅ in git history

## Next Steps
1. Refill Sepolia ETH (needs 0.007+)
2. OR fix Foundry gas flag issue
3. OR deploy on mainnet when ready
4. Contract is production-ready — deployment is only validation

## Lesson
Test-first workflow caught the issue: verify BEFORE committing evidence.
The contract itself is not affected by deployment failure.
