# InstitutionalResetRegistry — Deployment Pending

## Status
- Created: 2026-09-20
- Deployment attempts: 3 (FAILED)
- Result: NOT DEPLOYED

## Attempt History
1. Ethereum Sepolia — FAILED (insufficient funds, have 0.004 ETH, need 0.007)
2. Polygon Amoy — FAILED (gas tip too low: 1 wei vs 25 gwei minimum)
3. Polygon Amoy — FAILED (gas tip too high: 50 gwei > maxFee 127 wei)

## Current Balances
- Ethereum Sepolia: 0.004056 ETH (insufficient)
- Polygon Amoy: 0.1048 POL (sufficient, but gas settings wrong)
- Base/OP/Arb/ZKsync/Linea: 0 ETH

## Predicted Addresses (NOT deployed)
- Sepolia: 0xB41444AD384EBF3fc7612043fA3187E11f9B0C00
- Polygon Amoy: 0xE8E0e4F795A1A285395F6F8d5EA80adEf8c076F1

NOTE: These are forge-simulated addresses. No bytecode exists.

## Polygon Amoy Gas Issue
- Base fee: ~127 wei (extremely low)
- Our tip attempts: 1 wei (too low), 50 gwei (too high)
- Need to match base fee + reasonable tip

## Next Steps
1. Use correct gas flags for Polygon Amoy
2. Test in dry-run first
3. Verify BEFORE committing evidence
4. Update evidence only after actual deployment confirmed
