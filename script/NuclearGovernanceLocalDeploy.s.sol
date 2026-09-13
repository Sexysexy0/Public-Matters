// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {NuclearEvidenceRegistry} from "../src/NuclearEvidenceRegistry.sol";
import {NuclearConflictRegistry} from "../src/NuclearConflictRegistry.sol";
import {NuclearDecisionGates} from "../src/NuclearDecisionGates.sol";
import {NuclearPublicAudit} from "../src/NuclearPublicAudit.sol";

contract NuclearGovernanceLocalDeploy is Script {
    struct Deployment {
        NuclearEvidenceRegistry evidence;
        NuclearConflictRegistry conflicts;
        NuclearDecisionGates gates;
        NuclearPublicAudit audit;
    }

    function deploy() public returns (Deployment memory deployment) {
        deployment.evidence = new NuclearEvidenceRegistry();
        deployment.conflicts = new NuclearConflictRegistry();
        deployment.gates = new NuclearDecisionGates(
            address(deployment.evidence),
            address(deployment.conflicts)
        );
        deployment.audit = new NuclearPublicAudit();
    }

    function run() external returns (Deployment memory deployment) {
        deployment = deploy();
    }
}
