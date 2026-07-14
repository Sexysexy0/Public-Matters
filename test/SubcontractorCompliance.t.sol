// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/SubcontractorComplianceEscrow.sol";
import "../contracts/InstitutionalAuditHistory.sol";

contract SubcontractorComplianceTest is Test {
    SubcontractorComplianceEscrow public complianceVault;
    InstitutionalAuditHistory public auditHistory;

    address public masterContractor = address(0x9999);
    address public primeContractorNode = address(0x1111);
    address public diverseSubcontractorNode = address(0x2222);

    bytes32 public sampleReceiptHash = keccak256(abi.encodePacked("ATLANTA_OCC_PROOF_OF_PAYMENT_CONFIRMED"));

    function setUp() public {
        vm.deal(masterContractor, 50 ether);

        vm.startPrank(masterContractor);
        auditHistory = new InstitutionalAuditHistory();
        complianceVault = new SubcontractorComplianceEscrow();

        complianceVault.setAuditHistoryAddress(address(auditHistory));
        auditHistory.setLoggerAuthorization(address(complianceVault), true);
        vm.stopPrank();
    }

    function test_Successful3DayPaymentComplianceFlow() public {
        vm.startPrank(masterContractor);
        uint256 projectId = complianceVault.initiateProjectPlan(primeContractorNode, diverseSubcontractorNode);
        complianceVault.releaseProjectFundingDraw{value: 10 ether}(projectId);
        vm.stopPrank();

        (,,,,, bool pendingCheck,) = complianceVault.projects(projectId);
        assertTrue(pendingCheck);

        vm.warp(block.timestamp + 2 days);

        vm.prank(primeContractorNode);
        complianceVault.uploadSubcontractorPaymentProof(projectId, sampleReceiptHash);

        assertEq(diverseSubcontractorNode.balance, 5 ether);

        (,,,,,, bytes32 verifiedProof) = complianceVault.projects(projectId);
        assertEq(verifiedProof, sampleReceiptHash);

        (,,,,, bool finalPending,) = complianceVault.projects(projectId);
        assertFalse(finalPending);
    }

    function test_EnforceSanctionOn3DayConstraintViolation() public {
        vm.startPrank(masterContractor);
        uint256 projectId = complianceVault.initiateProjectPlan(primeContractorNode, diverseSubcontractorNode);
        complianceVault.releaseProjectFundingDraw{value: 10 ether}(projectId);
        vm.stopPrank();

        // VIOLATION: Lumampas sa 3-day window tracking limit parameters
        vm.warp(block.timestamp + 4 days);

        // Hakbang A: I-trigger ang evaluation state call nang hiwalay sa revert context upang mai-save ang permanent ban flag
        complianceVault.checkAndSanctionOverduePrime(projectId);
        assertTrue(complianceVault.complianceBannedPrimes(primeContractorNode));

        // Hakbang B: I-verify na ang release transaction drawing chain ay permanenteng sarado at magre-revert na ngayon
        vm.startPrank(masterContractor);
        vm.expectRevert(
            "Error: Funding draw rejected. Prime Contractor violated the strict 3-day proof of payment upload rule."
        );
        complianceVault.releaseProjectFundingDraw{value: 5 ether}(projectId);
        vm.stopPrank();
    }
}
