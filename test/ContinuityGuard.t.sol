// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/ContinuityGuard.sol";

contract ContinuityGuardTest is Test {
    OperatorPrivilegesV2 privileges;
    ContinuityGuard guard;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address op2 = address(0xC0C);
    address outsider = address(0xBAD);

    bytes32 constant REASON = keccak256("budget-crisis");
    bytes32 constant BLOCK_REASON = keccak256("public-interest-violation");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        privileges.addOperator(op2);
        vm.stopPrank();
        guard = new ContinuityGuard(address(privileges));
    }

    function test_LogCancellationAttempt() public {
        vm.prank(op1);
        uint256 id = guard.logCancellationAttempt(1, REASON);
        assertEq(id, 1);

        ContinuityGuard.CancellationAttempt memory a = guard.getAttempt(id);
        assertEq(a.projectId, 1);
        assertEq(a.approvals, 1);
    }

    function test_ApproveCancellationAttempt() public {
        vm.prank(op1);
        uint256 id = guard.logCancellationAttempt(1, REASON);

        vm.prank(op2);
        guard.approveCancellationAttempt(id);

        ContinuityGuard.CancellationAttempt memory a = guard.getAttempt(id);
        assertEq(a.approvals, 2);
    }

    function test_CannotApproveTwice() public {
        vm.startPrank(op1);
        uint256 id = guard.logCancellationAttempt(1, REASON);
        vm.expectRevert("Already approved");
        guard.approveCancellationAttempt(id);
        vm.stopPrank();
    }

    function test_BlockCancellationAttempt() public {
        vm.startPrank(op1);
        uint256 id = guard.logCancellationAttempt(1, REASON);
        guard.blockCancellationAttempt(id, BLOCK_REASON);
        vm.stopPrank();

        ContinuityGuard.CancellationAttempt memory a = guard.getAttempt(id);
        assertTrue(a.blocked);
    }

    function test_ExecuteRequiresPublicNotice() public {
        vm.startPrank(op1);
        uint256 id = guard.logCancellationAttempt(1, REASON);
        vm.stopPrank();

        vm.prank(op2);
        guard.approveCancellationAttempt(id);

        // Try to execute without notice — should fail
        vm.prank(op1);
        vm.expectRevert("No public notice");
        guard.executeCancellation(id);
    }

    function test_ExecuteAfterNoticePeriod() public {
        vm.startPrank(op1);
        uint256 id = guard.logCancellationAttempt(1, REASON);
        guard.publishPublicNotice(1, "Proposed cancellation of HSR project");
        vm.stopPrank();

        vm.prank(op2);
        guard.approveCancellationAttempt(id);

        // Try to execute before 30 days
        vm.prank(op1);
        vm.expectRevert("Public notice period not elapsed");
        guard.executeCancellation(id);

        // Warp 30 days
        vm.warp(block.timestamp + 30 days);

        vm.prank(op1);
        guard.executeCancellation(id);

        ContinuityGuard.CancellationAttempt memory a = guard.getAttempt(id);
        assertTrue(a.executed);
    }

    function test_ReportSuppressionAttempt() public {
        vm.prank(op1);
        guard.reportSuppressionAttempt(1, keccak256("AB2624"));
        // Event emitted — test passes if no revert
    }

    function test_PublicNoticeTracking() public {
        vm.prank(op1);
        guard.publishPublicNotice(1, "Test notice");

        ContinuityGuard.PublicNotice memory n = guard.getNotice(1);
        assertEq(n.projectId, 1);
        assertGt(n.earliestActionDate, block.timestamp);
    }
}
