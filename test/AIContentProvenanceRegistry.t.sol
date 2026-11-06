// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIContentProvenanceRegistry.sol";

contract AIContentProvenanceRegistryTest is Test {
    OperatorPrivileges privileges;
    AIContentProvenanceRegistry registry;
    address dev = vm.addr(1);
    address op = vm.addr(2);

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new AIContentProvenanceRegistry(address(privileges));
        privileges.addOperator(op);
    }

    function testRegisterGame() public {
        bytes32 gameId = keccak256("game1");
        vm.prank(dev);
        registry.registerGame(gameId, keccak256("asset1"), 25, "25% AI textures");

        (,, uint256 ai, bool ver,,,) = registry.games(gameId);
        assertEq(ai, 25);
        assertFalse(ver);
    }

    function testVerifyProvenance() public {
        bytes32 gameId = keccak256("game1");
        vm.prank(dev);
        registry.registerGame(gameId, keccak256("asset1"), 0, "100% Human");

        vm.prank(op);
        registry.verifyProvenance(gameId, true);

        (, , , bool ver, , address verifier,) = registry.games(gameId);
        assertTrue(ver);
        assertEq(verifier, op);
    }
}
