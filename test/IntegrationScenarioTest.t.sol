// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/MapRegistry.sol";
import "../contracts/EventBoard.sol";

contract IntegrationScenarioTest is Test {
    MapRegistry mapRegistry;
    EventBoard eventBoard;

    function setUp() public {
        mapRegistry = new MapRegistry();
        eventBoard = new EventBoard();
    }

    function test_MapVotingAndEventPosting() public {
        // Add maps
        mapRegistry.addMap("Hospital");
        mapRegistry.addMap("Forest");

        // Vote for Hospital
        mapRegistry.voteMap(0);

        // Winning map should be Hospital
        string memory winning = mapRegistry.getWinningMap();
        assertEq(winning, "Hospital");

        // Post event about the winning map
        eventBoard.postEvent("Map Rotation", string(abi.encodePacked("Winning map is ", winning)));

        // Retrieve event
        (string memory title, string memory desc,) = eventBoard.getEvent(0);
        assertEq(title, "Map Rotation");
        assertEq(desc, "Winning map is Hospital");
    }

    function test_UpdateEventAfterMapChange() public {
        // Add maps
        mapRegistry.addMap("Urban");
        mapRegistry.addMap("Desert");

        // Vote for Desert
        mapRegistry.voteMap(1);
        string memory winning = mapRegistry.getWinningMap();

        // Post initial event
        eventBoard.postEvent("Map Rotation", "Initial winning map");

        // Update event with new winning map
        eventBoard.updateEvent(0, "Map Rotation", string(abi.encodePacked("Winning map is ", winning)));

        // Verify update
        (, string memory desc,) = eventBoard.getEvent(0);
        assertEq(desc, "Winning map is Desert");
    }
}
