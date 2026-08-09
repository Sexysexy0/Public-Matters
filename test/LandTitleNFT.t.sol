// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/LandTitleNFT.sol";

contract LandTitleNFTTest is Test {
    LandTitleNFT public land;

    address public owner = address(this);
    address public citizen1 = makeAddr("citizen1");

    function setUp() public {
        land = new LandTitleNFT();
    }

    function test_IssueAndTransferTitle() public {
        bytes32 hash = keccak256(abi.encodePacked("TitleDocument123"));

        // Issue title to citizen1
        uint256 tokenId = land.issueTitle(citizen1, "Barangay San Juan", "Lot-42A", hash);

        (string memory location, string memory lot, bytes32 docHash, address currentOwner, ) = land.getTitle(tokenId);

        assertEq(location, "Barangay San Juan");
        assertEq(lot, "Lot-42A");
        assertEq(docHash, hash);
        assertEq(currentOwner, citizen1);

        // Transfer title
        vm.prank(citizen1);
        land.transferTitle(owner, tokenId);

        (, , , currentOwner, ) = land.getTitle(tokenId);
        assertEq(currentOwner, owner);
    }
}
