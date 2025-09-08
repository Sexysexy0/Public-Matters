// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainDrugMortalityForecastOracle {
    address public steward;
    uint public mortalityThreshold = 60;

    event MortalityForecastLogged(string region, uint aprScore, string forecastStatus, uint timestamp);

    function logForecast(string memory region, uint aprScore) public {
        string memory status = aprScore >= mortalityThreshold
            ? "🔥 Mortality Risk Rising"
            : "✅ Stable Zone";
        emit MortalityForecastLogged(region, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        mortalityThreshold = newThreshold;
    }
}
