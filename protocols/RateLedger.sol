// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RateLedger: record tax and VAT rates
contract RateLedger {
    struct Rate {
        uint256 id;
        string taxType;     // "VAT", "Income", "Excise"
        uint256 percentage;
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Rate) public rates;
    mapping(address => bool) public stewards;

    event RateLogged(uint256 indexed id, string taxType, uint256 percentage);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRate(string calldata taxType, uint256 percentage, bool active) external {
        require(stewards[msg.sender], "Only steward");
        rates[nextId] = Rate(nextId, taxType, percentage, active, block.timestamp);
        emit RateLogged(nextId, taxType, percentage);
        nextId++;
    }
}
