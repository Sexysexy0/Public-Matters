// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/ClanTournamentRegistry.sol";

contract DummyEventBoard is IEventBoard {
    event EventPosted(string title, string description);

    function postEvent(string memory _title, string memory _description) external override {
        emit EventPosted(_title, _description);
    }
}

contract ClanTournamentRegistryTest is Test {
    ClanTournamentRegistry registry;
    DummyEventBoard eventBoard;

    function setUp() public {
        eventBoard = new DummyEventBoard();
        registry = new ClanTournamentRegistry(address(eventBoard));
    }

    function testClanWarTournamentFlow() public {
        registry.createClan("ClanX", "PH");
        registry.createClan("ClanY", "JP");

        registry.declareWar("ClanX", "ClanY");
        registry.endWar(0);

        string[] memory participants = new string[](2);
        participants[0] = "ClanX";
        participants[1] = "ClanY";
        registry.createTournament("Championship", participants);
        registry.advanceTournament(0);
        registry.finishTournament(0, "ClanX");

        (string memory name, string memory flag, address leader, uint256 members) = registry.clans("ClanX");
        assertEq(name, "ClanX");
        assertEq(flag, "PH");
        assertEq(members, 1);
        assertEq(leader, address(this));
    }
}
