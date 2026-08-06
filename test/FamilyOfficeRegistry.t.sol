// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/FamilyOfficeRegistry.sol";

contract FamilyOfficeRegistryTest is Test {
    FamilyOfficeRegistry public registry;
    address public owner = address(this);
    address public intruder = makeAddr("intruder");

    function setUp() public {
        registry = new FamilyOfficeRegistry();
    }

    function test_RegisterOfficeAndGetDetails() public {
        bytes32 testHash = keccak256(abi.encodePacked("PwC_Confidential_Asset_2026"));
        
        // Mag-register ng isang PwC Family Office (APAC)
        registry.registerOffice("PwC Hong Kong Family Office", FamilyOfficeRegistry.Jurisdiction.APAC, testHash);

        FamilyOfficeRegistry.Office memory office = registry.getOffice(1);

        assertEq(office.name, "PwC Hong Kong Family Office");
        assertEq(uint8(office.location), uint8(FamilyOfficeRegistry.Jurisdiction.APAC));
        assertEq(office.contactHash, testHash);
        assertTrue(office.isActive);
        assertTrue(office.registeredAt > 0);
    }

    function test_OnlyGhostCanRegister() public {
        vm.prank(intruder);
        vm.expectRevert("FamilyOfficeRegistry: Only the owner can operate");
        registry.registerOffice("Hacker Corp", FamilyOfficeRegistry.Jurisdiction.OTHER, bytes32(0));
    }

    function test_DeactivateOffice() public {
        registry.registerOffice("EU Treaty Partner", FamilyOfficeRegistry.Jurisdiction.EU, bytes32("test"));
        registry.deactivateOffice(1);
        
        FamilyOfficeRegistry.Office memory office = registry.getOffice(1); bool isActive = office.isActive;
        assertFalse(isActive);
    }
}
