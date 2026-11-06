// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentBehaviorMonitorV2.sol";

contract AIAgentBehaviorMonitorV2Test is Test {
    OperatorPrivileges privileges;
    AIAgentBehaviorMonitorV2 monitor;
    address op = vm.addr(1);
    address agent = vm.addr(2);

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        monitor = new AIAgentBehaviorMonitorV2(address(privileges), 7 days);
    }

    function testRegisterAgent() public {
        vm.prank(op);
        monitor.registerAgent(agent, 3);
        assertTrue(monitor.isAgentSafe(agent));
    }

    function testRecordAction() public {
        vm.prank(op);
        monitor.registerAgent(agent, 3);
        monitor.recordAction(agent);
        assertFalse(monitor.checkDormancy(agent));
    }

    function testFreezeOnViolation() public {
        vm.prank(op);
        monitor.registerAgent(agent, 2);

        vm.prank(op);
        monitor.recordViolation(agent, "arson");
        assertTrue(monitor.isAgentSafe(agent));

        vm.prank(op);
        monitor.recordViolation(agent, "theft");
        assertFalse(monitor.isAgentSafe(agent)); // Frozen after 2
    }

    function testCannotRecordActionIfFrozen() public {
        vm.prank(op);
        monitor.registerAgent(agent, 1);
        vm.prank(op);
        monitor.recordViolation(agent, "violence");

        vm.expectRevert("Agent is frozen");
        monitor.recordAction(agent);
    }

    function testDormancy() public {
        vm.prank(op);
        monitor.registerAgent(agent, 3);
        
        vm.warp(block.timestamp + 8 days); // Pass 7 day threshold
        assertTrue(monitor.checkDormancy(agent));
    }
}
