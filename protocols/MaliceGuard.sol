// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MaliceGuard: record evidence of actual malice
contract MaliceGuard {
    struct Malice {
        uint256 id;
        uint256 claimId;
        string indicator;  // "Reckless disregard", "Knew false"
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Malice) public malice;
    mapping(address => bool) public stewards;

    event MaliceLogged(uint256 indexed id, uint256 claimId, string indicator);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logMalice(uint256 claimId, string calldata indicator, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        malice[nextId] = Malice(nextId, claimId, indicator, description, block.timestamp);
        emit MaliceLogged(nextId, claimId, indicator);
        nextId++;
    }
}
