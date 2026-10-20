// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {CivicAccountabilityRegistry} from "../../src/civic-accountability/CivicAccountabilityRegistry.sol";
import {HumanFirstAIDeploymentRegistry} from "../../src/labor-futures/HumanFirstAIDeploymentRegistry.sol";

contract CivicLaborIntegrationTest is Test {
    CivicAccountabilityRegistry civicRegistry;
    HumanFirstAIDeploymentRegistry laborRegistry;

    address governor = makeAddr("governor");
    address civicAuditor = makeAddr("civicAuditor");
    address workerCouncil = makeAddr("workerCouncil");
    address journalist = makeAddr("journalist");

    bytes32 civicRecordId = keccak256("ai-displacement-concern");
    bytes32 laborDeploymentId = keccak256("ai-support-desk-deployment");
    bytes32 subjectHash = keccak256("employer-and-department");
    bytes32 evidenceHash = keccak256("impact-assessment-and-worker-testimony");
    uint256 futureDeadline;

    function setUp() public {
        vm.startPrank(governor);
        civicRegistry = new CivicAccountabilityRegistry(civicAuditor);
        laborRegistry = new HumanFirstAIDeploymentRegistry(workerCouncil);
        vm.stopPrank();

        futureDeadline = block.timestamp + 180 days;
    }

    function testIntegratedCivicAndLaborFlow() public {
        // 1. A worker or advocate files a civic accountability record
        //    documenting concerns about an AI deployment.
        vm.prank(journalist);
        assertTrue(
            civicRegistry.fileRecord(
                civicRecordId,
                CivicAccountabilityRegistry.RecordType.CITIZEN_MANDATE,
                subjectHash,
                evidenceHash,
                "AI displacement concern",
                "Workers request transition plan before AI support-desk rollout."
            )
        );

        // 2. The employer/governor proposes the AI deployment with a
        //    transition commitment.
        vm.prank(governor);
        laborRegistry.proposeDeployment(
            laborDeploymentId, "Example Corp", "Customer Support AI", evidenceHash, 120, 2_500, futureDeadline
        );

        // 3. The worker council reviews and approves only with a
        //    transition plan.
        vm.prank(workerCouncil);
        laborRegistry.workerCouncilDecision(
            laborDeploymentId, true, "Approved: retraining, redeployment, and wage protection required"
        );

        // 4. The civic auditor acknowledges the public concern and records
        //    the oversight response.
        vm.prank(civicAuditor);
        civicRegistry.updateRecord(
            civicRecordId,
            CivicAccountabilityRegistry.RecordStatus.UNDER_REVIEW,
            "Reviewing transition commitments and worker feedback"
        );

        // 5. Verify both registries preserve the linked evidence hash.
        CivicAccountabilityRegistry.Record memory civicRecord = civicRegistry.getRecord(civicRecordId);

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = laborRegistry.getDeployment(laborDeploymentId);

        assertEq(civicRecord.evidenceHash, evidenceHash);
        assertEq(deployment.impactAssessmentHash, evidenceHash);
        assertEq(civicRecord.subjectHash, subjectHash);
        assertEq(deployment.employer, "Example Corp");
        assertEq(deployment.affectedWorkers, 120);
        assertEq(deployment.transitionFundBps, 2_500);
        assertTrue(deployment.workerCouncilApproved);

        assertEq(uint256(civicRecord.status), uint256(CivicAccountabilityRegistry.RecordStatus.UNDER_REVIEW));
        assertEq(
            uint256(deployment.status),
            uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.APPROVED_WITH_TRANSITION_PLAN)
        );

        assertEq(civicRegistry.totalRecords(), 1);
        assertEq(laborRegistry.totalDeployments(), 1);
    }

    function testRejectedDeploymentCanBeDocumentedCivically() public {
        vm.prank(journalist);
        civicRegistry.fileRecord(
            civicRecordId,
            CivicAccountabilityRegistry.RecordType.CITIZEN_MANDATE,
            subjectHash,
            evidenceHash,
            "AI displacement concern",
            "Workers request a credible transition plan."
        );

        vm.prank(governor);
        laborRegistry.proposeDeployment(
            laborDeploymentId, "Example Corp", "Customer Support AI", evidenceHash, 120, 0, futureDeadline
        );

        vm.prank(workerCouncil);
        laborRegistry.workerCouncilDecision(laborDeploymentId, false, "Rejected: no credible transition plan");

        vm.prank(civicAuditor);
        civicRegistry.updateRecord(
            civicRecordId,
            CivicAccountabilityRegistry.RecordStatus.RESOLVED,
            "Deployment rejected; worker transition concerns documented"
        );

        HumanFirstAIDeploymentRegistry.Deployment memory deployment = laborRegistry.getDeployment(laborDeploymentId);

        CivicAccountabilityRegistry.Record memory civicRecord = civicRegistry.getRecord(civicRecordId);

        assertFalse(deployment.workerCouncilApproved);
        assertEq(uint256(deployment.status), uint256(HumanFirstAIDeploymentRegistry.DeploymentStatus.REJECTED));
        assertEq(uint256(civicRecord.status), uint256(CivicAccountabilityRegistry.RecordStatus.RESOLVED));
    }
}
