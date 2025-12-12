// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RateGuard: enforce low or zero interest rates for premium members
contract RateGuard {
    struct Rate {
        uint256 id;
        string loanType;     // e.g., "Salary loan"
        uint256 ratePercent; // interest rate
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Rate) public rates;
    mapping(address => bool) public stewards;

    event RateSet(uint256 indexed id, string loanType, uint256 ratePercent);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setRate(string calldata loanType, uint256 ratePercent, bool active) external {
        require(stewards[msg.sender], "Only steward");
        rates[nextId] = Rate(nextId, loanType, ratePercent, active, block.timestamp);
        emit RateSet(nextId, loanType, ratePercent);
        nextId++;
    }

    function toggle(uint256 id, bool active) external {
        require(stewards[msg.sender], "Only steward");
        rates[id].active = active;
    }
}
