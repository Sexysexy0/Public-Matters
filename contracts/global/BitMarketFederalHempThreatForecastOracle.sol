// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketFederalHempThreatForecastOracle {
    address public steward;
    uint public collapseThreshold = 75;

    event ThreatForecastLogged(string billName, uint riskScore, string forecastStatus, uint timestamp);

    function logForecast(string memory billName, uint riskScore) public {
        string memory status = riskScore >= collapseThreshold
            ? "🔥 Market Collapse Likely"
            : "✅ Stable Industry";
        emit ThreatForecastLogged(billName, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        collapseThreshold = newThreshold;
    }
}
