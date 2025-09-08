// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketPeninsulaThreatForecastOracle {
    address public steward;
    uint public breachRiskThreshold = 80;

    event ThreatForecastLogged(string region, string vectorType, uint aprDipScore, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory region, string memory vectorType, uint aprDipScore) public {
        string memory status = aprDipScore >= breachRiskThreshold
            ? "🔥 Breach Imminent"
            : "✅ Stable";
        emit ThreatForecastLogged(region, vectorType, aprDipScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        breachRiskThreshold = newThreshold;
    }
}
