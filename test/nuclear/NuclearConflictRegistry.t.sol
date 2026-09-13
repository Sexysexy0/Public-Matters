// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";

contract NuclearConflictRegistryTest is Test {
    NuclearConflictRegistry registry;

    address declarant = address(0xBEEF);
    address outsider = address(0xCAFE);

    bytes32 constant SUBJECT = keccak256("G0 demand validation");
    bytes32 constant DISCLOSURE = keccak256("disclosure-1");

    function setUp() public {
        registry = new NuclearConflictRegistry();
    }

    function testDeclareConflict() public {
        vm.prank(declarant);
        uint256 id = registry.declareConflict(SUBJECT, DISCLOSURE, 0);

        assertTrue(registry.isConflicted(declarant, SUBJECT));

        NuclearConflictRegistry.Conflict memory conflict =
            registry.getConflict(id);

        assertEq(conflict.declarant, declarant);
        assertEq(conflict.subject, SUBJECT);
        assertEq(conflict.disclosureHash, DISCLOSURE);
        assertTrue(conflict.active);
    }

    function testDuplicateActiveConflictBlocked() public {
        vm.startPrank(declarant);
        registry.declareConflict(SUBJECT, DISCLOSURE, 0);

        vm.expectRevert(NuclearConflictRegistry.AlreadyExists.selector);
        registry.declareConflict(SUBJECT, keccak256("disclosure-2"), 0);
        vm.stopPrank();
    }

    function testDeclarantCanRevokeConflict() public {
        vm.prank(declarant);
        uint256 id = registry.declareConflict(SUBJECT, DISCLOSURE, 0);

        vm.prank(declarant);
        registry.revokeConflict(id);

        assertFalse(registry.isConflicted(declarant, SUBJECT));
    }

    function testOutsiderCannotRevokeConflict() public {
        vm.prank(declarant);
        uint256 id = registry.declareConflict(SUBJECT, DISCLOSURE, 0);

        vm.expectRevert(NuclearConflictRegistry.Unauthorized.selector);
        vm.prank(outsider);
        registry.revokeConflict(id);
    }

    function testConflictExpires() public {
        uint64 expiry = uint64(block.timestamp + 1 days);

        vm.prank(declarant);
        uint256 id = registry.declareConflict(SUBJECT, DISCLOSURE, expiry);

        vm.warp(expiry);

        assertFalse(registry.isConflicted(declarant, SUBJECT));

        registry.expireConflict(id);

        NuclearConflictRegistry.Conflict memory conflict =
            registry.getConflict(id);

        assertFalse(conflict.active);
    }

    function testUnexpiredConflictCannotBeExpired() public {
        uint64 expiry = uint64(block.timestamp + 1 days);

        vm.prank(declarant);
        uint256 id = registry.declareConflict(SUBJECT, DISCLOSURE, expiry);

        vm.expectRevert(NuclearConflictRegistry.InvalidInput.selector);
        registry.expireConflict(id);
    }

    function testAdministratorCanRevokeConflict() public {
        vm.prank(declarant);
        uint256 id = registry.declareConflict(SUBJECT, DISCLOSURE, 0);

        registry.revokeConflict(id);

        assertFalse(registry.isConflicted(declarant, SUBJECT));
    }
}
