// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ContentOwnershipRegistry.sol";

contract ContentOwnershipRegistryTest is Test {
    ContentOwnershipRegistry public registry;

    address public owner = address(this);
    address public creator = makeAddr("creator");
    address public buyer1 = makeAddr("buyer1");
    address public buyer2 = makeAddr("buyer2");

    function setUp() public {
        registry = new ContentOwnershipRegistry();
    }

    function test_RegisterAndBuyWithRoyalty() public {
        uint256 tokenId =
            registry.registerContent("Lord of the Rings", "Tolkien", "ipfs://QmHash", 1 ether, 500, payable(creator));

        // --- First purchase ---
        vm.deal(buyer1, 2 ether);
        uint256 buyer1BalanceBefore = buyer1.balance;

        vm.prank(buyer1);
        registry.buyContent{value: 1 ether}(tokenId);

        // Buyer1 spent 1 ETH
        assertEq(buyer1.balance, buyer1BalanceBefore - 1 ether);
        // Creator received 1 ETH (royalty 0.05 + seller proceeds 0.95)
        assertEq(creator.balance, 1 ether);
        assertEq(registry.ownerOf(tokenId), buyer1);

        // --- Second purchase ---
        vm.deal(buyer2, 2 ether);
        uint256 buyer2BalanceBefore = buyer2.balance;
        uint256 creatorBalanceBefore2 = creator.balance;

        vm.prank(buyer2);
        registry.buyContent{value: 1 ether}(tokenId);

        // Buyer2 spent 1 ETH
        assertEq(buyer2.balance, buyer2BalanceBefore - 1 ether);
        // Creator received an additional 0.05 ETH (royalty only, because seller is buyer1)
        assertEq(creator.balance, creatorBalanceBefore2 + 0.05 ether);
        assertEq(registry.ownerOf(tokenId), buyer2);
    }
}
