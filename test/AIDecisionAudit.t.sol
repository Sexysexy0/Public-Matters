// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIDecisionAudit.sol";

contract AIDecisionAuditTest is Test {
    OperatorPrivileges privileges;
    AIDecisionAudit audit;
    address tester;
    bytes32 agentId;

    function setUp() public {
        privileges = new OperatorPrivileges();
        audit = new AIDecisionAudit(address(privileges));
        uint256 pk = 1;
        tester = vm.addr(pk);
        privileges.addOperator(tester);
        privileges.addOperator(address(this));
        agentId = keccak256("agent-01");
    }

    function testRecordDecision() public {
        bytes32 inputHash = keccak256("input");
        bytes32 reasoningHash = keccak256("reasoning");
        bytes32 outputHash = keccak256("output");

        vm.prank(tester);
        bytes32 decisionId = audit.recordDecision(agentId, inputHash, reasoningHash, outputHash, 85);

        AIDecisionAudit.Decision memory d = audit.getDecision(decisionId);
        assertEq(d.agentId, agentId);
        assertEq(d.inputHash, inputHash);
        assertEq(d.reasoningHash, reasoningHash);
        assertEq(d.outputHash, outputHash);
        assertEq(d.confidence, 85);
        assertEq(d.reportedBy, tester);
        assertFalse(d.superseded);
        assertEq(audit.totalDecisions(), 1);
        assertEq(audit.getDecisionCount(agentId), 1);
    }

    function testSupersedeDecision() public {
        vm.prank(tester);
        bytes32 original = audit.recordDecision(
            agentId, keccak256("bad input"), keccak256("bad reasoning"), keccak256("wrong output"), 90
        );

        vm.prank(tester);
        bytes32 correction = audit.recordDecision(
            agentId, keccak256("bad input"), keccak256("corrected reasoning"), keccak256("correct output"), 95
        );

        vm.prank(tester);
        audit.supersedeDecision(original, correction, "fabricated data detected");

        AIDecisionAudit.Decision memory d = audit.getDecision(original);
        assertTrue(d.superseded);
        assertEq(d.supersededBy, correction);
        assertEq(d.supersededReason, "fabricated data detected");

        // Original still exists — immutable trail preserved
        assertEq(audit.getDecisionCount(agentId), 2);
    }

    function testCannotSupersedeTwice() public {
        vm.startPrank(tester);
        bytes32 a = audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 50);
        bytes32 b = audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 50);
        bytes32 c = audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 50);

        audit.supersedeDecision(a, b, "first");
        vm.expectRevert("Decision already superseded");
        audit.supersedeDecision(a, c, "second");
        vm.stopPrank();
    }

    function testCannotSupersedeAcrossAgents() public {
        bytes32 otherAgent = keccak256("agent-02");
        vm.startPrank(tester);
        bytes32 a = audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 50);
        bytes32 b = audit.recordDecision(otherAgent, bytes32(0), bytes32(0), bytes32(0), 50);

        vm.expectRevert("Agent mismatch");
        audit.supersedeDecision(a, b, "cross-agent");
        vm.stopPrank();
    }

    function testVerifyDecision() public {
        bytes32 ih = keccak256("i");
        bytes32 rh = keccak256("r");
        bytes32 oh = keccak256("o");

        vm.prank(tester);
        bytes32 id = audit.recordDecision(agentId, ih, rh, oh, 70);

        assertTrue(audit.verifyDecision(id, ih, rh, oh));
        assertFalse(audit.verifyDecision(id, ih, rh, keccak256("wrong")));
    }

    function testUnauthorizedCannotRecord() public {
        address stranger = vm.addr(999);
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 50);
    }

    function testGetAllDecisions() public {
        vm.startPrank(tester);
        audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 10);
        audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 20);
        audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 30);
        vm.stopPrank();

        bytes32[] memory all = audit.getAllDecisions();
        assertEq(all.length, 3);
    }

    function testConfidenceBounds() public {
        vm.prank(tester);
        vm.expectRevert("Confidence must be 0-100");
        audit.recordDecision(agentId, bytes32(0), bytes32(0), bytes32(0), 101);
    }
}
