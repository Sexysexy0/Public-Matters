// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "forge-std/Test.sol";
import "../src/PublicUtilityProgressTracker.sol";

contract PublicUtilityProgressTrackerTest is Test {
    PublicUtilityProgressTracker tracker;
    address operator = address(this);

    function setUp() public {
        tracker = new PublicUtilityProgressTracker();
    }

    function test_RegisterProjectAndMilestones() public {
        uint256 pId = tracker.registerProject("McArthur Waterline Expansion", "Malolos, Bulacan");
        assertEq(pId, 1);

        tracker.addMilestone(pId, "Phase 1: Main Excavation");
        tracker.addMilestone(pId, "Phase 2: Pipe Laying & Welding");

        (string memory name, uint256 total, uint256 completed) = tracker.getProjectProgress(pId);
        assertEq(name, "McArthur Waterline Expansion");
        assertEq(total, 2);
        assertEq(completed, 0);

        tracker.completeMilestone(pId, 0, "QmHashProof123");
        
        (, , completed) = tracker.getProjectProgress(pId);
        assertEq(completed, 1);
    }
}
