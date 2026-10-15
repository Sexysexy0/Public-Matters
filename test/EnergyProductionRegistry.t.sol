// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/EnergyProductionRegistry.sol";

contract EnergyProductionRegistryTest is Test {
    OperatorPrivileges privileges;
    EnergyProductionRegistry registry;

    address operator = vm.addr(1);
    address stranger = vm.addr(2);

    bytes32 constant REGION_A = keccak256("region-north");
    bytes32 constant REGION_B = keccak256("region-south");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new EnergyProductionRegistry(address(privileges));
        privileges.addOperator(operator);
    }

    function _record(bytes32 region, EnergyProductionRegistry.Source source, uint256 volume, uint256 cost)
        internal returns (bytes32)
    {
        vm.prank(operator);
        return registry.recordProduction(region, source, volume, cost, keccak256("evidence"));
    }

    function testRecordProduction() public {
        bytes32 id = _record(REGION_A, EnergyProductionRegistry.Source.SOLAR, 1000, 5);
        EnergyProductionRegistry.ProductionRecord memory r = registry.getRecord(id);
        assertEq(r.volume, 1000);
        assertEq(r.costPerUnit, 5);
        assertEq(uint8(r.source), uint8(EnergyProductionRegistry.Source.SOLAR));
        assertEq(registry.getRecordCount(), 1);
    }

    function testCannotRecordZeroVolume() public {
        vm.prank(operator);
        vm.expectRevert("volume=0");
        registry.recordProduction(REGION_A, EnergyProductionRegistry.Source.OIL, 0, 5, bytes32(0));
    }

    function testCannotRecordZeroRegion() public {
        vm.prank(operator);
        vm.expectRevert("regionHash=0");
        registry.recordProduction(bytes32(0), EnergyProductionRegistry.Source.OIL, 1, 5, bytes32(0));
    }

    function testStrangerCannotRecord() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.recordProduction(REGION_A, EnergyProductionRegistry.Source.OIL, 1, 5, bytes32(0));
    }

    function testSourceShare() public {
        _record(REGION_A, EnergyProductionRegistry.Source.OIL, 600, 10);
        _record(REGION_A, EnergyProductionRegistry.Source.SOLAR, 400, 5);

        // OIL: 600/1000 = 6000 bps
        assertEq(registry.getSourceShare(EnergyProductionRegistry.Source.OIL), 6000);
        // SOLAR: 400/1000 = 4000 bps
        assertEq(registry.getSourceShare(EnergyProductionRegistry.Source.SOLAR), 4000);
    }

    function testAverageCost() public {
        _record(REGION_A, EnergyProductionRegistry.Source.OIL, 100, 10);
        _record(REGION_A, EnergyProductionRegistry.Source.OIL, 200, 20);
        // avg cost = (10 + 20) / 2 = 15
        assertEq(registry.getAverageCost(REGION_A, EnergyProductionRegistry.Source.OIL), 15);
    }

    function testAverageCostEmptyRegion() public {
        assertEq(registry.getAverageCost(REGION_A, EnergyProductionRegistry.Source.OIL), 0);
    }

    function testSourceTotals() public {
        _record(REGION_A, EnergyProductionRegistry.Source.NUCLEAR, 500, 100);
        _record(REGION_B, EnergyProductionRegistry.Source.NUCLEAR, 300, 100);

        (uint256 vol, uint256 count) = registry.getSourceTotals(EnergyProductionRegistry.Source.NUCLEAR);
        assertEq(vol, 800);
        assertEq(count, 2);
    }

    function testRegionTotals() public {
        _record(REGION_A, EnergyProductionRegistry.Source.OIL, 100, 5);
        _record(REGION_A, EnergyProductionRegistry.Source.SOLAR, 200, 3);
        _record(REGION_A, EnergyProductionRegistry.Source.WIND, 300, 2);

        (uint256 vol, uint256 count) = registry.getRegionTotals(REGION_A);
        assertEq(vol, 600);
        assertEq(count, 3);
    }

    function testTotals() public {
        _record(REGION_A, EnergyProductionRegistry.Source.OIL, 100, 5);
        _record(REGION_B, EnergyProductionRegistry.Source.GAS, 200, 8);
        assertEq(registry.getTotals(), 300);
    }
}
