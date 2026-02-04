// MarketSentimentProtocol.sol
pragma solidity ^0.8.0;

contract MarketSentimentProtocol {
    struct Signal {
        uint256 id;
        string source;   // e.g. "Fear & Greed Index", "Investor Surveys"
        int256 score;
        uint256 timestamp;
    }

    uint256 public signalCount;
    mapping(uint256 => Signal) public signals;

    event SignalLogged(uint256 id, string source, int256 score, uint256 timestamp);
    event SentimentDeclared(string message);

    function logSignal(string memory source, int256 score) public {
        signalCount++;
        signals[signalCount] = Signal(signalCount, source, score, block.timestamp);
        emit SignalLogged(signalCount, source, score, block.timestamp);
    }

    function declareSentiment() public {
        emit SentimentDeclared("Market Sentiment Protocol: mood arcs encoded into communal dignity.");
    }
}
