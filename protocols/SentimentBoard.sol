// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SentimentBoard: capture communal sentiment about taxes vs aid
contract SentimentBoard {
    struct Sentiment {
        uint256 id;
        string citizen;
        string feeling;     // "Frustrated", "Angry", "Hopeless"
        string message;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Sentiment) public sentiments;
    mapping(address => bool) public stewards;

    event SentimentLogged(uint256 indexed id, string citizen, string feeling);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSentiment(string calldata citizen, string calldata feeling, string calldata message) external {
        require(stewards[msg.sender], "Only steward");
        sentiments[nextId] = Sentiment(nextId, citizen, feeling, message, block.timestamp);
        emit SentimentLogged(nextId, citizen, feeling);
        nextId++;
    }
}
