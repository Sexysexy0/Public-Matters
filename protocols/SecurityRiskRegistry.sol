// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SecurityRiskRegistry: record security risks introduced by code
contract SecurityRiskRegistry {
    struct Risk {
        uint256 id;
        string source;      // "AI", "Human"
        string type;        // "Password Handling", "Object Reference", "XSS"
        uint256 multiplier; // relative risk factor (e.g. 1.88x)
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Risk) public risks;
    mapping(address => bool) public stewards;

    event RiskLogged(uint256 indexed id, string source, string type, uint256 multiplier);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRisk(string calldata source, string calldata type, uint256 multiplier) external {
        require(stewards[msg.sender], "Only steward");
        risks[nextId] = Risk(nextId, source, type, multiplier, block.timestamp);
        emit RiskLogged(nextId, source, type, multiplier);
        nextId++;
    }
}
