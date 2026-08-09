// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MicroLendingEscrow.sol";

contract MicroLendingEscrowTest is Test {
    MicroLendingEscrow public escrow;

    address public owner = address(this);
    address public borrower1 = makeAddr("borrower1");

    function setUp() public {
        escrow = new MicroLendingEscrow(500);
        // Fund the pool with 1 ETH for testing
        vm.deal(address(escrow), 1 ether);
        // Call depositLiquidity() to increase totalLiquidity
        escrow.depositLiquidity{value: 1 ether}();
        // Register the borrower
        escrow.registerBorrower(borrower1, 50);
        // Fund the borrower with some ETH for repayment
        vm.deal(borrower1, 0.1 ether);
    }

    function test_LoanLifecycle() public {
        // 1. Borrower takes a 0.05 ETH loan for 30 days
        vm.prank(borrower1);
        escrow.requestLoan(0.05 ether, 30);

        (address borrower, uint256 principal, uint256 dueAmount, uint256 dueDate, bool isActive, bool isPaid) = escrow.activeLoans(borrower1);
        assertEq(borrower, borrower1);
        assertEq(principal, 0.05 ether);
        assertTrue(isActive);
        assertFalse(isPaid);

        // 2. Fast forward 30 days
        vm.warp(dueDate + 1 seconds);

        // 3. Repay the loan
        vm.prank(borrower1);
        escrow.repayLoan{value: dueAmount}();

        (, , , , isActive, isPaid) = escrow.activeLoans(borrower1);
        assertFalse(isActive);
        assertTrue(isPaid);
    }
}
