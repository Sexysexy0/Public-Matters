// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/TransparencyRegistry.sol";

contract TransparencyRegistryTest is Test {
    TransparencyRegistry registry;
    address contractor = address(0xBEEF);
    address declarant = address(0xCAFE);

    function setUp() public {
        vm.prank(contractor);
        registry = new TransparencyRegistry();
    }

    function testDeclareAssetEmitsEvent() public {
        vm.prank(declarant);
        vm.expectEmit(true, true, true, true);
        emit TransparencyRegistry.AssetDeclared(1, declarant, "RealEstate", 1000, false);
        registry.declareAsset("RealEstate", 1000);
    }

    function testDeclarationStoredCorrectly() public {
        vm.prank(declarant);
        uint256 id = registry.declareAsset("Crypto", 500);
        TransparencyRegistry.Declaration memory d = registry.getDeclaration(id);
        assertEq(d.declarant, declarant);
        assertEq(d.assetType, "Crypto");
        assertEq(d.value, 500);
        assertFalse(d.verified);
    }

    function testOnlyContractorCanVerify() public {
        vm.prank(declarant);
        uint256 id = registry.declareAsset("Art", 200);

        // Non-contractor should revert
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        vm.prank(declarant);
        registry.verifyDeclaration(id);

        // Contractor can verify
        vm.prank(contractor);
        registry.verifyDeclaration(id);
        TransparencyRegistry.Declaration memory d = registry.getDeclaration(id);
        assertTrue(d.verified);
    }
}
