// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PerformanceMirror: record actual job performance outcomes
contract PerformanceMirror {
    struct Performance {
        uint256 id;
        string candidate;
        string role;        // "Virtual Assistant", "Engineer"
        string outcome;     // "Exceeded Expectations", "Met Expectations", "Needs Improvement"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Performance) public performances;
    mapping(address => bool) public stewards;

    event PerformanceLogged(uint256 indexed id, string candidate, string role, string outcome);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPerformance(string calldata candidate, string calldata role, string calldata outcome) external {
        require(stewards[msg.sender], "Only steward");
        performances[nextId] = Performance(nextId, candidate, role, outcome, block.timestamp);
        emit PerformanceLogged(nextId, candidate, role, outcome);
        nextId++;
    }
}
