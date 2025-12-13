// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ContributionLedger: record mandatory monthly contributions
contract ContributionLedger {
    struct Contribution {
        uint256 id;
        string contributor; // "Employee", "Employer"
        uint256 amount;
        bool onTime;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Contribution) public contributions;
    mapping(address => bool) public stewards;

    event ContributionLogged(uint256 indexed id, string contributor, uint256 amount, bool onTime);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logContribution(string calldata contributor, uint256 amount, bool onTime) external {
        require(stewards[msg.sender], "Only steward");
        contributions[nextId] = Contribution(nextId, contributor, amount, onTime, block.timestamp);
        emit ContributionLogged(nextId, contributor, amount, onTime);
        nextId++;
    }
}
