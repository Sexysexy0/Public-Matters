// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SentimentBoard: capture community reaction to voice changes
contract SentimentBoard {
    struct Sentiment {
        uint256 id;
        string listener;    // "Subscriber", "Fan"
        string feeling;     // "Miss Old Voice", "Like New Voice"
        string message;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Sentiment) public sentiments;
    mapping(address => bool) public stewards;

    event SentimentLogged(uint256 indexed id, string listener, string feeling);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSentiment(string calldata listener, string calldata feeling, string calldata message) external {
        require(stewards[msg.sender], "Only steward");
        sentiments[nextId] = Sentiment(nextId, listener, feeling, message, block.timestamp);
        emit SentimentLogged(nextId, listener, feeling);
        nextId++;
    }
}
