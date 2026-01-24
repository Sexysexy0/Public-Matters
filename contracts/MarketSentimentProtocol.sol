pragma solidity ^0.8.20;

contract MarketSentimentProtocol {
    address public admin;

    struct Sentiment {
        string source;       // e.g. Davos panel, social media, analyst
        string mood;         // e.g. bearish, bullish, neutral
        string driver;       // e.g. gold surge, BTC consolidation, flash crash
        uint256 timestamp;
    }

    Sentiment[] public sentiments;

    event SentimentLogged(string source, string mood, string driver, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSentiment(string calldata source, string calldata mood, string calldata driver) external onlyAdmin {
        sentiments.push(Sentiment(source, mood, driver, block.timestamp));
        emit SentimentLogged(source, mood, driver, block.timestamp);
    }

    function totalSentiments() external view returns (uint256) {
        return sentiments.length;
    }
}
