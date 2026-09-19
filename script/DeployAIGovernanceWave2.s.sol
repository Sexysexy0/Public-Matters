// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentReputation.sol";
import "../src/AIAgentTrainingRecord.sol";
import "../src/AIAgentResourceCap.sol";

contract DeployAIGovernanceWave2 is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        // Replace with existing Wave 1 OperatorPrivileges address
        address privilegesAddr = vm.envAddress("OPERATOR_PRIVILEGES_ADDRESS");

        vm.startBroadcast(pk);

        AIAgentReputation reputation = new AIAgentReputation(privilegesAddr);
        AIAgentTrainingRecord training = new AIAgentTrainingRecord(privilegesAddr);
        AIAgentResourceCap caps = new AIAgentResourceCap(privilegesAddr);

        vm.stopBroadcast();

        console.log("=== WAVE 2 DEPLOYMENTS ===");
        console.log("AIAgentReputation:       ", address(reputation));
        console.log("AIAgentTrainingRecord:   ", address(training));
        console.log("AIAgentResourceCap:      ", address(caps));
    }
}
