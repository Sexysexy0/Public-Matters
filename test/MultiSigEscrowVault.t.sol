// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MultiSigEscrowVault.sol";

contract MultiSigEscrowVaultTest is Test {
    MultiSigEscrowVault public vault;

    address public owner = address(this);
    address public partner1 = makeAddr("partner1");
    address public partner2 = makeAddr("partner2");
    address public recipient = makeAddr("recipient");

    function setUp() public {
        // 2-out-of-2 MultiSig for the test
        address[] memory signers = new address[](2);
        signers[0] = partner1;
        signers[1] = partner2;

        vault = new MultiSigEscrowVault(signers, 2);
        // Fund the vault with 10 ETH
        vm.deal(address(vault), 10 ether);
    }

    function test_TimelockMultiSigFlow() public {
        // Step 1: Partner 1 submits a 5 ETH payout request
        vm.prank(partner1);
        uint256 txId = vault.submitTransaction(payable(recipient), 5 ether, "");

        // Step 2: Partner 1 and Partner 2 confirm
        vm.prank(partner1);
        vault.confirmTransaction(txId);
        vm.prank(partner2);
        vault.confirmTransaction(txId);

        // Step 3: Attempt to execute instantly (should revert due to timelock)
        vm.prank(partner1);
        vm.expectRevert("MultiSigVault: Timelock active");
        vault.executeTransaction(txId);

        // Step 4: Fast forward time by 2 days
        vm.warp(block.timestamp + 2 days);

        // Step 5: Execute successfully
        vm.prank(partner1);
        vault.executeTransaction(txId);

        assertEq(recipient.balance, 5 ether);
    }
}
