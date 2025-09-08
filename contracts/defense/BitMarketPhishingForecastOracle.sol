// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketPhishingForecastOracle {
    address public steward;
    uint public escalationThreshold = 80;

    event BreachForecastLogged(string platform, string vectorType, uint riskScore, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory platform, string memory vectorType, uint riskScore) public {
        string memory status = riskScore >= escalationThreshold
            ? "⚠️ Breach Escalation Likely"
            : "✅ Stable";
        emit BreachForecastLogged(platform, vectorType, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        escalationThreshold = newThreshold;
    }
}
