// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainGlobalSanctumActivationForecastOracle {
    address public steward;
    uint public activationThreshold = 70;

    event SanctumActivationForecast(string country, uint aprScore, string forecastStatus, uint timestamp);

    function forecastActivation(string memory country, uint aprScore) public {
        string memory status = aprScore >= activationThreshold
            ? "🔥 Sanctum Activation Imminent"
            : "⚠️ Monitoring Phase";
        emit SanctumActivationForecast(country, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        activationThreshold = newThreshold;
    }
}
