# Deployment Verification

## Local-only scope

This test deploys the governance contracts inside Foundry's local EVM. It does not broadcast transactions and does not contact a testnet or mainnet.

## Required checks

- All four contracts deploy.
- Decision Gates references the intended Evidence and Conflict registries.
- Owners are the expected local deployer.
- No contract receives project funds.
- No contract controls physical equipment.
- No private key or RPC URL is required.

## Stop conditions

Stop if a deployment script requests a private key, RPC URL, external broadcast flag, or real-world project address.
