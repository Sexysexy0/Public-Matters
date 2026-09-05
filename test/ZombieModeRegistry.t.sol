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

contract ZombieModeRegistryTest is Test {
    ZombieModeRegistry registry;
    DummyEventBoard eventBoard;

    function setUp() public {
        eventBoard = new DummyEventBoard();
        registry = new ZombieModeRegistry(address(eventBoard));
    }

    function testZombieMatchFlow() public {
        registry.createZombieMatch(30, 5);
        registry.infectPlayer(address(this));
        registry.finishMatch(0);

        ZombieModeRegistry.ZombieType zType = registry.infected(address(this));
        assertTrue(uint256(zType) <= 3);
    }
}
