// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SustainabilityGuard: record funding and sustainability measures
contract SustainabilityGuard {
    struct Fund {
        uint256 id;
        string source;      // "Government", "Employer", "Community"
        uint256 amount;
        string allocation;  // "Premium Subsidy", "Hospital Support"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Fund) public funds;
    mapping(address => bool) public stewards;

    event FundLogged(uint256 indexed id, string source, uint256 amount, string allocation);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logFund(string calldata source, uint256 amount, string calldata allocation) external {
        require(stewards[msg.sender], "Only steward");
        funds[nextId] = Fund(nextId, source, amount, allocation, block.timestamp);
        emit FundLogged(nextId, source, amount, allocation);
        nextId++;
    }
}
