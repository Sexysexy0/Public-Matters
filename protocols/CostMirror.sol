// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CostMirror: record operating and acquisition costs
contract CostMirror {
    struct CostProfile {
        uint256 id;
        string model;
        uint256 acquisitionCost; // USD millions
        uint256 operatingCost;   // USD per flight hour
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => CostProfile) public costs;
    mapping(address => bool) public stewards;

    event CostLogged(uint256 indexed id, string model, uint256 acquisitionCost);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCost(string calldata model, uint256 acquisitionCost, uint256 operatingCost) external {
        require(stewards[msg.sender], "Only steward");
        costs[nextId] = CostProfile(nextId, model, acquisitionCost, operatingCost, block.timestamp);
        emit CostLogged(nextId, model, acquisitionCost);
        nextId++;
    }
}
