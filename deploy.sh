#!/bin/bash
# Foundry deployment script for InfrastructureTransparency

CONTRACT="contracts/InfrastructureTransparency.sol:InfrastructureTransparency"
RPC_URL="<RPC_URL>"          # replace with your chain RPC endpoint
PRIVATE_KEY="<PRIVATE_KEY>"  # replace with your deployer wallet key

# Compile contracts
forge build

# Run tests
forge test

# Deploy contract
forge create $CONTRACT --rpc-url $RPC_URL --private-key $PRIVATE_KEY
