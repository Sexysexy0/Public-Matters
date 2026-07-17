// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/IPClaimRegistry.sol";

contract IPClaimRegistryTest is Test {
    IPClaimRegistry public registry;
    address public guardianWallet = address(0x1111);
    address public assetOwner = address(0x2222);
    address public thirdPartyUser = address(0x3333);

    // Inayos mula dummyIPHash patungong camelCase mixedCase style requirement
    bytes32 public dummyIpHash = keccak256(abi.encodePacked("MASTER_KEY_CORE_LOGIC"));

    function setUp() public {
        vm.prank(guardianWallet);
        registry = new IPClaimRegistry();
    }

    function test_RegisterAndVerifyAsset() public {
        vm.prank(assetOwner);
        uint256 claimId = registry.registerAssetClaim(dummyIpHash, "PS3 Core Firmware Derivative");
        assertEq(claimId, 1);

        vm.prank(thirdPartyUser);
        vm.expectRevert("Error: Access denied. Only the Guardian can alter asset metrics.");
        registry.verifyAssetClaim(1, true);

        vm.prank(guardianWallet);
        registry.verifyAssetClaim(1, true);

        (,,,, bool isVerified,) = registry.claims(1);
        assertTrue(isVerified);
    }

    function test_AccessControlDelegation() public {
        vm.prank(assetOwner);
        uint256 claimId = registry.registerAssetClaim(dummyIpHash, "PS3 Core Firmware Derivative");

        vm.prank(thirdPartyUser);
        vm.expectRevert("Error: Access denied. You are not the registered owner of this asset.");
        registry.grantAccess(claimId, thirdPartyUser);

        vm.prank(assetOwner);
        registry.grantAccess(claimId, thirdPartyUser);
        assertTrue(registry.checkAuthorization(dummyIpHash, thirdPartyUser));

        vm.prank(assetOwner);
        registry.revokeAccess(claimId, thirdPartyUser);
        assertFalse(registry.checkAuthorization(dummyIpHash, thirdPartyUser));
    }
}
