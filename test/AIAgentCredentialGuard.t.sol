// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIAgentCredentialGuard.sol";

contract AIAgentCredentialGuardTest is Test {
    OperatorPrivilegesV2 privileges;
    AIAgentCredentialGuard guard;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address outsider = address(0xBAD);

    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant SYSTEM_1 = keccak256("auth-system-1");
    bytes32 constant SYSTEM_2 = keccak256("auth-system-2");
    bytes32 constant REASON = keccak256("manual-lockout");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();
        guard = new AIAgentCredentialGuard(address(privileges));
    }

    function test_SetConfig() public {
        vm.prank(op1);
        guard.setConfig(AGENT_1, 3, 300, 600);

        AIAgentCredentialGuard.Config memory c = guard.getConfig(AGENT_1);
        assertEq(c.maxFailedAttempts, 3);
        assertEq(c.windowSize, 300);
        assertEq(c.lockoutDuration, 600);
        assertTrue(c.set);
    }

    function test_OnlyOperatorCanSetConfig() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        guard.setConfig(AGENT_1, 3, 300, 600);
    }

    function test_RecordSuccess() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 3, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, true);
        vm.stopPrank();

        assertEq(guard.totalAttempts(AGENT_1), 1);
        assertEq(guard.totalFailedAttempts(AGENT_1), 0);
        assertFalse(guard.isLockedOut(AGENT_1));
    }

    function test_RecordFailure() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 3, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        vm.stopPrank();

        assertEq(guard.totalFailedAttempts(AGENT_1), 1);
        assertFalse(guard.isLockedOut(AGENT_1));
    }

    function test_AutomaticLockoutOnThreshold() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 2, 300, 600);

        // 3 failures → exceeds max of 2
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);

        assertTrue(guard.isLockedOut(AGENT_1));
        assertEq(guard.lockoutCount(AGENT_1), 1);
        vm.stopPrank();
    }

    function test_CannotRecordWhenLockedOut() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 2, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);

        vm.expectRevert("Agent is locked out");
        guard.recordAuthAttempt(AGENT_1, SYSTEM_2, true);
        vm.stopPrank();
    }

    function test_WindowReset() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 3, 100, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);

        vm.warp(block.timestamp + 200);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, true);

        assertEq(guard.getFailedAttemptsThisWindow(AGENT_1), 0);
        vm.stopPrank();
    }

    function test_ForceLockout() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 3, 300, 600);
        guard.forceLockout(AGENT_1, REASON, 3600);
        vm.stopPrank();

        assertTrue(guard.isLockedOut(AGENT_1));

        AIAgentCredentialGuard.Lockout memory l = guard.getLockout(AGENT_1);
        assertEq(l.reason, REASON);
        assertTrue(l.active);
    }

    function test_ClearLockout() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 1, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        assertTrue(guard.isLockedOut(AGENT_1));

        guard.clearLockout(AGENT_1);
        assertFalse(guard.isLockedOut(AGENT_1));
        vm.stopPrank();
    }

    function test_LockoutExpires() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 1, 300, 100);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        assertTrue(guard.isLockedOut(AGENT_1));

        vm.warp(block.timestamp + 200);
        assertFalse(guard.isLockedOut(AGENT_1));
        vm.stopPrank();
    }

    function test_GetStats() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 5, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, true);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_2, true);

        (uint256 total, uint256 failed, uint256 locks, bool locked) = guard.getStats(AGENT_1);
        assertEq(total, 3);
        assertEq(failed, 1);
        assertEq(locks, 0);
        assertFalse(locked);
        vm.stopPrank();
    }

    function test_TotalTracked() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 3, 300, 600);
        guard.setConfig(keccak256("agent-2"), 3, 300, 600);
        vm.stopPrank();

        assertEq(guard.totalTracked(), 2);
    }

    function test_ConfigRequiredBeforeRecording() public {
        vm.prank(op1);
        vm.expectRevert("Config not set");
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, true);
    }
}
