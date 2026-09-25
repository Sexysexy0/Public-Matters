// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test, console} from "forge-std/Test.sol";
import {NuclearDecisionGates} from "../../src/NuclearDecisionGates.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";
import {NuclearEvidenceRegistry} from "../../src/NuclearEvidenceRegistry.sol";

contract NuclearDecisionGatesTest is Test {
    NuclearDecisionGates public gates;
    NuclearConflictRegistry public conflicts;
    NuclearEvidenceRegistry public evidence;

    address public gatekeeper = address(0x1111111111111111111111111111111111111111);
    address public reviewer1 = address(0x2222222222222222222222222222222222222222);
    address public attacker = address(0x3333333333333333333333333333333333333333);

    bytes32 public constant GATE_ID = keccak256("gate-01");
    bytes32 public constant SUBJECT = keccak256("subject-01");
    bytes32 public constant EVIDENCE_ID = keccak256("evidence-01");

    function setUp() public {
        vm.startPrank(gatekeeper);

        evidence = new NuclearEvidenceRegistry();
        conflicts = new NuclearConflictRegistry();
        gates = new NuclearDecisionGates(address(evidence), address(conflicts));

        evidence.setReviewer(reviewer1, true);
        gates.setReviewer(reviewer1, true);

        vm.stopPrank();
    }

    function testCreateAndApproveGateFlow() public {
        vm.prank(gatekeeper);
        gates.createGate(GATE_ID, SUBJECT, 1);

        vm.prank(reviewer1);
        evidence.registerEvidence(EVIDENCE_ID, SUBJECT, keccak256("source"));

        vm.prank(reviewer1);
        evidence.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Accepted);

        vm.prank(reviewer1);
        gates.attachEvidence(GATE_ID, EVIDENCE_ID);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        assertTrue(gates.isPassed(GATE_ID));
        console.log("Decision gate creation and approval matrix verified.");
    }

    function test_RevertIf_UnauthorizedConfigurationAttempt() public {
        vm.prank(attacker);
        vm.expectRevert(NuclearDecisionGates.GateUnauthorized.selector);
        gates.createGate(GATE_ID, SUBJECT, 1);
    }
}
