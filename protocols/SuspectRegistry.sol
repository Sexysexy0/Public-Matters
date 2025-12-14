// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SuspectRegistry: record arrested suspects
contract SuspectRegistry {
    struct Suspect {
        uint256 id;
        string nationality;
        string caseType;
        string status;      // "Arrested", "Charged"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Suspect) public suspects;
    mapping(address => bool) public stewards;

    event SuspectLogged(uint256 indexed id, string nationality, string caseType, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSuspect(string calldata nationality, string calldata caseType, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        suspects[nextId] = Suspect(nextId, nationality, caseType, status, block.timestamp);
        emit SuspectLogged(nextId, nationality, caseType, status);
        nextId++;
    }
}
