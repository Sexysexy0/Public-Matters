// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PathogenGuardRegistry.sol";

contract PathogenGuardRegistryTest is Test {
    PathogenGuardRegistry guard;
    address steward = address(this);
    address researcher = address(0x456);
    bytes32 constant MOCK_GENOME = keccak256("SYNTHETIC_BACTERIOPHAGE_V1");

    function setUp() public {
        guard = new PathogenGuardRegistry();
    }

    function test_SubmitAndApproveGenome() public {
        vm.prank(researcher);
        guard.submitGenome(MOCK_GENOME, 3);

        guard.reviewAndApprove(MOCK_GENOME);
        (, , bool isApproved, , ) = guard.registry(MOCK_GENOME);
        assertTrue(isApproved);
    }

    function test_RevertWhenUnauthorizedReviews() public {
        vm.prank(researcher);
        guard.submitGenome(MOCK_GENOME, 3);

        vm.prank(researcher);
        vm.expectRevert(PathogenGuardRegistry.Unauthorized.selector);
        guard.reviewAndApprove(MOCK_GENOME);
    }
}
