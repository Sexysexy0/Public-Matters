// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketDelta8RiskForecastOracle {
    address public steward;
    uint public riskThreshold = 75;

    event RiskForecastLogged(string compound, uint riskScore, string forecastStatus, uint timestamp);

    function logForecast(string memory compound, uint riskScore) public {
        string memory status = riskScore >= riskThreshold
            ? "🔥 High Risk"
            : "✅ Acceptable";
        emit RiskForecastLogged(compound, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        riskThreshold = newThreshold;
    }
}
