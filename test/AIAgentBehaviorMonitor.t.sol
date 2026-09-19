// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentBehaviorMonitor.sol";

contract AIAgentBehaviorMonitorTest is Test {
    OperatorPrivileges privileges;
    AIAgentBehaviorMonitor monitor;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);

    bytes32 constant AGENT_1 = keccak256("agent-1");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();

        monitor = new AIAgentBehaviorMonitor(address(privileges));
    }

    function test_SetBaseline() public {
        vm.prank(op1);
        monitor.setBaseline(AGENT_1, 10, 100, 3600);

        AIAgentBehaviorMonitor.Baseline memory b = monitor.getBaseline(AGENT_1);
        assertEq(b.expectedRate, 10);
        assertEq(b.expectedMagnitude, 100);
        assertTrue(b.set);
    }

    function test_RecordActionNormal() public {
        vm.startPrank(op1);
        monitor.setBaseline(AGENT_1, 10, 100, 3600);
        monitor.recordAction(AGENT_1, 50);
        vm.stopPrank();

        assertFalse(monitor.isAnomalous(AGENT_1));
        assertEq(monitor.getAnomalyCount(AGENT_1), 0);
    }

    function test_DetectRateAnomaly() public {
        vm.startPrank(op1);
        monitor.setBaseline(AGENT_1, 3, 100, 3600);

        for (uint256 i = 0; i < 5; i++) {
            monitor.recordAction(AGENT_1, 10);
        }
        vm.stopPrank();

        assertTrue(monitor.isAnomalous(AGENT_1));
        assertGt(monitor.getAnomalyCount(AGENT_1), 0);
    }

    function test_DetectMagnitudeAnomaly() public {
        vm.startPrank(op1);
        monitor.setBaseline(AGENT_1, 10, 100, 3600);
        monitor.recordAction(AGENT_1, 500);
        vm.stopPrank();

        assertTrue(monitor.isAnomalous(AGENT_1));
    }

    function test_ClearFlag() public {
        vm.startPrank(op1);
        monitor.setBaseline(AGENT_1, 1, 100, 3600);
        monitor.recordAction(AGENT_1, 10);
        monitor.recordAction(AGENT_1, 10);
        assertTrue(monitor.isAnomalous(AGENT_1));

        monitor.clearFlag(AGENT_1);
        assertFalse(monitor.isAnomalous(AGENT_1));
        vm.stopPrank();
    }

    function test_WindowReset() public {
        vm.startPrank(op1);
        monitor.setBaseline(AGENT_1, 5, 100, 100);

        monitor.recordAction(AGENT_1, 10);
        monitor.recordAction(AGENT_1, 10);

        vm.warp(block.timestamp + 200);

        monitor.recordAction(AGENT_1, 10);
        vm.stopPrank();

        assertFalse(monitor.isAnomalous(AGENT_1));
    }

    function test_CannotRecordWithoutBaseline() public {
        vm.prank(op1);
        vm.expectRevert("Baseline not set");
        monitor.recordAction(AGENT_1, 10);
    }

    function test_OnlyOperatorCanSetBaseline() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        monitor.setBaseline(AGENT_1, 10, 100, 3600);
    }
}
