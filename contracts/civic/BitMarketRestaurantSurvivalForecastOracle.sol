// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketRestaurantSurvivalForecastOracle {
    address public steward;
    uint public collapseThreshold = 80;

    event SurvivalForecastLogged(string restaurantName, uint laborCostIndex, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory restaurantName, uint laborCostIndex) public {
        string memory status = laborCostIndex >= collapseThreshold
            ? "🔥 Closure Imminent"
            : "✅ Stable";
        emit SurvivalForecastLogged(restaurantName, laborCostIndex, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        collapseThreshold = newThreshold;
    }
}
