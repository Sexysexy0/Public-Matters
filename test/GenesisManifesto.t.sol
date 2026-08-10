// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GenesisManifesto.sol";

contract GenesisManifestoTest is Test {
    GenesisManifesto public genesis;

    function setUp() public {
        genesis = new GenesisManifesto();
    }

    function test_OriginStoredCorrectly() public view {
        assertEq(genesis.originYear(), 2008);
        assertEq(genesis.author(), "Anonymous");
    }
}
