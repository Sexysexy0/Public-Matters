// SPDX-License-Identifier: BubbleSignalSanctum
pragma solidity ^0.8.19;

contract TechBubbleSentimentScanner {
    address public steward;

    struct SentimentSpike {
        string assetTag; // e.g. "NVDA", "QQQU", "MAGX"
        int256 sentimentScore; // -100 to +100
        string sourceTag; // e.g. "Reddit", "Bloomberg", "ETF Flow"
        string volatilitySignal; // e.g. "Overbought", "Concentrated", "Earnings Divergence"
        uint256 timestamp;
    }

    SentimentSpike[] public spikes;

    event SpikeLogged(string assetTag, int256 sentimentScore, string sourceTag, string volatilitySignal, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logSpike(
        string memory assetTag,
        int256 sentimentScore,
        string memory sourceTag,
        string memory volatilitySignal
    ) public {
        spikes.push(SentimentSpike(assetTag, sentimentScore, sourceTag, volatilitySignal, block.timestamp));
        emit SpikeLogged(assetTag, sentimentScore, sourceTag, volatilitySignal, block.timestamp);
    }

    function getSpike(uint256 index) public view returns (
        string memory, int256, string memory, string memory, uint256
    ) {
        SentimentSpike memory s = spikes[index];
        return (s.assetTag, s.sentimentScore, s.sourceTag, s.volatilitySignal, s.timestamp);
    }

    function totalSpikes() public view returns (uint256) {
        return spikes.length;
    }
}
