// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TrustIndex.sol";
import "../src/TrustIntegrator.sol";
import "../src/OperatorPrivileges.sol";
// ... other imports

contract DeployKingdom is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        // ... other bricks

        OperatorPrivileges privileges = new OperatorPrivileges();
        TrustIndex trust = new TrustIndex(address(privileges));
        TrustIntegrator trustIntegrator = new TrustIntegrator(address(trust));

        // ... rest of wiring

        vm.stopBroadcast();
        console.log("=== KINGDOM DEPLOYED SUCCESSFULLY ===");
    }
}
