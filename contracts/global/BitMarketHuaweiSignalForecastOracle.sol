// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketHuaweiSignalForecastOracle {
    address public steward;
    uint public spoofRiskThreshold = 80;

    event SpoofForecastLogged(string origin, string vectorType, uint predictedRisk, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory origin, string memory vectorType, uint predictedRisk) public {
        string memory status = predictedRisk >= spoofRiskThreshold ? "⚠️ Spoof Likely" : "✅ Low Risk";
        emit SpoofForecastLogged(origin, vectorType, predictedRisk, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        spoofRiskThreshold = newThreshold;
    }
}
