pragma solidity ^0.8.20;

contract SentimentFearProtocol {
    address public admin;

    struct Sentiment {
        string index;        // e.g. Fear & Greed Index
        string value;        // e.g. 34
        string mood;         // e.g. Fear
        uint256 timestamp;
    }

    Sentiment[] public sentiments;

    event SentimentLogged(string index, string value, string mood, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSentiment(string calldata index, string calldata value, string calldata mood) external onlyAdmin {
        sentiments.push(Sentiment(index, value, mood, block.timestamp));
        emit SentimentLogged(index, value, mood, block.timestamp);
    }

    function totalSentiments() external view returns (uint256) {
        return sentiments.length;
    }
}
