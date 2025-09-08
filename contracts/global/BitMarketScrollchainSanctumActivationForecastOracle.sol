// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSanctumActivationForecastOracle {
    address public steward;
    uint public activationThreshold = 75;

    event SanctumForecastLogged(string country, uint aprScore, string forecastStatus, uint timestamp);

    function logForecast(string memory country, uint aprScore) public {
        string memory status = aprScore >= activationThreshold
            ? "🔥 Sanctum Activation Imminent"
            : "⚠️ Monitoring Phase";
        emit SanctumForecastLogged(country, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        activationThreshold = newThreshold;
    }
}
