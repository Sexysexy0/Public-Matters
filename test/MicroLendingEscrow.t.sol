// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MicroLendingEscrow.sol";

contract MockTrustIntegrator {
    uint256 public lastWeight;

    function logPositiveAction(uint256 _weight) external {
        lastWeight = _weight;
    }
}

contract MicroLendingEscrowTest is Test {
    MicroLendingEscrow public escrow;
    MockTrustIntegrator public mockIntegrator;

    address public steward = address(this);
    address public borrower1 = makeAddr("borrower1");

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        escrow = new MicroLendingEscrow(500, address(mockIntegrator));
        vm.deal(address(escrow), 1 ether);
        escrow.depositLiquidity{value: 1 ether}();
        escrow.registerBorrower(borrower1, 50);
        vm.deal(borrower1, 0.1 ether);
    }

    function test_LoanLifecycle_UpdatesTrust() public {
        vm.prank(borrower1);
        escrow.requestLoan(0.05 ether, 30);

        // Cleared borrower and principal variable targets to silence warning output
        (,, uint256 dueAmount, uint256 dueDate, bool isActive, bool isPaid) = escrow.activeLoans(borrower1);
        assertTrue(isActive);
        assertFalse(isPaid);

        vm.warp(dueDate + 1 seconds);

        vm.prank(borrower1);
        escrow.repayLoan{value: dueAmount}();

        (,,,, isActive, isPaid) = escrow.activeLoans(borrower1);
        assertFalse(isActive);
        assertTrue(isPaid);
    }
}
