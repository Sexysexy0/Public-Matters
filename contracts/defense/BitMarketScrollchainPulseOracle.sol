// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainPulseOracle {
    address public steward;
    uint public pulseThreshold = 80;

    event PulseForecastLogged(string zone, uint predictedAPR, string riskLevel, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory zone, uint predictedAPR) public {
        string memory riskLevel = predictedAPR < pulseThreshold ? "⚠️ Dip Expected" : "✅ Stable";
        emit PulseForecastLogged(zone, predictedAPR, riskLevel, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        pulseThreshold = newThreshold;
    }
}
