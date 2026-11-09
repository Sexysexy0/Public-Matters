// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/CapacityAllocationRegistry.sol";

contract CapacityAllocationRegistryTest is Test {
    OperatorPrivileges privileges;
    CapacityAllocationRegistry registry;

    address op = vm.addr(1);
    address nonOp = vm.addr(2);
    bytes32 facilityHash = keccak256("SK-hynix-M15X");
    uint256 capacity = 100000;
    uint256 hbmBps = 3000;
    uint256 consumerBps = 7000;
    uint256 commitmentDate = 1735689600;

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        registry = new CapacityAllocationRegistry(address(privileges));
    }

    function testRecordCommitment_OnlyOperator() public {
        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        registry.recordCommitment(facilityHash, capacity, hbmBps, consumerBps, commitmentDate);
    }

    function testRecordCommitment_StoresData() public {
        vm.prank(op);
        registry.recordCommitment(facilityHash, capacity, hbmBps, consumerBps, commitmentDate);

        CapacityAllocationRegistry.CapacityCommitment memory c = registry.getCommitmentVersion(facilityHash, 1);
        assertEq(c.facilityHash, facilityHash);
        assertEq(c.waferCapacity, capacity);
        assertEq(c.hbmAllocationBps, hbmBps);
        assertEq(c.consumerAllocationBps, consumerBps);
        assertEq(c.recordedBy, op);
    }

    function testRecordCommitment_RejectsInvalidAllocation() public {
        vm.prank(op);
        vm.expectRevert("Allocation exceeds 10000 bps");
        registry.recordCommitment(facilityHash, capacity, 6000, 5000, commitmentDate);
    }

    function testRecordCommitment_AppendsVersion() public {
        vm.startPrank(op);
        registry.recordCommitment(facilityHash, capacity, hbmBps, consumerBps, commitmentDate);
        registry.recordCommitment(facilityHash, capacity + 10000, hbmBps, consumerBps, commitmentDate + 1);
        vm.stopPrank();

        assertEq(registry.commitmentCount(facilityHash), 2);

        CapacityAllocationRegistry.CapacityCommitment memory second = registry.getCommitmentVersion(facilityHash, 2);
        assertEq(second.waferCapacity, capacity + 10000);
    }

    function testReportVariance_OnlyOperator() public {
        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        registry.reportVariance(facilityHash, capacity, capacity - 1000, 1000);
    }

    function testReportVariance_StoresData() public {
        vm.prank(op);
        registry.reportVariance(facilityHash, capacity, capacity - 1000, 1000);

        CapacityAllocationRegistry.VarianceReport memory v = registry.getVarianceReport(facilityHash, 1);
        assertEq(v.facilityHash, facilityHash);
        assertEq(v.expectedOutput, capacity);
        assertEq(v.actualOutput, capacity - 1000);
        assertEq(v.varianceBps, 1000);
        assertEq(v.reportedBy, op);
    }

    function testReportVariance_AppendsVersion() public {
        vm.startPrank(op);
        registry.reportVariance(facilityHash, capacity, capacity - 1000, 1000);
        registry.reportVariance(facilityHash, capacity, capacity - 2000, 2000);
        vm.stopPrank();

        assertEq(registry.varianceCount(facilityHash), 2);

        CapacityAllocationRegistry.VarianceReport memory second = registry.getVarianceReport(facilityHash, 2);
        assertEq(second.varianceBps, 2000);
    }
}
