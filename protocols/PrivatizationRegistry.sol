// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PrivatizationRegistry: record mallification or privatization attempts
contract PrivatizationRegistry {
    struct Attempt {
        uint256 id;
        string project;     // "Baguio Public Market Mall"
        string status;      // "Proposed", "Approved", "Rejected"
        string developer;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Attempt) public attempts;
    mapping(address => bool) public stewards;

    event AttemptLogged(uint256 indexed id, string project, string status, string developer);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logAttempt(string calldata project, string calldata status, string calldata developer) external {
        require(stewards[msg.sender], "Only steward");
        attempts[nextId] = Attempt(nextId, project, status, developer, block.timestamp);
        emit AttemptLogged(nextId, project, status, developer);
        nextId++;
    }
}
