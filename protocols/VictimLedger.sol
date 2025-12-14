// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// VictimLedger: record rescued victims
contract VictimLedger {
    struct Victim {
        uint256 id;
        string nationality; // "Chinese", "Filipino"
        string caseType;    // "Kidnap", "Debt-related"
        string status;      // "Rescued", "Safe"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Victim) public victims;
    mapping(address => bool) public stewards;

    event VictimLogged(uint256 indexed id, string nationality, string caseType, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logVictim(string calldata nationality, string calldata caseType, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        victims[nextId] = Victim(nextId, nationality, caseType, status, block.timestamp);
        emit VictimLogged(nextId, nationality, caseType, status);
        nextId++;
    }
}
