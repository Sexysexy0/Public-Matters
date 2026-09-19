// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentSandbox.sol";

contract AIAgentSandboxTest is Test {
    OperatorPrivileges privileges;
    AIAgentSandbox sandbox;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address outsider = address(0xBAD);

    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant AGENT_2 = keccak256("agent-2");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();

        sandbox = new AIAgentSandbox(address(privileges));
    }

    function test_EnterSandbox() public {
        vm.prank(op1);
        sandbox.enterSandbox(AGENT_1, 100, 1000);

        assertTrue(sandbox.isSandboxed(AGENT_1));
        assertFalse(sandbox.hasPassedSandbox(AGENT_1));
    }

    function test_CannotEnterTwice() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 100, 1000);
        vm.expectRevert("Agent already in sandbox");
        sandbox.enterSandbox(AGENT_1, 100, 1000);
        vm.stopPrank();
    }

    function test_OnlyOperatorCanEnter() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        sandbox.enterSandbox(AGENT_1, 100, 1000);
    }

    function test_ExitSandboxPassed() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 100, 1000);
        sandbox.exitSandbox(AGENT_1, true, "all tests passed");
        vm.stopPrank();

        assertFalse(sandbox.isSandboxed(AGENT_1));
        assertTrue(sandbox.hasPassedSandbox(AGENT_1));
    }

    function test_ExitSandboxFailed() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 100, 1000);
        sandbox.exitSandbox(AGENT_1, false, "failed safety check");
        vm.stopPrank();

        assertFalse(sandbox.isSandboxed(AGENT_1));
        assertFalse(sandbox.hasPassedSandbox(AGENT_1));
    }

    function test_RecordActionWithinLimits() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 5, 1000);

        for (uint256 i = 0; i < 3; i++) {
            sandbox.recordSandboxAction(AGENT_1, 10);
        }

        AIAgentSandbox.Sandbox memory s = sandbox.getSandbox(AGENT_1);
        assertEq(s.actionsPerformed, 3);
        assertEq(s.valueUsed, 30);
        assertTrue(sandbox.isSandboxed(AGENT_1));
        vm.stopPrank();
    }

    function test_RecordActionExceedsActionLimit() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 2, 1000);

        sandbox.recordSandboxAction(AGENT_1, 10);
        sandbox.recordSandboxAction(AGENT_1, 10);
        sandbox.recordSandboxAction(AGENT_1, 10);

        assertFalse(sandbox.isSandboxed(AGENT_1));
        vm.stopPrank();
    }

    function test_RecordActionExceedsValueLimit() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 100, 50);

        sandbox.recordSandboxAction(AGENT_1, 30);
        sandbox.recordSandboxAction(AGENT_1, 30);

        assertFalse(sandbox.isSandboxed(AGENT_1));
        vm.stopPrank();
    }

    function test_UpdateLimits() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 10, 100);
        sandbox.updateSandboxLimits(AGENT_1, 20, 200);
        vm.stopPrank();

        AIAgentSandbox.Sandbox memory s = sandbox.getSandbox(AGENT_1);
        assertEq(s.maxActions, 20);
        assertEq(s.maxValue, 200);
    }

    function test_TotalSandboxed() public {
        vm.startPrank(op1);
        sandbox.enterSandbox(AGENT_1, 10, 100);
        sandbox.enterSandbox(AGENT_2, 10, 100);
        vm.stopPrank();

        assertEq(sandbox.totalSandboxed(), 2);
    }
}
