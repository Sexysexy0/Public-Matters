// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameUtilityAndAuditRegistry.sol";

contract GameUtilityAndAuditRegistryTest is Test {
    GameUtilityAndAuditRegistry public registry;

    address owner = address(1);
    bytes32 craftId = keccak256("craft_01");

    function setUp() public {
        vm.prank(owner);
        registry = new GameUtilityAndAuditRegistry();
    }

    function test_AttestHumanCraft() public {
        vm.prank(owner);
        registry.attestHumanCraft(craftId, "human_art", keccak256("metadata"));
        assertTrue(true);
    }

    function test_LogInternalUtility() public {
        vm.prank(owner);
        registry.logInternalUtility(craftId, GameUtilityAndAuditRegistry.UtilityType(0), keccak256("details"));
        assertTrue(true);
    }

    function test_RevertWhen_NonOwnerAttestsCraft() public {
        vm.prank(address(99));
        vm.expectRevert();
        registry.attestHumanCraft(craftId, "craft", keccak256("metadata"));
    }
}
