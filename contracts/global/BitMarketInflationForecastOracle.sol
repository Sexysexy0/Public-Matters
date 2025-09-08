// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketInflationForecastOracle {
    address public steward;
    uint public volatilityThreshold = 75;

    event InflationForecastLogged(string commodity, uint volatilityScore, string forecastStatus, uint timestamp);

    function logForecast(string memory commodity, uint volatilityScore) public {
        string memory status = volatilityScore >= volatilityThreshold
            ? "🔥 Price Surge Likely"
            : "✅ Stable Outlook";
        emit InflationForecastLogged(commodity, volatilityScore, status, block.timestamp);
    }
}
