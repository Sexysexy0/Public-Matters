// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketAutopenControversyForecastOracle {
    address public steward;
    uint public mediaStormThreshold = 75;

    event ControversyForecastLogged(string documentType, uint riskScore, string forecastStatus, uint timestamp);

    function logForecast(string memory documentType, uint riskScore) public {
        string memory status = riskScore >= mediaStormThreshold
            ? "🔥 Media Storm Likely"
            : "✅ Stable Coverage";
        emit ControversyForecastLogged(documentType, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        mediaStormThreshold = newThreshold;
    }
}
