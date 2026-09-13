// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NuclearEvidenceRegistry} from "../../src/NuclearEvidenceRegistry.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";
import {NuclearDecisionGates} from "../../src/NuclearDecisionGates.sol";

contract NuclearDecisionGatesTest is Test {
    NuclearEvidenceRegistry evidence;
    NuclearConflictRegistry conflicts;
    NuclearDecisionGates gates;

    address reviewer1 = address(0xBEEF);
    address reviewer2 = address(0xCAFE);
    address outsider = address(0x1234);

    bytes32 constant SUBJECT = keccak256("G0 demand validation");
    bytes32 constant GATE_ID = keccak256("gate-0");
    bytes32 constant EVIDENCE_ID = keccak256("evidence-0");
    bytes32 constant SOURCE_HASH = keccak256("source-0");

    function setUp() public {
        evidence = new NuclearEvidenceRegistry();
        evidence.setReviewer(reviewer1, true);
        evidence.setReviewer(reviewer2, true);

        vm.prank(reviewer1);
        evidence.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        vm.prank(reviewer1);
        evidence.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Accepted);

        conflicts = new NuclearConflictRegistry();
        gates = new NuclearDecisionGates(address(evidence), address(conflicts));
        gates.setReviewer(reviewer1, true);
        gates.setReviewer(reviewer2, true);
    }

    function _createAndAttach(uint256 approvals) internal {
        gates.createGate(GATE_ID, SUBJECT, approvals);
        gates.attachEvidence(GATE_ID, EVIDENCE_ID);
    }

    function testCreateAndAttachEvidence() public {
        _createAndAttach(2);

        bytes32[] memory attached = gates.getGateEvidence(GATE_ID);
        assertEq(attached.length, 1);
        assertEq(attached[0], EVIDENCE_ID);
    }

    function testMissingEvidenceBlocksApproval() public {
        gates.createGate(GATE_ID, SUBJECT, 1);

        vm.expectRevert(NuclearDecisionGates.MissingEvidence.selector);
        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);
    }

    function testOneApprovalDoesNotPassTwoApprovalGate() public {
        _createAndAttach(2);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        NuclearDecisionGates.Gate memory gate = gates.getGate(GATE_ID);
        assertEq(uint8(gate.status), uint8(NuclearDecisionGates.GateStatus.Open));
        assertEq(gate.approvals, 1);
    }

    function testTwoIndependentApprovalsPassGate() public {
        _createAndAttach(2);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        vm.prank(reviewer2);
        gates.approveGate(GATE_ID);

        assertTrue(gates.isPassed(GATE_ID));
    }

    function testDuplicateApprovalBlocked() public {
        _createAndAttach(2);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        vm.expectRevert(NuclearDecisionGates.AlreadyApproved.selector);
        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);
    }

    function testUnauthorizedReviewerBlocked() public {
        _createAndAttach(1);

        vm.expectRevert(NuclearDecisionGates.Unauthorized.selector);
        vm.prank(outsider);
        gates.approveGate(GATE_ID);
    }

    function testConflictedReviewerBlocked() public {
        _createAndAttach(1);
        gates.setReviewerConflict(reviewer1, SUBJECT, true);

        vm.expectRevert(NuclearDecisionGates.ConflictedReviewer.selector);
        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);
    }

    function test_RevertWhenFailedEvidenceAttached() public {
        vm.prank(reviewer1);
        evidence.registerEvidence(keccak256("rejected"), SUBJECT, keccak256("rejected-source"));

        vm.prank(reviewer1);
        evidence.reviewEvidence(keccak256("rejected"), NuclearEvidenceRegistry.Status.Rejected);

        gates.createGate(GATE_ID, SUBJECT, 1);

        vm.expectRevert(NuclearDecisionGates.EvidenceNotUsable.selector);
        gates.attachEvidence(GATE_ID, keccak256("rejected"));
    }

    function testFrozenGateCannotBeModified() public {
        _createAndAttach(1);
        gates.freezeGate(GATE_ID);

        vm.expectRevert(NuclearDecisionGates.GateClosed.selector);
        gates.attachEvidence(GATE_ID, EVIDENCE_ID);
    }

    function testConditionalResolutionNeedsApprovals() public {
        gates.createGate(GATE_ID, SUBJECT, 2);

        vm.expectRevert(NuclearDecisionGates.InsufficientApprovals.selector);
        gates.resolveGate(GATE_ID, NuclearDecisionGates.GateStatus.Conditional);
    }

    function testRegistryConflictBlocksApproval() public {
        _createAndAttach(1);

        vm.prank(reviewer1);
        conflicts.declareConflict(SUBJECT, keccak256("reviewer-1-disclosure"), 0);

        vm.expectRevert(NuclearDecisionGates.ConflictedReviewer.selector);
        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);
    }

    function testRevokedRegistryConflictAllowsApproval() public {
        _createAndAttach(1);

        vm.prank(reviewer1);
        uint256 conflictId = conflicts.declareConflict(SUBJECT, keccak256("reviewer-1-disclosure"), 0);

        conflicts.revokeConflict(conflictId);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        assertTrue(gates.isPassed(GATE_ID));
    }

    function testExpiredRegistryConflictAllowsApproval() public {
        _createAndAttach(1);

        vm.prank(reviewer1);
        conflicts.declareConflict(SUBJECT, keccak256("reviewer-1-disclosure"), uint64(block.timestamp + 1 days));

        vm.warp(block.timestamp + 1 days);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        assertTrue(gates.isPassed(GATE_ID));
    }
}
