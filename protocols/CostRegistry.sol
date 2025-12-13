// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CostRegistry: record estimated costs for extensions
contract CostRegistry {
    struct Cost {
        uint256 id;
        string route;
        uint256 estimate;   // in PHP millions
        string source;      // "DOTr", "NEDA", "Feasibility Study"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Cost) public costs;
    mapping(address => bool) public stewards;

    event CostLogged(uint256 indexed id, string route, uint256 estimate);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCost(string calldata route, uint256 estimate, string calldata source) external {
        require(stewards[msg.sender], "Only steward");
        costs[nextId] = Cost(nextId, route, estimate, source, block.timestamp);
        emit CostLogged(nextId, route, estimate);
        nextId++;
    }
}
