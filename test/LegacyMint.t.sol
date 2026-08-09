// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/LegacyMint.sol";

contract LegacyMintTest is Test {
    LegacyMint public legacy;

    address public emperor = address(this);
    address public receiver = makeAddr("receiver");

    function setUp() public {
        bytes32 hash = keccak256(abi.encodePacked("Genesis Manifesto"));
        legacy = new LegacyMint(hash, "The Bridge is open.");
    }

    function test_MintAndOwnership() public {
        uint256 tokenId = legacy.mintBridge(receiver);
        assertEq(legacy.ownerOf(tokenId), receiver);
        assertEq(legacy.nextTokenId(), 1);
    }
}
