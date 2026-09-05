// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./SniperRegistry.sol";

contract SniperRegistryTest is Test {
    SniperRegistry registry;

    function setUp() public {
        registry = new SniperRegistry();
    }

    function testCreateAndJoinMatchWithServer() public {
        registry.createMatch("Urban Rooftops", true, "Asia");
        registry.joinMatch(0);

        address[] memory players = registry.getMatchPlayers(0);
        assertEq(players.length, 1);
        assertEq(players[0], address(this));
    }

    function testRegisterUpdateRankPingAndBadge() public {
        registry.registerPlayer("Vinvin", 1, "ClanX", "PH");
        registry.updateRank(5);
        registry.checkPing(42);
        registry.assignBadge("Pro Sniper");

        (string memory name, uint256 rank, string memory clan, string memory flag, uint256 ping, string memory badge) =
            registry.players(address(this));

        assertEq(name, "Vinvin");
        assertEq(rank, 5);
        assertEq(clan, "ClanX");
        assertEq(flag, "PH");
        assertEq(ping, 42);
        assertEq(badge, "Pro Sniper");
    }
}
