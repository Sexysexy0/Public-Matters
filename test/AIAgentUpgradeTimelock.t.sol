// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentUpgradeTimelock.sol";

contract AIAgentUpgradeTimelockTest is Test {
    OperatorPrivileges privileges;
    AIAgentUpgradeTimelock timelock;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant NEW_MODEL = keccak256("model-v2");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();
        timelock = new AIAgentUpgradeTimelock(address(privileges));
    }

    function test_ScheduleUpgrade() public {
        vm.prank(op1);
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 0);
        assertTrue(timelock.hasPending(AGENT_1));
    }

    function test_CannotScheduleDuplicate() public {
        vm.startPrank(op1);
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 0);
        vm.expectRevert("Upgrade already pending");
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 0);
        vm.stopPrank();
    }

    function test_CannotExecuteBeforeETA() public {
        vm.prank(op1);
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 2 days);

        vm.prank(op1);
        vm.expectRevert("Timelock not expired");
        timelock.executeUpgrade(AGENT_1);
    }

    function test_ExecuteAfterETA() public {
        vm.prank(op1);
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 2 days);

        vm.warp(block.timestamp + 2 days + 1);

        vm.prank(op1);
        timelock.executeUpgrade(AGENT_1);

        assertFalse(timelock.hasPending(AGENT_1));
    }

    function test_CancelUpgrade() public {
        vm.prank(op1);
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 0);

        vm.prank(op1);
        timelock.cancelUpgrade(AGENT_1);

        assertFalse(timelock.hasPending(AGENT_1));
    }

    function test_InvalidDelay() public {
        vm.prank(op1);
        vm.expectRevert("Invalid delay");
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 1 seconds);
    }

    function test_DefaultDelayUsed() public {
        vm.prank(op1);
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 0);

        AIAgentUpgradeTimelock.Upgrade memory u = timelock.getUpgrade(AGENT_1);
        assertEq(u.eta, block.timestamp + 2 days);
    }

    function test_SetDefaultDelay() public {
        vm.prank(op1);
        timelock.setDefaultDelay(3 days);
        assertEq(timelock.defaultDelay(), 3 days);
    }

    function test_OnlyOperatorCanSchedule() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        timelock.scheduleUpgrade(AGENT_1, NEW_MODEL, "ipfs://new", 0);
    }
}
