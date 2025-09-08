// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketBlessingForecastOracle {
    address public steward;
    uint public resonanceThreshold = 85;

    event BlessingForecastLogged(string zone, string trigger, uint predictedAPR, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory zone, string memory trigger, uint predictedAPR) public {
        string memory status = predictedAPR >= resonanceThreshold ? "✅ Blessing Likely" : "⚠️ Low Resonance";
        emit BlessingForecastLogged(zone, trigger, predictedAPR, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        resonanceThreshold = newThreshold;
    }
}
