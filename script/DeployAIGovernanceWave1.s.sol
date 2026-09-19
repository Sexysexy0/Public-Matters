// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentSandbox.sol";
import "../src/AIAgentBehaviorMonitor.sol";
import "../src/GlobalEmergencyFreeze.sol";
import "../src/AIAgentCommunicationGuard.sol";

contract DeployAIGovernanceWave1 is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(pk);

        OperatorPrivileges privileges = new OperatorPrivileges();

        AIAgentSandbox sandbox = new AIAgentSandbox(address(privileges));
        AIAgentBehaviorMonitor monitor = new AIAgentBehaviorMonitor(address(privileges));
        GlobalEmergencyFreeze freeze = new GlobalEmergencyFreeze(address(privileges));
        AIAgentCommunicationGuard guard = new AIAgentCommunicationGuard(address(privileges));

        vm.stopBroadcast();

        console.log("=== WAVE 1 DEPLOYMENTS ===");
        console.log("OperatorPrivileges:         ", address(privileges));
        console.log("AIAgentSandbox:             ", address(sandbox));
        console.log("AIAgentBehaviorMonitor:     ", address(monitor));
        console.log("GlobalEmergencyFreeze:      ", address(freeze));
        console.log("AIAgentCommunicationGuard:  ", address(guard));
    }
}
