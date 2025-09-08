// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketCrewWageForecastOracle {
    address public steward;
    uint public wageSpikeThreshold = 620;

    event WageForecastLogged(string region, uint currentWage, uint forecastedWage, string hiringTrend, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory region, uint currentWage, uint forecastedWage) public {
        string memory hiringTrend = forecastedWage >= wageSpikeThreshold
            ? "⚠️ Declining"
            : "✅ Stable";
        emit WageForecastLogged(region, currentWage, forecastedWage, hiringTrend, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        wageSpikeThreshold = newThreshold;
    }
}
