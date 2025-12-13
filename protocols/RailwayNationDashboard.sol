// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RailwayNationDashboard: aggregate orchestrator + analytics outputs
contract RailwayNationDashboard {
    address public steward;

    struct ExpansionSummary {
        uint256 id;
        string route;
        uint256 distance;
        uint256 cost;
        uint256 avgCostPerKm;
        uint256 terrainChallenges;
        uint256 impacts;
        string classification;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => ExpansionSummary) public summaries;
    mapping(address => bool) public stewards;

    event SummaryLogged(uint256 indexed id, string route, string classification);

    constructor() { 
        steward = msg.sender; 
        stewards[steward] = true; 
    }

    function addSteward(address s) external {
        require(msg.sender == steward, "Only steward");
        stewards[s] = true;
    }

    function logSummary(
        string calldata route,
        uint256 distance,
        uint256 cost,
        uint256 avgCostPerKm,
        uint256 terrainChallenges,
        uint256 impacts,
        string calldata classification
    ) external {
        require(stewards[msg.sender], "Only steward");
        summaries[nextId] = ExpansionSummary(
            nextId,
            route,
            distance,
            cost,
            avgCostPerKm,
            terrainChallenges,
            impacts,
            classification,
            block.timestamp
        );
        emit SummaryLogged(nextId, route, classification);
        nextId++;
    }

    // Compute comparative ranking by cost per km
    function rankByCostPerKm() external view returns (string memory bestRoute) {
        if (nextId == 0) return "No Records";
        uint256 lowest = type(uint256).max;
        for (uint256 i = 0; i < nextId; i++) {
            if (summaries[i].avgCostPerKm < lowest) {
                lowest = summaries[i].avgCostPerKm;
                bestRoute = summaries[i].route;
            }
        }
    }

    // Compute comparative ranking by impacts
    function rankByImpacts() external view returns (string memory bestRoute) {
        if (nextId == 0) return "No Records";
        uint256 highest = 0;
        for (uint256 i = 0; i < nextId; i++) {
            if (summaries[i].impacts > highest) {
                highest = summaries[i].impacts;
                bestRoute = summaries[i].route;
            }
        }
    }
}
