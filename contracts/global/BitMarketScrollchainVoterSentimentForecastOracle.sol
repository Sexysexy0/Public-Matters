// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainVoterSentimentForecastOracle {
    address public steward;
    uint public volatilityThreshold = 70;

    event VoterSentimentForecast(string region, uint aprScore, string forecastStatus, uint timestamp);

    function forecastSentiment(string memory region, uint aprScore) public {
        string memory status = aprScore >= volatilityThreshold
            ? "🔥 Voter Sentiment Volatile"
            : "✅ Stable Civic Pulse";
        emit VoterSentimentForecast(region, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        volatilityThreshold = newThreshold;
    }
}
