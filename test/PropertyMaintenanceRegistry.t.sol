// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/PropertyMaintenanceRegistry.sol";

contract PropertyMaintenanceRegistryTest is Test {
    OperatorPrivileges privileges;
    PropertyMaintenanceRegistry registry;
    address op = vm.addr(1);
    address p1 = vm.addr(2);
    address p2 = vm.addr(3);
    address p3 = vm.addr(4);
    bytes32 PROP = keccak256("pauline-house");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new PropertyMaintenanceRegistry(address(privileges));
        privileges.addOperator(op);
        
        vm.prank(op);
        registry.registerProperty(PROP, keccak256("owner"), keccak256("coords"));
    }

    function testCommunityReportsDirtyProperty() public {
        vm.prank(p1); registry.reportDirtyProperty(PROP);
        vm.prank(p2); registry.reportDirtyProperty(PROP);
        
        // 2 reports: still CLEAN
        (,,, PropertyMaintenanceRegistry.ZoneStatus status, uint256 reps,,) = registry.properties(PROP);
        assertEq(uint8(status), uint8(PropertyMaintenanceRegistry.ZoneStatus.CLEAN));

        // 3rd report: DIRTY
        vm.prank(p3); registry.reportDirtyProperty(PROP);
        (,,, status, reps,,) = registry.properties(PROP);
        assertEq(uint8(status), uint8(PropertyMaintenanceRegistry.ZoneStatus.DIRTY));
        assertEq(reps, 3);
    }

    function testOperatorCleansProperty() public {
        vm.prank(p1); registry.reportDirtyProperty(PROP);
        vm.prank(op);
        registry.updateStatus(PROP, PropertyMaintenanceRegistry.ZoneStatus.CLEAN, 0);
        
        (,,, PropertyMaintenanceRegistry.ZoneStatus status, uint256 reps,,) = registry.properties(PROP);
        assertEq(uint8(status), uint8(PropertyMaintenanceRegistry.ZoneStatus.CLEAN));
        assertEq(reps, 0);
    }
}
