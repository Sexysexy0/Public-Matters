// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GenesisManifesto.sol";

contract GenesisManifestoTest is Test {
    GenesisManifesto public manifesto;

    string constant ORIGIN = "2008: digital money without a middleman. A compounding graph. The seed of a sovereign system.";

    function setUp() public {
        manifesto = new GenesisManifesto(ORIGIN);
    }

    function test_OriginStoredCorrectly() public {
        (string memory manifest, uint256 timestamp, address author) = manifesto.getManifest();
        assertEq(manifest, ORIGIN);
        assertEq(author, address(this));
        assertTrue(timestamp > 0);
    }
}
