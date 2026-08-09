// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ScholarshipEscrow.sol";

contract ScholarshipEscrowTest is Test {
    ScholarshipEscrow public escrow;

    address public owner = address(this);
    address public school = makeAddr("school");
    address public student = makeAddr("student");

    function setUp() public {
        escrow = new ScholarshipEscrow();
        // Fund the Escrow directly
        vm.deal(address(escrow), 10 ether);
        escrow.accreditSchool(school);
    }

    function test_GrantAndClaim() public {
        vm.prank(school);
        escrow.grantScholarship(student, 1 ether, 1);

        ScholarshipEscrow.Scholarship[] memory list = escrow.getScholarships(student);
        assertEq(list.length, 1);
        assertEq(list[0].amount, 1 ether);
        assertFalse(list[0].claimed);

        uint256 studentBalanceBefore = student.balance;
        vm.prank(student);
        escrow.claimScholarship(0);

        assertEq(student.balance - studentBalanceBefore, 1 ether);
        assertTrue(escrow.getScholarships(student)[0].claimed);
    }
}
