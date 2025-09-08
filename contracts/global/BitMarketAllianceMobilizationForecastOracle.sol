// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketAllianceMobilizationForecastOracle {
    address public steward;
    uint public escalationThreshold = 80;

    event MobilizationForecastLogged(string region, uint riskScore, string forecastStatus, uint timestamp);

    function logForecast(string memory region, uint riskScore) public {
        string memory status = riskScore >= escalationThreshold
            ? "🔥 Mobilization Imminent"
            : "⚠️ Monitoring Phase";
        emit MobilizationForecastLogged(region, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        escalationThreshold = newThreshold;
    }
}
