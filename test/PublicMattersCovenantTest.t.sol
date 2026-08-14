// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PublicMattersCovenant.sol";

contract PublicMattersCovenantTest is Test {
    PublicMattersCovenant covenant;
    address steward = address(0xABCD);

    function setUp() public {
        covenant = new PublicMattersCovenant(steward);
    }

    function testInitialPrinciplesDeclared() public {
        vm.expectEmit(true, true, true, true);
        emit PublicMattersCovenant.PreservationDeclared("Humanity First Principle", steward);
        covenant = new PublicMattersCovenant(steward);
    }

    function testRedistributionEmitsEvent() public {
        vm.prank(steward);
        vm.expectEmit(true, true, true, true);
        emit PublicMattersCovenant.Redistribution(steward, address(0x1234), 100, "Food");
        covenant.redistribute(address(0x1234), 100, "Food");
    }

    function testAcknowledgeRestEmitsEvent() public {
        vm.prank(steward);
        vm.expectEmit(true, true, true, true);
        emit PublicMattersCovenant.RestAcknowledged(address(0x5678), "Rest is a right");
        covenant.acknowledgeRest(address(0x5678), "Rest is a right");
    }

    function testDeclarePrincipleEmitsEvent() public {
        vm.prank(steward);
        vm.expectEmit(true, true, true, true);
        emit PublicMattersCovenant.PreservationDeclared("Forgiveness without transaction", steward);
        covenant.declarePrinciple("Forgiveness without transaction");
    }

    function testAddJurisdictionAndVerify() public {
        vm.prank(steward);
        covenant.addJurisdiction("Singapore");
        bool aligned = covenant.isJurisdictionAligned("Singapore");
        assertTrue(aligned, "Jurisdiction should be aligned");
    }

    function testNonStewardCannotRedistribute() public {
        vm.expectRevert("Not authorized");
        covenant.redistribute(address(0x9999), 50, "Shelter");
    }
}
