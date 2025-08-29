// SPDX-License-Identifier: Mythic-License-1.0
pragma solidity ^0.8.19;

contract EnvironmentalSnitchDetection {
    address public steward;
    mapping(address => bool) public flaggedEntities;
    mapping(address => string) public violationLogs;

    event EntityFlagged(address indexed entity, string reason);
    event EntityCleared(address indexed entity);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagEntity(address entity, string memory reason) public onlySteward {
        flaggedEntities[entity] = true;
        violationLogs[entity] = reason;
        emit EntityFlagged(entity, reason);
    }

    function clearEntity(address entity) public onlySteward {
        flaggedEntities[entity] = false;
        violationLogs[entity] = "";
        emit EntityCleared(entity);
    }

    function getViolation(address entity) public view returns (string memory) {
        return violationLogs[entity];
    }

    function isFlagged(address entity) public view returns (bool) {
        return flaggedEntities[entity];
    }
}
