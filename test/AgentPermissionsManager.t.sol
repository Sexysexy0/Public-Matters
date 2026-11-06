// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AgentPermissionsManager.sol";

contract AgentPermissionsManagerTest is Test {
    OperatorPrivileges privileges;
    AgentPermissionsManager manager;
    address op = vm.addr(1);
    address agent = vm.addr(2);

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        manager = new AgentPermissionsManager(address(privileges));
    }

    function testSetAgentLimits() public {
        vm.prank(op);
        manager.setAgentLimits(agent, 100 ether, 500 ether);
        assertTrue(manager.getAgentLimits(agent).isRegistered);
    }

    function testValidateActionWithinLimits() public {
        vm.prank(op);
        manager.setAgentLimits(agent, 100 ether, 500 ether);

        manager.validateAction(agent, 50 ether);
        (uint256 spent, uint256 remaining) = manager.getAgentStatus(agent);
        assertEq(spent, 50 ether);
        assertEq(remaining, 450 ether);
    }

    function testRevertExceedsPerTx() public {
        vm.prank(op);
        manager.setAgentLimits(agent, 100 ether, 500 ether);

        vm.expectRevert("Exceeds max per-tx limit");
        manager.validateAction(agent, 101 ether);
    }

    function testRevertExceedsDaily() public {
        vm.prank(op);
        manager.setAgentLimits(agent, 100 ether, 150 ether);

        manager.validateAction(agent, 100 ether);
        vm.expectRevert("Exceeds max daily limit");
        manager.validateAction(agent, 60 ether);
    }

    function testResetDailyLimit() public {
        vm.prank(op);
        manager.setAgentLimits(agent, 100 ether, 150 ether);
        manager.validateAction(agent, 100 ether);

        // Jump 25 hours
        vm.warp(block.timestamp + 25 hours);

        manager.validateAction(agent, 100 ether); // Should pass again
    }
}
