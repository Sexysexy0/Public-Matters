// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/ShipAutoPilotRegistry.sol";
import "../src/BarberRegistry.sol";

contract GameplayFeaturesTest is Test {
    OperatorPrivileges privileges;
    ShipAutoPilotRegistry autopilot;
    BarberRegistry barber;

    address op = vm.addr(1);
    bytes32 constant SHIP = keccak256("The Black Pearl");
    bytes32 constant DESTINATION = keccak256("Port of Pywel");
    bytes32 constant CHAR = keccak256("Kliff");
    bytes32 constant STYLE = keccak256("Buzz Cut");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        
        autopilot = new ShipAutoPilotRegistry(address(privileges));
        barber = new BarberRegistry(address(privileges));
    }

    function testEngageAutoPilot() public {
        vm.prank(op);
        autopilot.setDestination(SHIP, DESTINATION);
        
        ShipAutoPilotRegistry.AutoPilot memory ap = autopilot.getAutoPilot(SHIP);
        assertTrue(ap.isEngaged);
        assertEq(ap.destinationHash, DESTINATION);
    }

    function testDisengageAutoPilot() public {
        vm.startPrank(op);
        autopilot.setDestination(SHIP, DESTINATION);
        autopilot.disengageAutoPilot(SHIP);
        vm.stopPrank();
        
        ShipAutoPilotRegistry.AutoPilot memory ap = autopilot.getAutoPilot(SHIP);
        assertFalse(ap.isEngaged);
    }

    function testApplyHaircut() public {
        vm.startPrank(op);
        barber.addHairStyle(STYLE, 50 ether);
        barber.applyHaircut(CHAR, STYLE);
        vm.stopPrank();
        
        assertEq(barber.currentStyle(CHAR), STYLE);
    }
}
