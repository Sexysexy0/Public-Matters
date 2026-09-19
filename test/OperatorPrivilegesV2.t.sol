// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";

contract OperatorPrivilegesV2Test is Test {
    OperatorPrivilegesV2 privileges;

    address owner = address(0xA11CE);
    address newOwner = address(0xB0B);
    address op1 = address(0x51);
    address outsider = address(0xBAD);

    function setUp() public {
        vm.prank(owner);
        privileges = new OperatorPrivilegesV2();
    }

    function test_InitialOwner() public view {
        assertEq(privileges.owner(), owner);
        assertTrue(privileges.isOperator(owner));
    }

    function test_TransferOwnership_StartsPending() public {
        vm.prank(owner);
        privileges.transferOwnership(newOwner);
        assertEq(privileges.owner(), owner);
        assertEq(privileges.pendingOwner(), newOwner);
    }

    function test_AcceptOwnership() public {
        vm.prank(owner);
        privileges.transferOwnership(newOwner);

        vm.prank(newOwner);
        privileges.acceptOwnership();

        assertEq(privileges.owner(), newOwner);
        assertEq(privileges.pendingOwner(), address(0));
        assertTrue(privileges.isOperator(newOwner));
    }

    function test_CannotAcceptIfNotPending() public {
        vm.prank(owner);
        privileges.transferOwnership(newOwner);

        vm.prank(outsider);
        vm.expectRevert("Not pending owner");
        privileges.acceptOwnership();
    }

    function test_CancelTransfer() public {
        vm.startPrank(owner);
        privileges.transferOwnership(newOwner);
        privileges.cancelOwnershipTransfer();
        vm.stopPrank();

        assertEq(privileges.pendingOwner(), address(0));
        assertEq(privileges.owner(), owner);
    }

    function test_CannotTransferToSelf() public {
        vm.prank(owner);
        vm.expectRevert("Already owner");
        privileges.transferOwnership(owner);
    }

    function test_CannotTransferToZero() public {
        vm.prank(owner);
        vm.expectRevert("Invalid new owner");
        privileges.transferOwnership(address(0));
    }

    function test_AddOperator() public {
        vm.prank(owner);
        privileges.addOperator(op1);
        assertTrue(privileges.isOperator(op1));
    }

    function test_RemoveOperator() public {
        vm.startPrank(owner);
        privileges.addOperator(op1);
        privileges.removeOperator(op1);
        vm.stopPrank();
        assertFalse(privileges.isOperator(op1));
    }

    function test_TrustScoreSyncWithLogAction() public {
        vm.startPrank(owner);
        privileges.addOperator(op1);
        vm.stopPrank();

        vm.prank(op1);
        privileges.logAction(op1, 100);

        assertEq(privileges.getTrustScore(op1), 100);
    }

    function test_TrustScoreDecrement() public {
        vm.startPrank(owner);
        privileges.addOperator(op1);
        vm.stopPrank();

        vm.startPrank(op1);
        privileges.logAction(op1, 100);
        privileges.logAction(op1, -30);
        vm.stopPrank();

        assertEq(privileges.getTrustScore(op1), 70);
    }
}
