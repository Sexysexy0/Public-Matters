// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/DynamicFleetComplianceRegistry.sol";

contract DynamicFleetComplianceRegistryTest is Test {
    OperatorPrivileges privileges;
    DynamicFleetComplianceRegistry registry;
    address op = vm.addr(1);
    address rider = vm.addr(2);
    bytes32 constant PLATFORM = keccak256("move-it");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new DynamicFleetComplianceRegistry(address(privileges));
        privileges.addOperator(op);

        vm.prank(op);
        registry.registerPlatform(PLATFORM, "Move It", 17000, 1000000000); // 17k base, 1B bond
    }

    function testVerifyRiderAndExpandCap() public {
        uint256 initialCap = registry.getEffectiveCap(PLATFORM);
        assertEq(initialCap, 17000);

        vm.prank(op);
        registry.verifyRider(PLATFORM, rider);
        
        (,,, uint256 verified,,) = registry.platforms(PLATFORM);
        assertEq(verified, 1);
    }

    function testCapExpandsAfter10kRiders() public {
        // Simulate verifying 10,000 riders
        for (uint256 i = 0; i < 10000; i++) {
            address r = address(uint160(i + 1000));
            vm.prank(op);
            registry.verifyRider(PLATFORM, r);
        }
        
        uint256 expandedCap = registry.getEffectiveCap(PLATFORM);
        // Base 17,000 + (10,000 / 10,000) * 50,000 = 67,000
        assertEq(expandedCap, 67000);
    }
}
