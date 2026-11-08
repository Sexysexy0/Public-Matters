// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AidProjectRegistry.sol";
import "../src/MilestoneMaintenanceEscrow.sol";
import "../src/LocalMaintenanceTrainingRegistry.sol";

contract ForeignAidTransparencyTest is Test {
    OperatorPrivileges privileges;
    AidProjectRegistry registry;
    MilestoneMaintenanceEscrow escrow;
    LocalMaintenanceTrainingRegistry training;

    address op = vm.addr(1);
    address localOperator = vm.addr(2);
    address donor = vm.addr(3);

    bytes32 constant PROJECT_ID = keccak256("Well-42");
    bytes32 constant DONOR_HASH = keccak256("USAID");
    bytes32 constant LOCATION_HASH = keccak256("Somalia");
    bytes32 constant ASSET_HASH = keccak256("Water Well #42");
    bytes32 constant ASSET_TYPE = keccak256("Deepwell Pump");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        
        registry = new AidProjectRegistry(address(privileges));
        training = new LocalMaintenanceTrainingRegistry(address(privileges));
        escrow = new MilestoneMaintenanceEscrow(address(privileges), address(training));
    }

    function testCreateProject() public {
        vm.prank(op);
        registry.createProject(PROJECT_ID, DONOR_HASH, LOCATION_HASH, ASSET_HASH, localOperator, 10 ether);

        AidProjectRegistry.Project memory p = registry.getProject(PROJECT_ID);
        assertEq(p.localOperator, localOperator);
        assertTrue(p.active);
    }

    function testMaintainAndRelease() public {
        vm.prank(op);
        registry.createProject(PROJECT_ID, DONOR_HASH, LOCATION_HASH, ASSET_HASH, localOperator, 10 ether);

        // Donor deposits 10 ETH
        vm.deal(donor, 10 ether);
        vm.prank(donor);
        escrow.depositFunds{value: 10 ether}(PROJECT_ID);

        // Setup: Operator gets trained
        vm.startPrank(op);
        training.registerTrainer(ASSET_TYPE);
        training.certifyLocalOperator(localOperator, ASSET_TYPE);
        vm.stopPrank();

        // After 90 days, operator proves maintenance
        vm.warp(block.timestamp + 91 days);
        vm.deal(address(escrow), 10 ether); // Mock contract balance
        vm.prank(op);
        escrow.proveMaintenance(PROJECT_ID, payable(localOperator), ASSET_TYPE);

        assertEq(localOperator.balance, 2.5 ether); // 25% release
    }

    function testUncertifiedOperatorCannotGetFunds() public {
        vm.prank(op);
        registry.createProject(PROJECT_ID, DONOR_HASH, LOCATION_HASH, ASSET_HASH, localOperator, 10 ether);
        vm.deal(donor, 10 ether);
        vm.prank(donor);
        escrow.depositFunds{value: 10 ether}(PROJECT_ID);

        // Skip training, try to claim
        vm.prank(op);
        vm.expectRevert("Operator not certified to maintain this asset");
        escrow.proveMaintenance(PROJECT_ID, payable(localOperator), ASSET_TYPE);
    }

    function testBrokenWellRefundsDonor() public {
        vm.prank(op);
        registry.createProject(PROJECT_ID, DONOR_HASH, LOCATION_HASH, ASSET_HASH, localOperator, 10 ether);

        vm.deal(donor, 10 ether);
        vm.prank(donor);
        escrow.depositFunds{value: 10 ether}(PROJECT_ID);

        // Well breaks, operator flags it
        vm.prank(op);
        escrow.flagAsBroken(PROJECT_ID, payable(donor));

        assertEq(donor.balance, 10 ether); // Refunded
    }
}
