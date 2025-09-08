// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketPutinStrikeForecastOracle {
    address public steward;
    uint public escalationThreshold = 80;

    event StrikeForecastLogged(string region, string vectorType, uint aprDipScore, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory region, string memory vectorType, uint aprDipScore) public {
        string memory status = aprDipScore >= escalationThreshold
            ? "🔥 Strike Imminent"
            : "✅ Stable";
        emit StrikeForecastLogged(region, vectorType, aprDipScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        escalationThreshold = newThreshold;
    }
}
