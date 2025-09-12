// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SovereigntySentimentOracle {
    struct SentimentSignal {
        uint256 id;
        string region;
        uint256 pollScore; // 0–100
        uint256 mediaMentions;
        uint256 civicActivations;
        string statusTag;
        uint256 timestamp;
    }

    mapping(uint256 => SentimentSignal) public sentimentRegistry;
    uint256 public signalCount;

    event SentimentLogged(uint256 id, string region, string statusTag);

    function logSentiment(
        string memory region,
        uint256 pollScore,
        uint256 mediaMentions,
        uint256 civicActivations,
        string memory statusTag,
        uint256 timestamp
    ) public {
        sentimentRegistry[signalCount] = SentimentSignal(
            signalCount,
            region,
            pollScore,
            mediaMentions,
            civicActivations,
            statusTag,
            timestamp
        );
        emit SentimentLogged(signalCount, region, statusTag);
        signalCount++;
    }

    function getSentiment(uint256 id) public view returns (SentimentSignal memory) {
        return sentimentRegistry[id];
    }
}
