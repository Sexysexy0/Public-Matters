// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AIAgentIncidentRegistry.sol";
import "../src/AIAgentSunsetProtocol.sol";
import "../src/AIDecisionChallenge.sol";

contract DeployAIGovernanceWave6 is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address privilegesV2 = vm.envAddress("OPERATOR_PRIVILEGES_V2_ADDRESS");

        vm.startBroadcast(pk);

        AIAgentIncidentRegistry incidentRegistry = new AIAgentIncidentRegistry(privilegesV2);
        AIAgentSunsetProtocol sunsetProtocol = new AIAgentSunsetProtocol(privilegesV2);
        AIDecisionChallenge decisionChallenge = new AIDecisionChallenge(privilegesV2);

        vm.stopBroadcast();

        console.log("=== WAVE 6 REMAINING ===");
        console.log("AIAgentIncidentRegistry:", address(incidentRegistry));
        console.log("AIAgentSunsetProtocol:  ", address(sunsetProtocol));
        console.log("AIDecisionChallenge:    ", address(decisionChallenge));
    }
}
