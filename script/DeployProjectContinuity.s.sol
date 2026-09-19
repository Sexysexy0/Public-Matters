// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ProjectContinuityRegistry.sol";
import "../src/ContinuityGuard.sol";
import "../src/InvestigatorShield.sol";

contract DeployProjectContinuity is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address privilegesV2 = vm.envAddress("OPERATOR_PRIVILEGES_V2_ADDRESS");

        vm.startBroadcast(pk);

        ProjectContinuityRegistry registry = new ProjectContinuityRegistry(privilegesV2);
        ContinuityGuard guard = new ContinuityGuard(privilegesV2);
        InvestigatorShield shield = new InvestigatorShield(privilegesV2);

        vm.stopBroadcast();

        console.log("=== PROJECT CONTINUITY DEPLOYED ===");
        console.log("ProjectContinuityRegistry:", address(registry));
        console.log("ContinuityGuard:          ", address(guard));
        console.log("InvestigatorShield:       ", address(shield));
    }
}
