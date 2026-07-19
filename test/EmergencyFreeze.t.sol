// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/EmergencyFreeze.sol";

contract EmergencyFreezeTest is Test {
    EmergencyFreeze freeze;
    address guardian = address(0xBEEF);

    function setUp() public {
        vm.prank(guardian);
        freeze = new EmergencyFreeze(guardian);
    }

    function testFreezeUnfreezeFlow() public {
        bytes32 id = keccak256(abi.encodePacked("doc-1"));
        vm.prank(guardian);
        freeze.freeze(id);
        assertTrue(freeze.frozen(id));
        vm.prank(guardian);
        freeze.unfreeze(id);
        assertFalse(freeze.frozen(id));
    }

    function testOnlyGuardianCanFreeze() public {
        bytes32 id = keccak256(abi.encodePacked("doc-2"));
        vm.prank(address(0xBAD));
        vm.expectRevert();
        freeze.freeze(id);
    }
}
