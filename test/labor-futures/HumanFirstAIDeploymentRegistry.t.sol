// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {HumanFirstAIDeploymentRegistry} from "../../src/labor-futures/HumanFirstAIDeploymentRegistry.sol";

contract HumanFirstAIDeploymentRegistryTest is Test {
    HumanFirstAIDeploymentRegistry registry;

    address governor = makeAddr("governor");
    address workerCouncil = makeAddr("workerCouncil");
    address stranger = makeAddr("stranger");

    bytes32 deploymentId = keccak256("deployment-1");
    bytes32 assessmentHash = keccak256("impact-assessment");
    uint256 futureDeadline;

    event WorkerCouncilDecision(bytes32 indexed id, bool approved, string notes);

    function setUp() public {
        vm.prank(governor);
        registry = new HumanFirstAIDeploymentRegistry(workerCouncil);

        futureDeadline = block.timestamp + 365 days;
    }

    function testConstructorRejectsZeroCouncil() public {
        vm.prank(governor);
        vm.expectRevert(HumanFirstAIDeploymentRegistry.ZeroAddress.selector);
        new HumanFirstAIDeploymentRegistry(address(0));
    }

    function testGovernorCanProposeDeployment() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = registry.getDeployment(deploymentId);

        assertEq(deployment.id, deploymentId);
        assertEq(deployment.employer, "Example Corp");
        assertEq(deployment.aiSystem, "Customer Support AI");
        assertEq(deployment.impactAssessmentHash, assessmentHash);
        assertEq(deployment.affectedWorkers, 250);
        assertEq(deployment.transitionFundBps, 2_000);
        assertEq(deployment.noLayoffUntil, futureDeadline);
        assertFalse(deployment.workerCouncilApproved);
        assertEq(
            uint256(deployment.status), uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.WORKER_COUNCIL_REVIEW)
        );
        assertEq(deployment.notes, "");
        assertEq(registry.totalDeployments(), 1);
    }

    function testCannotProposeDuplicateDeployment() public {
        vm.startPrank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        vm.expectRevert(HumanFirstAIDeploymentRegistry.DeploymentAlreadyExists.selector);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );
        vm.stopPrank();
    }

    function testTransitionFundCannotExceed100Percent() public {
        vm.prank(governor);
        vm.expectRevert(HumanFirstAIDeploymentRegistry.InvalidTransitionFund.selector);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 10_001, futureDeadline
        );
    }

    function testNoLayoffDeadlineMustBeFuture() public {
        vm.prank(governor);
        vm.expectRevert(HumanFirstAIDeploymentRegistry.InvalidNoLayoffDeadline.selector);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, block.timestamp
        );
    }

    function testOnlyWorkerCouncilCanDecide() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        vm.prank(governor);
        vm.expectRevert(HumanFirstAIDeploymentRegistry.Unauthorized.selector);
        registry.workerCouncilDecision(deploymentId, true, "Self-approval blocked");

        vm.prank(stranger);
        vm.expectRevert(HumanFirstAIDeploymentRegistry.Unauthorized.selector);
        registry.workerCouncilDecision(deploymentId, true, "Unauthorized");
    }

    function testWorkerCouncilCanApprove() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        vm.expectEmit(true, false, false, true);
        emit WorkerCouncilDecision(deploymentId, true, "Approved with retraining and redeployment plan");

        vm.prank(workerCouncil);
        registry.workerCouncilDecision(deploymentId, true, "Approved with retraining and redeployment plan");

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = registry.getDeployment(deploymentId);

        assertTrue(deployment.workerCouncilApproved);
        assertEq(
            uint256(deployment.status),
            uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.APPROVED_WITH_TRANSITION_PLAN)
        );
        assertEq(deployment.notes, "Approved with retraining and redeployment plan");
    }

    function testWorkerCouncilCanReject() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 0, futureDeadline
        );

        vm.prank(workerCouncil);
        registry.workerCouncilDecision(deploymentId, false, "No credible transition plan");

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = registry.getDeployment(deploymentId);

        assertFalse(deployment.workerCouncilApproved);
        assertEq(uint256(deployment.status), uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.REJECTED));
        assertEq(deployment.notes, "No credible transition plan");
    }

    function testCannotDecideTwice() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        vm.startPrank(workerCouncil);
        registry.workerCouncilDecision(deploymentId, true, "Approved");

        vm.expectRevert(HumanFirstAIDeploymentRegistry.AlreadyDecided.selector);
        registry.workerCouncilDecision(deploymentId, false, "Changed mind");
        vm.stopPrank();
    }

    function testGovernorCanMarkCompletedAfterApproval() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        vm.prank(workerCouncil);
        registry.workerCouncilDecision(deploymentId, true, "Approved");

        vm.prank(governor);
        registry.updateStatus(
            deploymentId,
            HumanFirstAIDeploymentRegistry.DeploymentStatus.COMPLETED,
            "All affected workers redeployed or retrained"
        );

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = registry.getDeployment(deploymentId);

        assertEq(uint256(deployment.status), uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.COMPLETED));
        assertEq(deployment.notes, "All affected workers redeployed or retrained");
    }

    function testGovernorCanMarkRolledBack() public {
        vm.prank(governor);
        registry.proposeDeployment(
            deploymentId, "Example Corp", "Customer Support AI", assessmentHash, 250, 2_000, futureDeadline
        );

        vm.prank(workerCouncil);
        registry.workerCouncilDecision(deploymentId, true, "Approved");

        vm.prank(governor);
        registry.updateStatus(
            deploymentId,
            HumanFirstAIDeploymentRegistry.DeploymentStatus.ROLLED_BACK,
            "Avoidable displacement identified"
        );

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = registry.getDeployment(deploymentId);

        assertEq(uint256(deployment.status), uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.ROLLED_BACK));
        assertEq(deployment.notes, "Avoidable displacement identified");
    }

    function testCannotUpdateNonexistentDeployment() public {
        vm.prank(governor);
        vm.expectRevert(HumanFirstAIDeploymentRegistry.DeploymentNotFound.selector);
        registry.updateStatus(
            keccak256("missing"), HumanFirstAIDeploymentRegistry.DeploymentStatus.COMPLETED, "No deployment"
        );
    }
}
