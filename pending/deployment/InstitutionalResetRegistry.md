# InstitutionalResetRegistry — Deployment Pending

## Status
- Created: 2026-09-20
- Deployment attempted: 2026-09-20
- Result: FAILED — insufficient funds

## Error
insufficient funds for gas * price + value
have 4056211708302930 want 6067603633277136

## Requirements
- Balance needed: ~0.007 ETH (with buffer)
- Current balance at attempt: ~0.004 ETH
- Deficit: ~0.003 ETH

## Refill Sources
- Google Cloud Web3: https://cloud.google.com/application/web3/faucet
- Alchemy Sepolia: https://www.alchemy.com/faucets/ethereum-sepolia
- PoW Faucet: https://sepolia-faucet.pk910.de/
- Chainlink: https://faucets.chain.link/sepolia

## Predicted Address (NOT deployed)
0xB41444AD384EBF3fc7612043fA3187E11f9B0C00

NOTE: This is a predicted address from forge simulation.
NOT actual deployment. No bytecode at this address.

## Verification Status
- Etherscan: FAILED (no contract code)
- Sourcify: FAILED (could not detect deployment)

## Next Steps
1. Refill Sepolia ETH (target >= 0.007 ETH)
2. Re-run: forge script script/DeployInstitutionalResetRegistry.s.sol
3. Verify on Etherscan
4. Update evidence with actual address

## Correction
- Commit 2bbea392c incorrectly stated "deployed"
- This file corrects the status to "pending"
