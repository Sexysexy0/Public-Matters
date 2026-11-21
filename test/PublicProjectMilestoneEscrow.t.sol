// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PublicProjectMilestoneEscrow} from "../contracts/PublicProjectMilestoneEscrow.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;

    function setOperator(address a, bool v) external {
        ops[a] = v;
    }

    function isOperator(address a) external view returns (bool) {
        return ops[a];
    }
}

contract PublicProjectMilestoneEscrowTest is Test {
    PublicProjectMilestoneEscrow escrow;
    MockOperatorPrivileges opv;
    address donor = address(0xA11ce);
    address operator = address(0xB0b);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        escrow = new PublicProjectMilestoneEscrow(address(opv));
        opv.setOperator(operator, true);
        vm.deal(donor, 10 ether);
    }

    function test_CreateProject() public {
        vm.prank(donor);
        uint256 pid = escrow.createProject{value: 1 ether}();
        assertEq(pid, 0);
        (address d, uint256 funded,,,) = escrow.projects(pid);
        assertEq(d, donor);
        assertEq(funded, 1 ether);
    }

    function test_AddAndVerifyMilestone() public {
        vm.prank(donor);
        uint256 pid = escrow.createProject{value: 1 ether}();
        vm.prank(operator);
        escrow.addMilestone(pid, "Phase 1: Planning", 0.5 ether);
        bytes32 proof = keccak256("proof-doc-1");
        vm.prank(operator);
        escrow.submitProof(pid, 0, proof);
        vm.prank(operator);
        escrow.verifyAndRelease(pid, 0);
        (,, uint256 released,,) = escrow.projects(pid);
        assertEq(released, 0.5 ether);
        assertEq(escrow.pendingWithdrawals(donor), 0.5 ether);
    }

    function test_DoubleVerifyReverts() public {
        vm.prank(donor);
        uint256 pid = escrow.createProject{value: 1 ether}();
        vm.prank(operator);
        escrow.addMilestone(pid, "Phase 1", 0.5 ether);
        vm.prank(operator);
        escrow.submitProof(pid, 0, keccak256("p1"));
        vm.prank(operator);
        escrow.verifyAndRelease(pid, 0);
        vm.prank(operator);
        vm.expectRevert();
        escrow.verifyAndRelease(pid, 0);
    }

    function test_NonOperatorReverts() public {
        vm.prank(donor);
        uint256 pid = escrow.createProject{value: 1 ether}();
        vm.prank(address(0xDEAD));
        vm.expectRevert();
        escrow.addMilestone(pid, "x", 0.1 ether);
    }

    function test_WithdrawPullBased() public {
        vm.prank(donor);
        uint256 pid = escrow.createProject{value: 1 ether}();
        vm.prank(operator);
        escrow.addMilestone(pid, "Phase 1", 1 ether);
        vm.prank(operator);
        escrow.submitProof(pid, 0, keccak256("p1"));
        vm.prank(operator);
        escrow.verifyAndRelease(pid, 0);
        uint256 before = donor.balance;
        vm.prank(donor);
        escrow.withdraw();
        assertEq(donor.balance, before + 1 ether);
        assertEq(escrow.pendingWithdrawals(donor), 0);
    }

    function test_CancelProjectRefundsFullUnreleased() public {
        vm.prank(donor);
        uint256 pid = escrow.createProject{value: 1 ether}();
        vm.prank(operator);
        escrow.addMilestone(pid, "Phase 1", 0.4 ether);
        vm.prank(operator);
        escrow.cancelProject(pid);
        assertEq(escrow.pendingWithdrawals(donor), 1 ether);
    }
}
