// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIAgentCredentialGuardV2.sol";

contract AIAgentCredentialGuardV2Test is Test {
    OperatorPrivilegesV2 privileges;
    AIAgentCredentialGuardV2 guard;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address outsider = address(0xBAD);
    address multisig = address(0x1111);
    address freeze = address(0x2222);

    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant SYSTEM_1 = keccak256("auth-system-1");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();
        guard = new AIAgentCredentialGuardV2(address(privileges), multisig, freeze);
    }

    function _triggerLockout(bytes32 agentId, uint256 times) internal {
        for (uint256 i = 0; i < times; i++) {
            guard.recordAuthAttempt(agentId, SYSTEM_1, false);
            guard.recordAuthAttempt(agentId, SYSTEM_1, false);
            guard.recordAuthAttempt(agentId, SYSTEM_1, false);
            guard.clearLockout(agentId);
        }
    }

    function test_InitTargets() public view {
        assertEq(guard.multisigTarget(), multisig);
        assertEq(guard.freezeTarget(), freeze);
    }

    function test_SetConfigWithEscalation() public {
        vm.prank(op1);
        guard.setConfig(AGENT_1, 2, 3, 300, 600);
        AIAgentCredentialGuardV2.Config memory c = guard.getConfig(AGENT_1);
        assertEq(c.maxFailedAttempts, 2);
        assertEq(c.escalationThreshold, 3);
    }

    function test_InvalidEscalation() public {
        vm.prank(op1);
        vm.expectRevert("Escalation must be > 0");
        guard.setConfig(AGENT_1, 2, 0, 300, 600);
    }

    function test_StandardLockout() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 2, 5, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        assertTrue(guard.isLockedOut(AGENT_1));
        vm.stopPrank();
    }

    function test_EscalationOnRepeatedLockouts() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 2, 3, 300, 600);

        // Trigger 2 lockouts — no escalation yet
        _triggerLockout(AGENT_1, 2);
        assertEq(guard.escalationCount(AGENT_1), 0);
        assertEq(guard.lockoutCount(AGENT_1), 2);

        // Trigger 3rd lockout → escalation
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);

        assertEq(guard.escalationCount(AGENT_1), 1);
        assertEq(guard.lockoutCount(AGENT_1), 3);

        AIAgentCredentialGuardV2.Lockout memory l = guard.getLockout(AGENT_1);
        assertTrue(l.escalated);
        vm.stopPrank();
    }

    function test_SetTargets() public {
        vm.prank(op1);
        guard.setTargets(address(0x3333), address(0x4444));
        assertEq(guard.multisigTarget(), address(0x3333));
    }

    function test_ClearLockout() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 2, 5, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        assertTrue(guard.isLockedOut(AGENT_1));

        guard.clearLockout(AGENT_1);
        assertFalse(guard.isLockedOut(AGENT_1));
        vm.stopPrank();
    }

    function test_OnlyOperatorCanSetConfig() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        guard.setConfig(AGENT_1, 3, 5, 300, 600);
    }

    function test_CannotRecordWhenLockedOut() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 1, 5, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);
        vm.expectRevert("Agent is locked out");
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, true);
        vm.stopPrank();
    }

    function test_GetStats() public {
        vm.startPrank(op1);
        guard.setConfig(AGENT_1, 3, 5, 300, 600);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, true);
        guard.recordAuthAttempt(AGENT_1, SYSTEM_1, false);

        (uint256 total, uint256 failed, uint256 locks, uint256 escs, bool locked) = guard.getStats(AGENT_1);
        assertEq(total, 2);
        assertEq(failed, 1);
        assertEq(locks, 0);
        assertEq(escs, 0);
        assertFalse(locked);
        vm.stopPrank();
    }
}
