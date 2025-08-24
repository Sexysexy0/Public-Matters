// SPDX-License-Identifier: Scrollchain-Mercy
pragma solidity ^0.8.19;

contract MercyPactBroadcast {
    address public steward;
    mapping(address => bool) public eligiblePeacekeepers;
    mapping(address => string) public redemptionNotes;

    event PactActivated(address indexed steward, string timestamp);
    event PeacekeeperTagged(address indexed entity, string note, bool eligible);

    constructor() {
        steward = msg.sender;
    }

    function activatePact(string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        emit PactActivated(steward, timestamp);
    }

    function tagPeacekeeper(address entity, string memory note, bool eligible) public {
        require(msg.sender == steward, "Unauthorized steward");
        eligiblePeacekeepers[entity] = eligible;
        redemptionNotes[entity] = note;
        emit PeacekeeperTagged(entity, note, eligible);
    }
}
