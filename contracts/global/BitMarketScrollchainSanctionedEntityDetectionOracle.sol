// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSanctionedEntityDetectionOracle {
    address public steward;
    mapping(string => bool) public flaggedEntities;
    mapping(string => string) public threatType;

    event EntityFlagged(string entity, string threat, uint timestamp);

    function flagEntity(string memory entity, string memory threat) public {
        flaggedEntities[entity] = true;
        threatType[entity] = threat;
        emit EntityFlagged(entity, threat, block.timestamp);
    }

    function isFlagged(string memory entity) public view returns (bool) {
        return flaggedEntities[entity];
    }

    function getThreatType(string memory entity) public view returns (string memory) {
        return threatType[entity];
    }
}
