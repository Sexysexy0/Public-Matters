// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/EnvironmentalBondEscrowV2.sol";

contract EnvironmentalBondEscrowV2Test is Test {
    OperatorPrivileges privileges;
    EnvironmentalBondEscrowV2 escrow;

    address op = vm.addr(1);
    address company = vm.addr(2);
    address communityFund = vm.addr(3);
    bytes32 permitId = keccak256("permit-001");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        escrow = new EnvironmentalBondEscrowV2(address(privileges), communityFund);
    }

    function testDepositBond() public {
        vm.deal(company, 1 ether);
        vm.prank(company);
        escrow.depositBond{value: 1 ether}(permitId);

        (uint256 amount, address company_) = escrow.bonds(permitId);
        assertEq(amount, 1 ether);
        assertEq(company_, company);
    }

    function testReleaseBond_PullBased() public {
        vm.deal(company, 1 ether);
        vm.prank(company);
        escrow.depositBond{value: 1 ether}(permitId);

        vm.prank(op);
        escrow.releaseBond(permitId);

        assertEq(escrow.pendingWithdrawals(company), 1 ether);

        uint256 balanceBefore = company.balance;
        vm.prank(company);
        escrow.withdraw();
        assertEq(company.balance, balanceBefore + 1 ether);
        assertEq(escrow.pendingWithdrawals(company), 0);
    }

    function testForfeitBond_PushToCommunityFund() public {
        vm.deal(company, 1 ether);
        vm.prank(company);
        escrow.depositBond{value: 1 ether}(permitId);

        uint256 fundBefore = communityFund.balance;
        vm.prank(op);
        escrow.forfeitBond(permitId);
        assertEq(communityFund.balance, fundBefore + 1 ether);
    }
}
