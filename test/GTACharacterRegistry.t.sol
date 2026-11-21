// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {GTACharacterRegistry} from "../contracts/GTACharacterRegistry.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;
    function setOperator(address a, bool v) external { ops[a] = v; }
    function isOperator(address a) external view returns (bool) { return ops[a]; }
}

contract GTACharacterRegistryTest is Test {
    GTACharacterRegistry registry;
    MockOperatorPrivileges opv;
    address operator = address(0xB0b);
    address player = address(0xC1c);
    address governance = address(0xD2d);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        registry = new GTACharacterRegistry(address(opv), governance);
        opv.setOperator(operator, true);
    }

    function test_CreateCharacter() public {
        vm.prank(player);
        registry.createCharacter("Franklin");
        (string memory name, uint256 level, uint256 xp, uint256 cash, uint256 wanted, bool active) = registry.getCharacter(player);
        assertEq(name, "Franklin");
        assertEq(level, 1);
        assertEq(xp, 0);
        assertEq(wanted, 0);
        assertTrue(active);
    }

    function test_AddXp() public {
        vm.prank(player);
        registry.createCharacter("Franklin");
        vm.prank(operator);
        registry.addXp(player, 50);
        (, , uint256 xp, , , ) = registry.getCharacter(player);
        assertEq(xp, 50);
    }

    function test_UpdateCash() public {
        vm.prank(player);
        registry.createCharacter("Franklin");
        (, , , uint256 cashBefore, , ) = registry.getCharacter(player);
        vm.prank(operator);
        registry.updateCash(player, 10 ether);
        (, , , uint256 cashAfter, , ) = registry.getCharacter(player);
        assertEq(cashAfter, cashBefore + 10 ether);
    }

    function test_SetWantedLevel() public {
        vm.prank(player);
        registry.createCharacter("Franklin");
        vm.prank(operator);
        registry.setWantedLevel(player, 3);
        (, , , , uint256 wanted, ) = registry.getCharacter(player);
        assertEq(wanted, 3);
    }

    function test_DeactivateCharacter() public {
        vm.prank(player);
        registry.createCharacter("Franklin");
        vm.prank(operator);
        registry.deactivateCharacter(player);
        (, , , , , bool active) = registry.getCharacter(player);
        assertFalse(active);
    }

    function test_NonOperatorReverts() public {
        vm.prank(player);
        registry.createCharacter("Franklin");
        vm.prank(player);
        vm.expectRevert();
        registry.addXp(player, 50);
    }
}
