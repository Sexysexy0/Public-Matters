// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CandidateSkillLedger: record candidate skills and talents
contract CandidateSkillLedger {
    struct Candidate {
        uint256 id;
        string name;
        string skill;       // "Data Analysis", "Customer Support"
        string level;       // "Beginner", "Intermediate", "Expert"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public stewards;

    event CandidateLogged(uint256 indexed id, string name, string skill, string level);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCandidate(string calldata name, string calldata skill, string calldata level) external {
        require(stewards[msg.sender], "Only steward");
        candidates[nextId] = Candidate(nextId, name, skill, level, block.timestamp);
        emit CandidateLogged(nextId, name, skill, level);
        nextId++;
    }
}
