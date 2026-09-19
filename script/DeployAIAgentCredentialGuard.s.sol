// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AIAgentCredentialGuard.sol";

contract DeployAIAgentCredentialGuard is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address privilegesV2 = vm.envAddress("OPERATOR_PRIVILEGES_V2_ADDRESS");

        vm.startBroadcast(pk);

        AIAgentCredentialGuard guard = new AIAgentCredentialGuard(privilegesV2);

        vm.stopBroadcast();

        console.log("=== CREDENTIAL GUARD DEPLOYED ===");
        console.log("AIAgentCredentialGuard:", address(guard));
        console.log("Uses privileges V2:    ", privilegesV2);
    }
}
