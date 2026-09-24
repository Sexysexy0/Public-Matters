// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/GlobalEmergencyFreeze.sol";

contract GlobalEmergencyFreezeTest is Test {
    OperatorPrivileges privileges;
    GlobalEmergencyFreeze freeze;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address op2 = address(0xC0C);
    address op3 = address(0xD0D);

    bytes32 constant REASON = keccak256("rogue-ai-detected");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        privileges.addOperator(op2);
        privileges.addOperator(op3);
        vm.stopPrank();

        freeze = new GlobalEmergencyFreeze(address(privileges));
    }

    function test_InitialStateNotFrozen() public view {
        assertFalse(freeze.isFrozen());
    }

    function test_TriggerFreeze() public {
        vm.prank(op1);
        freeze.triggerGlobalFreeze(REASON);

        assertTrue(freeze.isFrozen());
    }

    function test_CannotTriggerTwice() public {
        vm.startPrank(op1);
        freeze.triggerGlobalFreeze(REASON);
        vm.expectRevert("Already frozen");
        freeze.triggerGlobalFreeze(REASON);
        vm.stopPrank();
    }

    function test_SingleApprovalNotEnough() public {
        vm.prank(op1);
        freeze.triggerGlobalFreeze(REASON);

        vm.prank(op1);
        freeze.proposeLift();

        assertTrue(freeze.isFrozen());
    }

    function test_TwoApprovalsLift() public {
        vm.prank(op1);
        freeze.triggerGlobalFreeze(REASON);

        vm.prank(op1);
        freeze.proposeLift();

        vm.prank(op2);
        freeze.proposeLift();

        assertFalse(freeze.isFrozen());
    }

    function test_CannotApproveTwice() public {
        vm.prank(op1);
        freeze.triggerGlobalFreeze(REASON);

        vm.startPrank(op1);
        freeze.proposeLift();
        vm.expectRevert("Already approved");
        freeze.proposeLift();
        vm.stopPrank();
    }

    function test_RevokeApproval() public {
        vm.prank(op1);
        freeze.triggerGlobalFreeze(REASON);

        vm.startPrank(op1);
        freeze.proposeLift();
        freeze.revokeLiftApproval();
        vm.stopPrank();

        assertTrue(freeze.isFrozen());
        assertEq(freeze.currentLiftApprovals(), 0);
    }

    function test_GetFreezeInfo() public {
        vm.prank(op1);
        freeze.triggerGlobalFreeze(REASON);

        (bool isFrozen, uint256 ts, bytes32 reason, address by,) = freeze.getFreezeInfo();
        assertTrue(isFrozen);
        assertEq(reason, REASON);
        assertEq(by, op1);
        assertGt(ts, 0);
    }

    function test_OnlyOperatorCanTrigger() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        freeze.triggerGlobalFreeze(REASON);
    }
}
