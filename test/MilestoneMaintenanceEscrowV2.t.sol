// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/LocalMaintenanceTrainingRegistry.sol";
import "../src/MilestoneMaintenanceEscrowV2.sol";

contract MilestoneMaintenanceEscrowV2Test is Test {
    OperatorPrivileges privileges;
    LocalMaintenanceTrainingRegistry trainingRegistry;
    MilestoneMaintenanceEscrowV2 escrow;

    address op = vm.addr(1);
    address donor = vm.addr(2);
    address localOperator = vm.addr(3);
    bytes32 projectId = keccak256("well-001");
    bytes32 assetTypeHash = keccak256("water-well");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        trainingRegistry = new LocalMaintenanceTrainingRegistry(address(privileges));
        escrow = new MilestoneMaintenanceEscrowV2(address(privileges), address(trainingRegistry));

        // Step 1: op registers self as trainer for assetTypeHash
        vm.prank(op);
        trainingRegistry.registerTrainer(assetTypeHash);

        // Step 2: op certifies localOperator
        vm.prank(op);
        trainingRegistry.certifyLocalOperator(localOperator, assetTypeHash);

        // Verify certification
        assertTrue(trainingRegistry.isCertified(localOperator, assetTypeHash));
    }

    function testDepositFunds() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.depositFunds{value: 1 ether}(projectId, localOperator);

        (uint256 balance, uint256 lastMaintenanceProof, bool isBroken, address donor_, address operator_) = escrow.escrows(projectId);
        assertEq(balance, 1 ether);
        assertEq(donor_, donor);
        assertEq(operator_, localOperator);
        assertFalse(isBroken);
    }

    function testProveMaintenance_PullBased() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.depositFunds{value: 1 ether}(projectId, localOperator);

        vm.prank(op);
        escrow.proveMaintenance(projectId, assetTypeHash);

        assertEq(escrow.pendingWithdrawals(localOperator), 0.25 ether);

        uint256 balanceBefore = localOperator.balance;
        vm.prank(localOperator);
        escrow.withdraw();
        assertEq(localOperator.balance, balanceBefore + 0.25 ether);
    }

    function testFlagAsBroken_PullBased() public {
        vm.deal(donor, 1 ether);
        vm.prank(donor);
        escrow.depositFunds{value: 1 ether}(projectId, localOperator);

        vm.prank(op);
        escrow.flagAsBroken(projectId);

        assertEq(escrow.pendingWithdrawals(donor), 1 ether);

        uint256 balanceBefore = donor.balance;
        vm.prank(donor);
        escrow.withdraw();
        assertEq(donor.balance, balanceBefore + 1 ether);
    }
}
