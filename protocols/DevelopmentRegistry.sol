// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// DevelopmentRegistry: record LGU redevelopment plans
contract DevelopmentRegistry {
    struct Plan {
        uint256 id;
        string zone;
        string type;        // "Housing", "Retail", "Transport Hub"
        uint256 budget;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Plan) public plans;
    mapping(address => bool) public stewards;

    event PlanLogged(uint256 indexed id, string zone, string type, uint256 budget);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPlan(string calldata zone, string calldata type, uint256 budget) external {
        require(stewards[msg.sender], "Only steward");
        plans[nextId] = Plan(nextId, zone, type, budget, block.timestamp);
        emit PlanLogged(nextId, zone, type, budget);
        nextId++;
    }
}
