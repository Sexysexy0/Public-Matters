// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PermissionlessBroadcast.sol";

contract PermissionlessBroadcastTest is Test {
    PermissionlessBroadcast public broadcast;

    address public emperor = address(this);
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");

    function setUp() public {
        broadcast = new PermissionlessBroadcast();
    }

    function test_SubmitAndApprove() public {
        vm.prank(user1);
        broadcast.submitMessage("I held on today.");

        assertEq(broadcast.getSubmissionCount(), 1);

        broadcast.approveSubmission(0);

        PermissionlessBroadcast.Submission[] memory approved = broadcast.getApprovedMessages();
        assertEq(approved.length, 1);
        assertEq(approved[0].author, user1);
        assertEq(approved[0].message, "I held on today.");
        assertTrue(approved[0].approved);
    }

    function test_OnlyEmperorCanApprove() public {
        vm.prank(user1);
        broadcast.submitMessage("This is a test.");

        vm.prank(user2);
        vm.expectRevert("Only the Emperor");
        broadcast.approveSubmission(0);
    }
}
