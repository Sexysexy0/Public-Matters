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

contract SniperBattleStressTest is Test {
    SniperBattleRegistry registry;
    DummyEventBoard eventBoard;
    address[] agents;

    function setUp() public {
        // prepare allowed maps array and pass it to constructor
        string[] memory maps = new string[](2);
        maps[0] = "Desert Dunes";
        maps[1] = "Forest Ridge";

        eventBoard = new DummyEventBoard();
        registry = new SniperBattleRegistry(address(eventBoard), maps);

        for (uint256 i = 0; i < 12; i++) {
            agents.push(address(uint160(i + 1)));
        }
    }

    function testMultiAgentScenario() public {
        // create match with explicit maxPlayers (12)
        registry.createMatch("Desert Dunes", true, "EU", 12);

        for (uint256 i = 0; i < agents.length; i++) {
            vm.prank(agents[i]);
            registry.registerPlayer(string(abi.encodePacked("Agent", uintToString(i))), i, "ClanZ", "PH");

            vm.prank(agents[i]);
            registry.joinMatch(0);

            vm.prank(agents[i]);
            registry.updateRank(i + 10);

            vm.prank(agents[i]);
            registry.checkPing(50 + i);

            vm.prank(agents[i]);
            registry.assignBadge("SniperBadge");
        }

        address[] memory players = registry.getMatchPlayers(0);
        assertEq(players.length, agents.length);
    }

    function uintToString(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 j = v;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = v;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
