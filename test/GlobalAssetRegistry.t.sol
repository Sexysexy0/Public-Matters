// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GlobalAssetRegistry.sol";

contract GlobalAssetRegistryTest is Test {
    GlobalAssetRegistry public registry;
    address auditor = address(1);

    function setUp() public {
        vm.prank(auditor);
        registry = new GlobalAssetRegistry();
    }

    function test_TransientMultiSigFlow() public {
        bytes32 assetId = keccak256("asset_one");

        vm.startPrank(auditor);
        registry.initializeAssetBrick(
            assetId,
            GlobalAssetRegistry.AssetType(0),
            63,
            address(0x123),
            1,
            12345
        );
        registry.recordTransientApproval(assetId);
        vm.stopPrank();
        
        uint256 count = registry.getTransientApprovals(assetId);
        assertEq(count, 1);
    }
}
