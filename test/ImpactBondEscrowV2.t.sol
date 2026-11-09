// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/ImpactBondEscrowV2.sol";

contract ImpactBondEscrowV2Test is Test {
    OperatorPrivileges privileges;
    ImpactBondEscrowV2 escrow;

    address op = vm.addr(1);
    address nonOp = vm.addr(2);
    address donor = vm.addr(3);
    address ngo = vm.addr(4);
    bytes32 projectId = keccak256("river-cleanup-001");
    bytes32 proofHash = keccak256("ipfs-proof-hash");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        escrow = new ImpactBondEscrowV2(address(privileges));
    }

    function testCreateProject() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.createProject{value: 1 ether}(projectId, ngo);

        (address donor_, address ngo_, uint256 totalDeposited, uint256 releasedAmount, bytes32 latestProofHash, bool active) = escrow.projects(projectId);

        assertEq(donor_, donor);
        assertEq(ngo_, ngo);
        assertEq(totalDeposited, 1 ether);
        assertEq(releasedAmount, 0);
        assertEq(latestProofHash, bytes32(0));
        assertTrue(active);
    }

    function testSubmitImpactProof_OnlyNGO() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.createProject{value: 1 ether}(projectId, ngo);

        vm.prank(nonOp);
        vm.expectRevert("Only assigned NGO");
        escrow.submitImpactProof(projectId, proofHash);

        vm.prank(ngo);
        escrow.submitImpactProof(projectId, proofHash);

        (,,,, bytes32 latestProofHash,) = escrow.projects(projectId);
        assertEq(latestProofHash, proofHash);
    }

    function testVerifyImpactAndRelease_OnlyOperator() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.createProject{value: 1 ether}(projectId, ngo);

        vm.prank(ngo);
        escrow.submitImpactProof(projectId, proofHash);

        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        escrow.verifyImpactAndRelease(projectId, 0.5 ether);

        vm.prank(op);
        escrow.verifyImpactAndRelease(projectId, 0.5 ether);

        (,,, uint256 releasedAmount,,) = escrow.projects(projectId);
        assertEq(releasedAmount, 0.5 ether);
        assertEq(escrow.pendingWithdrawals(ngo), 0.5 ether);
    }

    function testWithdraw_PullBased() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.createProject{value: 1 ether}(projectId, ngo);

        vm.prank(ngo);
        escrow.submitImpactProof(projectId, proofHash);

        vm.prank(op);
        escrow.verifyImpactAndRelease(projectId, 0.5 ether);

        uint256 balanceBefore = ngo.balance;
        vm.prank(ngo);
        escrow.withdraw();
        assertEq(ngo.balance, balanceBefore + 0.5 ether);
        assertEq(escrow.pendingWithdrawals(ngo), 0);
    }

    function testWithdraw_NoFunds() public {
        vm.prank(ngo);
        vm.expectRevert("No funds to withdraw");
        escrow.withdraw();
    }

    function testProjectClosesWhenFullyReleased() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.createProject{value: 1 ether}(projectId, ngo);

        vm.prank(ngo);
        escrow.submitImpactProof(projectId, proofHash);

        vm.prank(op);
        escrow.verifyImpactAndRelease(projectId, 1 ether);

        (,,,,, bool active) = escrow.projects(projectId);
        assertFalse(active);
    }
}
