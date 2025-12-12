// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PublicAccountabilityMirror: record questions about public officials and track transparency
contract PublicAccountabilityMirror {
    struct Question {
        uint256 id;
        string official;
        string topic;       // e.g., "Finances", "Stock trading"
        string evidenceURI;
        bool answered;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Question) public questions;
    mapping(address => bool) public stewards;

    event QuestionLogged(uint256 indexed id, string official, string topic);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logQuestion(string calldata official, string calldata topic, string calldata evidenceURI) external {
        require(stewards[msg.sender], "Only steward");
        questions[nextId] = Question(nextId, official, topic, evidenceURI, false, block.timestamp);
        emit QuestionLogged(nextId, official, topic);
        nextId++;
    }

    function markAnswered(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        questions[id].answered = true;
    }
}
