pragma solidity ^0.8.20;

contract InvestorSentimentProtocol {
    address public admin;

    struct Sentiment {
        string asset;        // e.g. Bitcoin, gold, equities
        string mood;         // e.g. bullish, bearish, cautious
        uint256 timestamp;
    }

    Sentiment[] public sentiments;

    event SentimentLogged(string asset, string mood, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSentiment(string calldata asset, string calldata mood) external onlyAdmin {
        sentiments.push(Sentiment(asset, mood, block.timestamp));
        emit SentimentLogged(asset, mood, block.timestamp);
    }

    function totalSentiments() external view returns (uint256) {
        return sentiments.length;
    }
}
