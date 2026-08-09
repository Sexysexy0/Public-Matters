// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PermissionlessBroadcast.sol";

contract MockTrustIntegrator {
    uint256 public lastWeight;

    function logPositiveAction(uint256 _weight) external {
        lastWeight = _weight;
    }
}

contract PermissionlessBroadcastTest is Test {
    PermissionlessBroadcast public broadcast;
    MockTrustIntegrator public mockIntegrator;

    address public steward = address(this);
    address public user1 = makeAddr("user1");

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        broadcast = new PermissionlessBroadcast(address(mockIntegrator));
    }

    function test_SubmitAndApprove_UpdatesTrust() public {
        vm.prank(user1);
        broadcast.submitMessage("I held on today.");
        assertEq(broadcast.getSubmissionCount(), 1);

        broadcast.approveSubmission(0);
        assertEq(broadcast.approvedCount(), 1);

        // Verify the Trust Integrator was called with weight 10
        assertEq(mockIntegrator.lastWeight(), 10);
    }

    function test_OnlyStewardCanApprove() public {
        vm.prank(user1);
        broadcast.submitMessage("Test");

        vm.prank(user1);
        vm.expectRevert("Only the steward");
        broadcast.approveSubmission(0);
    }
}
