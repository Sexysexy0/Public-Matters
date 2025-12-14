// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CommunitySentiment: capture public reaction to incidents
contract CommunitySentiment {
    struct Sentiment {
        uint256 id;
        string community;   // "Local Residents", "Online Commenters"
        string feeling;     // "Concern", "Anger", "Demand for Verification"
        string message;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Sentiment) public sentiments;
    mapping(address => bool) public stewards;

    event SentimentLogged(uint256 indexed id, string community, string feeling);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSentiment(string calldata community, string calldata feeling, string calldata message) external {
        require(stewards[msg.sender], "Only steward");
        sentiments[nextId] = Sentiment(nextId, community, feeling, message, block.timestamp);
        emit SentimentLogged(nextId, community, feeling);
        nextId++;
    }
}
