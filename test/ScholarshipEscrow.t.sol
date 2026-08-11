// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ScholarshipEscrow.sol";

contract ScholarshipEscrowTest is Test {
    ScholarshipEscrow public escrow;

    address admin = address(1);
    address verifier = address(2);
    address payable studentAddr = payable(address(3));

    bytes32 studentId;

    function setUp() public {
        vm.deal(admin, 10 ether);

        vm.prank(admin);
        escrow = new ScholarshipEscrow{value: 5 ether}(verifier);

        vm.prank(admin);
        studentId = escrow.enrollStudent(keccak256("student_001"), studentAddr, 2 ether);
    }

    function test_MilestoneWorkflowAndDisbursement() public {
        bytes32 proof = keccak256("gpa_3.8_transcript");

        // 1. Admin adds milestone
        vm.prank(admin);
        escrow.addMilestone(studentId, 1 ether, proof);

        // 2. Verifier approves milestone
        vm.prank(verifier);
        escrow.approveMilestone(studentId, 0);

        // 3. Disburse funds
        uint256 initialBalance = studentAddr.balance;

        escrow.disburseMilestone(studentId, 0);

        assertEq(studentAddr.balance, initialBalance + 1 ether);
    }

    function test_RevertWhen_UnauthorizedApproval() public {
        vm.prank(admin);
        escrow.addMilestone(studentId, 1 ether, keccak256("proof"));

        vm.prank(address(99)); // Random user
        vm.expectRevert("Unauthorized: Verifier only");
        escrow.approveMilestone(studentId, 0);
    }
}
