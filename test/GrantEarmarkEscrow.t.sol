// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GrantEarmarkEscrow.sol";

contract GrantEarmarkEscrowTest is Test {
    GrantEarmarkEscrow public vault;

    address admin = address(1);
    address donor = address(2);
    address payable grantee = payable(address(3));

    bytes32 grantId;

    function setUp() public {
        vm.prank(admin);
        vault = new GrantEarmarkEscrow();

        vm.deal(donor, 10 ether);
        vm.prank(donor);
        grantId = vault.createGrant{value: 4 ether}(keccak256("grant_alpha"), grantee, 30 days);
    }

    function test_DisburseTranche() public {
        uint256 initBalance = grantee.balance;

        vm.prank(admin);
        vault.disburseTranche(grantId, 2 ether);

        assertEq(grantee.balance, initBalance + 2 ether);
    }

    function test_ClawbackAfterExpiry() public {
        // Warp time past expiration
        vm.warp(block.timestamp + 31 days);

        uint256 initDonorBal = donor.balance;

        vm.prank(donor);
        vault.clawbackExpiredGrant(grantId);

        assertEq(donor.balance, initDonorBal + 4 ether);
    }

    function test_RevertWhen_EarlyClawback() public {
        vm.prank(donor);
        vm.expectRevert("Grant not expired yet");
        vault.clawbackExpiredGrant(grantId);
    }
}
