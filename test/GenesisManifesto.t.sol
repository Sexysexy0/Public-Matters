// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GenesisManifesto.sol";

contract GenesisManifestoTest is Test {
    GenesisManifesto public genesis;
    address public deployer = address(this);

    function setUp() public {
        genesis = new GenesisManifesto("The 2008 Origin Story");
    }

    function test_OriginStoredCorrectly() public view {
        (string memory manifest, uint256 timestamp, address author) = genesis.getManifest();
        assertEq(manifest, "The 2008 Origin Story");
        assertEq(timestamp, block.timestamp);
        assertEq(author, deployer);
    }
}
