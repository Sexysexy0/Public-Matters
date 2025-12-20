// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MarketSentimentMirror: record sentiment indicators like Fear & Greed Index
contract MarketSentimentMirror {
    struct Sentiment {
        uint256 id;
        string indicator;   // "Fear & Greed Index"
        string level;       // "Extreme Fear"
        uint256 value;      // e.g. 20
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Sentiment) public sentiments;
    mapping(address => bool) public stewards;

    event SentimentLogged(uint256 indexed id, string indicator, string level, uint256 value);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSentiment(string calldata indicator, string calldata level, uint256 value) external {
        require(stewards[msg.sender], "Only steward");
        sentiments[nextId] = Sentiment(nextId, indicator, level, value, block.timestamp);
        emit SentimentLogged(nextId, indicator, level, value);
        nextId++;
    }
}
