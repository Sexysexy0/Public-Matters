// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// IssueLedger: record issues found in pull requests
contract IssueLedger {
    struct Issue {
        uint256 id;
        string source;      // "AI", "Human"
        uint256 count;      // number of issues
        string severity;    // "Minor", "Major", "Critical"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Issue) public issues;
    mapping(address => bool) public stewards;

    event IssueLogged(uint256 indexed id, string source, uint256 count, string severity);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logIssue(string calldata source, uint256 count, string calldata severity) external {
        require(stewards[msg.sender], "Only steward");
        issues[nextId] = Issue(nextId, source, count, severity, block.timestamp);
        emit IssueLogged(nextId, source, count, severity);
        nextId++;
    }
}
