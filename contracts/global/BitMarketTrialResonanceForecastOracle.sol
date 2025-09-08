// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketTrialResonanceForecastOracle {
    address public steward;
    uint public redemptionThreshold = 65;

    event TrialForecastLogged(string figure, uint civicSentiment, string forecastStatus, uint timestamp);

    function logForecast(string memory figure, uint civicSentiment) public {
        string memory status = civicSentiment >= redemptionThreshold
            ? "⚖️ Redemption Possible"
            : "🔥 Trial Momentum Strong";
        emit TrialForecastLogged(figure, civicSentiment, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        redemptionThreshold = newThreshold;
    }
}
