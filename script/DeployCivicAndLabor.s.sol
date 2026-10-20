// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {CivicAccountabilityRegistry} from "../src/civic-accountability/CivicAccountabilityRegistry.sol";
import {HumanFirstAIDeploymentRegistry} from "../src/labor-futures/HumanFirstAIDeploymentRegistry.sol";

/**
 * @title DeployCivicAndLabor
 * @notice Deploys the civic accountability registry and human-first AI
 *         deployment registry using environment-provided keys.
 *
 * Required environment variables:
 *   PRIVATE_KEY
 *   CIVIC_AUDITOR
 *   WORKER_COUNCIL
 */
contract DeployCivicAndLabor is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address civicAuditor = vm.envAddress("CIVIC_AUDITOR");
        address workerCouncil = vm.envAddress("WORKER_COUNCIL");

        vm.startBroadcast(deployerPrivateKey);

        CivicAccountabilityRegistry civicRegistry =
            new CivicAccountabilityRegistry(civicAuditor);

        HumanFirstAIDeploymentRegistry laborRegistry =
            new HumanFirstAIDeploymentRegistry(workerCouncil);

        vm.stopBroadcast();

        console.log("CivicAccountabilityRegistry:", address(civicRegistry));
        console.log("HumanFirstAIDeploymentRegistry:", address(laborRegistry));
        console.log("Civic auditor:", civicAuditor);
        console.log("Worker council:", workerCouncil);
    }
}
