// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NuclearGovernanceLocalDeploy} from "../../script/NuclearGovernanceLocalDeploy.s.sol";
import {NuclearEvidenceRegistry} from "../../src/NuclearEvidenceRegistry.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";
import {NuclearDecisionGates} from "../../src/NuclearDecisionGates.sol";
import {NuclearPublicAudit} from "../../src/NuclearPublicAudit.sol";

contract NuclearLocalDeploymentTest is Test {
    function testLocalDeploymentWiresRegistries() public {
        NuclearGovernanceLocalDeploy deployer = new NuclearGovernanceLocalDeploy();

        NuclearGovernanceLocalDeploy.Deployment memory deployment = deployer.deploy();

        assertTrue(address(deployment.evidence) != address(0));
        assertTrue(address(deployment.conflicts) != address(0));
        assertTrue(address(deployment.gates) != address(0));
        assertTrue(address(deployment.audit) != address(0));

        assertEq(address(deployment.gates.evidenceRegistry()), address(deployment.evidence));
        assertEq(address(deployment.gates.conflictRegistry()), address(deployment.conflicts));
    }

    function testLocalDeploymentOwnersAreDeployer() public {
        NuclearGovernanceLocalDeploy deployer = new NuclearGovernanceLocalDeploy();

        NuclearGovernanceLocalDeploy.Deployment memory deployment = deployer.deploy();

        assertEq(deployment.evidence.owner(), address(deployer));
        assertEq(deployment.conflicts.owner(), address(deployer));
        assertEq(deployment.gates.owner(), address(deployer));
        assertEq(deployment.audit.owner(), address(deployer));
    }

    function testNoFundsOrExternalCallsAreRequired() public {
        NuclearGovernanceLocalDeploy deployer = new NuclearGovernanceLocalDeploy();

        NuclearGovernanceLocalDeploy.Deployment memory deployment = deployer.deploy();

        assertEq(address(deployment.evidence).balance, 0);
        assertEq(address(deployment.conflicts).balance, 0);
        assertEq(address(deployment.gates).balance, 0);
        assertEq(address(deployment.audit).balance, 0);
    }
}
