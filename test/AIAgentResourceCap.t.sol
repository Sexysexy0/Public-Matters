// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentResourceCap.sol";

contract AIAgentResourceCapTest is Test {
    OperatorPrivileges privileges;
    AIAgentResourceCap caps;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    bytes32 constant AGENT_1 = keccak256("agent-1");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();
        caps = new AIAgentResourceCap(address(privileges));
    }

    function test_SetCap() public {
        vm.prank(op1);
        caps.setCap(AGENT_1, 1000000, 1000, 10, 3600);
        AIAgentResourceCap.Cap memory c = caps.getCap(AGENT_1);
        assertEq(c.maxGas, 1000000);
        assertEq(c.maxValue, 1000);
        assertEq(c.maxActionsPerWindow, 10);
        assertTrue(c.set);
    }

    function test_RecordUsageWithinLimits() public {
        vm.startPrank(op1);
        caps.setCap(AGENT_1, 1000, 500, 5, 3600);
        caps.recordUsage(AGENT_1, 100, 50);
        vm.stopPrank();
        AIAgentResourceCap.Usage memory u = caps.getUsage(AGENT_1);
        assertEq(u.gasUsed, 100);
        assertEq(u.valueUsed, 50);
        assertEq(u.actionsThisWindow, 1);
    }

    function test_ExceedsActionLimit() public {
        vm.startPrank(op1);
        caps.setCap(AGENT_1, 10000, 0, 2, 3600);
        caps.recordUsage(AGENT_1, 10, 0);
        caps.recordUsage(AGENT_1, 10, 0);
        vm.expectRevert("Exceeded max actions");
        caps.recordUsage(AGENT_1, 10, 0);
        vm.stopPrank();
    }

    function test_ExceedsGasLimit() public {
        vm.startPrank(op1);
        caps.setCap(AGENT_1, 100, 0, 100, 3600);
        caps.recordUsage(AGENT_1, 80, 0);
        vm.expectRevert("Exceeded gas cap");
        caps.recordUsage(AGENT_1, 30, 0);
        vm.stopPrank();
    }

    function test_ExceedsValueLimit() public {
        vm.startPrank(op1);
        caps.setCap(AGENT_1, 0, 100, 100, 3600);
        caps.recordUsage(AGENT_1, 0, 80);
        vm.expectRevert("Exceeded value cap");
        caps.recordUsage(AGENT_1, 0, 30);
        vm.stopPrank();
    }

    function test_WindowReset() public {
        vm.startPrank(op1);
        caps.setCap(AGENT_1, 1000, 0, 1, 100);
        caps.recordUsage(AGENT_1, 100, 0);

        vm.warp(block.timestamp + 200);

        caps.recordUsage(AGENT_1, 100, 0);
        AIAgentResourceCap.Usage memory u = caps.getUsage(AGENT_1);
        assertEq(u.actionsThisWindow, 1);
        vm.stopPrank();
    }

    function test_ExceedsCapView() public {
        vm.startPrank(op1);
        caps.setCap(AGENT_1, 100, 0, 5, 3600);
        caps.recordUsage(AGENT_1, 80, 0);
        assertTrue(caps.exceedsCap(AGENT_1, 30, 0));
        assertFalse(caps.exceedsCap(AGENT_1, 10, 0));
        vm.stopPrank();
    }

    function test_OnlyOperatorCanSetCap() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        caps.setCap(AGENT_1, 100, 100, 5, 3600);
    }
}
