// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainGeopoliticalForecastOracle {
    address public steward;
    uint public disruptionThreshold = 75;

    event GeopoliticalForecastLogged(string countryPair, uint riskScore, string forecastStatus, uint timestamp);

    function logForecast(string memory countryPair, uint riskScore) public {
        string memory status = riskScore >= disruptionThreshold
            ? "🔥 Alliance Disruption Likely"
            : "⚠️ Strategic Monitoring";
        emit GeopoliticalForecastLogged(countryPair, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        disruptionThreshold = newThreshold;
    }
}
