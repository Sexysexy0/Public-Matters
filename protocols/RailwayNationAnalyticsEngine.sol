// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RailwayNationAnalyticsEngine: compute averages and trends for national railway expansion
contract RailwayNationAnalyticsEngine {
    address public steward;

    struct Record {
        uint256 id;
        string route;
        uint256 distance;   // kilometers
        uint256 cost;       // PHP millions
        uint256 terrainChallenges; // count of challenges
        uint256 impacts;    // count of impacts recorded
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Record) public records;
    mapping(address => bool) public stewards;

    event RecordLogged(uint256 indexed id, string route, uint256 distance, uint256 cost);

    constructor() { 
        steward = msg.sender; 
        stewards[steward] = true; 
    }

    function addSteward(address s) external {
        require(msg.sender == steward, "Only steward");
        stewards[s] = true;
    }

    function logRecord(
        string calldata route,
        uint256 distance,
        uint256 cost,
        uint256 terrainChallenges,
        uint256 impacts
    ) external {
        require(stewards[msg.sender], "Only steward");
        records[nextId] = Record(nextId, route, distance, cost, terrainChallenges, impacts, block.timestamp);
        emit RecordLogged(nextId, route, distance, cost);
        nextId++;
    }

    // Compute average cost per km
    function averageCostPerKm() external view returns (uint256 avg) {
        if (nextId == 0) return 0;
        uint256 totalCost = 0;
        uint256 totalDistance = 0;
        for (uint256 i = 0; i < nextId; i++) {
            totalCost += records[i].cost;
            totalDistance += records[i].distance;
        }
        if (totalDistance == 0) return 0;
        avg = totalCost / totalDistance;
    }

    // Compute terrain challenge ratio
    function terrainChallengeRatio() external view returns (uint256 ratio) {
        if (nextId == 0) return 0;
        uint256 totalChallenges = 0;
        for (uint256 i = 0; i < nextId; i++) {
            totalChallenges += records[i].terrainChallenges;
        }
        ratio = totalChallenges / nextId;
    }

    // Compute average impacts recorded
    function averageImpacts() external view returns (uint256 avgImpacts) {
        if (nextId == 0) return 0;
        uint256 totalImpacts = 0;
        for (uint256 i = 0; i < nextId; i++) {
            totalImpacts += records[i].impacts;
        }
        avgImpacts = totalImpacts / nextId;
    }
}
