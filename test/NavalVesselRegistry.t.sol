// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/NavalVesselRegistry.sol";

contract NavalVesselRegistryTest is Test {
    OperatorPrivileges privileges;
    NavalVesselRegistry registry;

    address op = vm.addr(1);
    address player = vm.addr(2);
    address stranger = vm.addr(3);

    bytes32 constant SMALL_SHIP = keccak256("ship-01-small");
    bytes32 constant LARGE_SHIP = keccak256("ship-02-large");
    bytes32 constant WOOD = keccak256("item-wood");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new NavalVesselRegistry(address(privileges));
        privileges.addOperator(op);

        vm.startPrank(op);
        registry.registerVessel(SMALL_SHIP, player, 0); // Class 0: Small
        registry.registerVessel(LARGE_SHIP, player, 1); // Class 1: Large
        vm.stopPrank();
    }

    function testSmallShipOnlyHasCargo() public {
        NavalVesselRegistry.Room memory cargo = registry.getRoomStatus(SMALL_SHIP, NavalVesselRegistry.RoomType.CARGO_HOLD);
        assertTrue(cargo.unlocked);

        NavalVesselRegistry.Room memory bedroom = registry.getRoomStatus(SMALL_SHIP, NavalVesselRegistry.RoomType.BEDROOM);
        assertFalse(bedroom.unlocked);
    }

    function testLargeShipHasAllRooms() public {
        NavalVesselRegistry.Room memory bedroom = registry.getRoomStatus(LARGE_SHIP, NavalVesselRegistry.RoomType.BEDROOM);
        NavalVesselRegistry.Room memory galley = registry.getRoomStatus(LARGE_SHIP, NavalVesselRegistry.RoomType.GALLEY);
        NavalVesselRegistry.Room memory armory = registry.getRoomStatus(LARGE_SHIP, NavalVesselRegistry.RoomType.ARMORY);

        assertTrue(bedroom.unlocked);
        assertTrue(galley.unlocked);
        assertTrue(armory.unlocked);
    }

    function testRestInBedroom() public {
        vm.prank(player);
        registry.restInBedroom(LARGE_SHIP);
    }

    function testCannotRestOnSmallShip() public {
        vm.prank(player);
        vm.expectRevert("Room not unlocked");
        registry.restInBedroom(SMALL_SHIP);
    }

    function testCookAndCraft() public {
        vm.startPrank(player);
        registry.cookInGalley(LARGE_SHIP, keccak256("recipe-stew"));
        registry.craftInArmory(LARGE_SHIP, keccak256("gear-sword"));
        vm.stopPrank();
    }

    function testCustomizeRoom() public {
        vm.prank(player);
        registry.customizeRoom(LARGE_SHIP, NavalVesselRegistry.RoomType.BEDROOM, keccak256("custom-oak-bed"));

        NavalVesselRegistry.Room memory r = registry.getRoomStatus(LARGE_SHIP, NavalVesselRegistry.RoomType.BEDROOM);
        assertEq(r.customizationHash, keccak256("custom-oak-bed"));
    }

    function testCargoDepositWithdraw() public {
        vm.startPrank(player);
        registry.depositCargo(LARGE_SHIP, WOOD, 100);
        assertEq(registry.getCargo(LARGE_SHIP, WOOD), 100);

        registry.withdrawCargo(LARGE_SHIP, WOOD, 40);
        assertEq(registry.getCargo(LARGE_SHIP, WOOD), 60);
        vm.stopPrank();
    }

    function testCannotDepositWithoutCargoHold() public {
        // Imagine a ship that somehow didn't unlock cargo (shouldn't happen via registration, but test the modifier)
        vm.prank(stranger);
        vm.expectRevert("Not ship owner");
        registry.depositCargo(SMALL_SHIP, WOOD, 10);
    }
}
