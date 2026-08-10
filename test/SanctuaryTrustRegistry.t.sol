// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SanctuaryTrustRegistry.sol";

contract SanctuaryTrustRegistryTest is Test {
    SanctuaryTrustRegistry registry;
    address sanctuaryOwner = address(0x1);
    address randomStranger = address(0x2);
    address permittedFriend = address(0x3);

    function setUp() public {
        registry = new SanctuaryTrustRegistry();
    }

    function test_SanctuaryConfiguration() public {
        vm.prank(sanctuaryOwner);
        registry.setSanctuaryState(true, 60 seconds);
        
        (bool active, uint256 cooldown,) = registry.nodes(sanctuaryOwner);
        assertTrue(active);
        assertEq(cooldown, 60 seconds);
    }

    function test_RevertWhenUnauthorizedPeerAccesses() public {
        vm.prank(sanctuaryOwner);
        registry.setSanctuaryState(true, 0);

        vm.prank(randomStranger);
        vm.expectRevert(SanctuaryTrustRegistry.UnauthorizedPeer.selector);
        registry.sendSignal(sanctuaryOwner, keccak256("NOISE"));
    }

    function test_SuccessfulPermittedSignal() public {
        vm.startPrank(sanctuaryOwner);
        registry.setSanctuaryState(true, 0);
        registry.grantAccess(permittedFriend);
        vm.stopPrank();

        vm.prank(permittedFriend);
        registry.sendSignal(sanctuaryOwner, keccak256("CLEAN_SIGNAL"));
    }
}
