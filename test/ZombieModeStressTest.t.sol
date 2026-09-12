// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/ZombieModeRegistry.sol";

contract DummyEventBoard is IEventBoard {
    event EventPosted(string title, string description);

    function postEvent(string memory _title, string memory _description) external override {
        emit EventPosted(_title, _description);
    }
}

contract ZombieModeStressTest is Test {
    ZombieModeRegistry registry;
    DummyEventBoard eventBoard;

    function setUp() public {
        eventBoard = new DummyEventBoard();
        registry = new ZombieModeRegistry(address(eventBoard));
    }

    function testMultiPlayerZombieScenario() public {
        registry.createZombieMatch(20, 10);
        for (uint256 i = 0; i < 20; i++) {
            // forge-lint: disable-next-line(unsafe-typecast)
            address player = address(uint160(i + 1)); // forge-lint: disable-next-line(unsafe-typecast)
            registry.infectPlayer(player);
        }
        registry.finishMatch(0);
    }
}
