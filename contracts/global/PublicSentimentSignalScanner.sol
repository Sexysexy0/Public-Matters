// SPDX-License-Identifier: CivicSignalSanctum
pragma solidity ^0.8.19;

contract PublicSentimentSignalScanner {
    address public steward;

    struct SentimentSignal {
        string topic;
        string sourceTag; // e.g. "CNN", "Twitter", "Town Hall"
        int256 sentimentScore; // e.g. -100 (hostile) to +100 (supportive)
        string civicTag; // e.g. "Polarizing", "Unifying", "Legally Contested"
        uint256 timestamp;
    }

    SentimentSignal[] public signals;

    event SignalLogged(string topic, string sourceTag, int256 sentimentScore, string civicTag, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logSignal(
        string memory topic,
        string memory sourceTag,
        int256 sentimentScore,
        string memory civicTag
    ) public {
        signals.push(SentimentSignal(topic, sourceTag, sentimentScore, civicTag, block.timestamp));
        emit SignalLogged(topic, sourceTag, sentimentScore, civicTag, block.timestamp);
    }

    function getSignal(uint256 index) public view returns (
        string memory, string memory, int256, string memory, uint256
    ) {
        SentimentSignal memory s = signals[index];
        return (s.topic, s.sourceTag, s.sentimentScore, s.civicTag, s.timestamp);
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
