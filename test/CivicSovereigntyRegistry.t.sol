// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/CivicSovereigntyRegistry.sol";

contract CivicSovereigntyRegistryTest is Test {
    OperatorPrivileges privileges;
    CivicSovereigntyRegistry civic;

    address op = vm.addr(1);
    address citizen = vm.addr(2);
    bytes32 constant ID_HASH = keccak256("PH-ID-123456789+salt");
    bytes32 constant REGION_HASH = keccak256("Barangay-123");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        civic = new CivicSovereigntyRegistry(address(privileges));
    }

    function testRegisterCitizen() public {
        vm.prank(citizen);
        civic.registerCitizen(ID_HASH, REGION_HASH);

        CivicSovereigntyRegistry.Citizen memory c = civic.getCitizen(citizen);
        assertEq(c.identityHash, ID_HASH);
        assertEq(c.civicScore, 100);
        assertTrue(c.isRegistered);
        assertEq(civic.populationByRegion(REGION_HASH), 1);
    }

    function testCannotRegisterTwice() public {
        vm.startPrank(citizen);
        civic.registerCitizen(ID_HASH, REGION_HASH);
        vm.expectRevert("Already registered");
        civic.registerCitizen(ID_HASH, REGION_HASH);
        vm.stopPrank();
    }

    function testOperatorUpdatesCivicScore() public {
        vm.prank(citizen);
        civic.registerCitizen(ID_HASH, REGION_HASH);

        vm.prank(op);
        civic.updateCivicScore(citizen, 150, "Community Service");

        CivicSovereigntyRegistry.Citizen memory c = civic.getCitizen(citizen);
        assertEq(c.civicScore, 150);
    }

    function testStrangerCannotUpdateScore() public {
        vm.prank(citizen);
        civic.registerCitizen(ID_HASH, REGION_HASH);

        vm.prank(citizen); // Not an operator
        vm.expectRevert("Not authorized operator");
        civic.updateCivicScore(citizen, 0, "Malicious Update");
    }
}
