// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/MapRegistry.sol";

contract MapRegistryTest is Test {
    MapRegistry registry;

    function setUp() public {
        registry = new MapRegistry();
    }

    function testAddMap() public {
        registry.addMap("Hospital");
        string memory winning = registry.getWinningMap();
        assertEq(winning, "Hospital");
    }

    function testVoteMap() public {
        registry.addMap("Forest");
        registry.voteMap(0);
        string memory winning = registry.getWinningMap();
        assertEq(winning, "Forest");
    }
}
