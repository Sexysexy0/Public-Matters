// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// StablecoinRiskRegistry: record risks and lawsuits tied to stablecoins
contract StablecoinRiskRegistry {
    struct Risk {
        uint256 id;
        string allegation;  // "Shadow Trading"
        string impact;      // "Artificial Price Support"
        uint256 value;      // e.g. 4000000000 (lawsuit amount)
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Risk) public risks;
    mapping(address => bool) public stewards;

    event RiskLogged(uint256 indexed id, string allegation, string impact, uint256 value);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRisk(string calldata allegation, string calldata impact, uint256 value) external {
        require(stewards[msg.sender], "Only steward");
        risks[nextId] = Risk(nextId, allegation, impact, value, block.timestamp);
        emit RiskLogged(nextId, allegation, impact, value);
        nextId++;
    }
}
