// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./SniperBattleRegistry.sol";

contract DummyEventBoard is IEventBoard {
    event EventPosted(string title, string description);
    function postEvent(string memory _title, string memory _description) external override {
        emit EventPosted(_title, _description);
    }
}

contract SniperBattleRegistryTest is Test {
    SniperBattleRegistry registry;
    DummyEventBoard eventBoard;

    function setUp() public {
        string[] memory maps = new string[](4);
        maps[0] = "Urban Rooftops";
        maps[1] = "Desert Dunes";
        maps[2] = "Forest Ridge";
        maps[3] = "Hospital Courtyard";
        eventBoard = new DummyEventBoard();
        registry = new SniperBattleRegistry(address(eventBoard), maps);
    }

    function testCreateJoinLeaveAndProfileFlow() public {
        // create match with maxPlayers 5
        registry.createMatch("Urban Rooftops", true, "Asia", 5);
        // register and join
        registry.registerPlayer("Vinvin", 1, "ClanX", "PH");
        registry.joinMatch(0);
        address[] memory players = registry.getMatchPlayers(0);
        assertEq(players.length, 1);
        // update rank, ping, badge, clan flag
        registry.updateRank(10);
        registry.checkPing(30);
        registry.assignBadge("Pro Sniper");
        registry.updateClanFlag("ClanElite", "JP");
        (string memory name, uint256 rank, string memory clan, string memory flag, uint256 ping, string memory badge, bool reg) =
            registry.players(address(this));
        assertEq(name, "Vinvin");
        assertEq(rank, 10);
        assertEq(clan, "ClanElite");
        assertEq(flag, "JP");
        assertEq(ping, 30);
        assertEq(badge, "Pro Sniper");
        assertEq(reg, true);
        // leave match
        registry.leaveMatch(0);
        players = registry.getMatchPlayers(0);
        assertEq(players.length, 0);
    }
}
