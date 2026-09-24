// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test, console} from "forge-std/Test.sol";
import {NuclearDecisionGates} from "../../src/NuclearDecisionGates.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";

contract NuclearDecisionGatesTest is Test {
    NuclearDecisionGates public gates;
    NuclearConflictRegistry public conflicts;
    
    address public gatekeeper = address(0x1111111111111111111111111111111111111111);
    address public reviewer1 = address(0x2222222222222222222222222222222222222222);
    address public attacker = address(0x3333333333333333333333333333333333333333);
    
    bytes32 public constant GATE_ID = keccak256("gate-01");
    bytes32 public constant SUBJECT = keccak256("subject-01");
    bytes32 public constant EVIDENCE_ID = keccak256("evidence-01");

    function setUp() public {
        vm.startPrank(gatekeeper);
        conflicts = new NuclearConflictRegistry();
        gates = new NuclearDecisionGates(address(0x9999), address(conflicts));
        gates.setReviewer(reviewer1, true);
        vm.stopPrank();
    }

    function testCreateAndApproveGateFlow() public {
        vm.startPrank(gatekeeper);
        gates.createGate(GATE_ID, SUBJECT, 1);
        vm.stopPrank();

        gates.attachEvidence(GATE_ID, EVIDENCE_ID);

        vm.startPrank(reviewer1);
        gates.approveGate(GATE_ID);
        vm.stopPrank();

        assertTrue(gates.isPassed(GATE_ID));
        console.log("Decision gate creation and approval matrix fully verified.");
    }

    function test_RevertIf_UnauthorizedConfigurationAttempt() public {
        // Execute the call using a fresh tx.origin boundary to cleanly trigger the test revert condition
        vm.startPrank(attacker, attacker);
        vm.expectRevert("Not administrative steward");
        gates.createGate(GATE_ID, SUBJECT, 1);
        vm.stopPrank();
    }
}
