// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketPulseForecastOracle {
    address public steward;
    uint public forecastThreshold = 85;

    event APRForecastLogged(string barangay, string civicTrigger, uint predictedAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(
        string memory barangay,
        string memory civicTrigger,
        uint predictedAPR
    ) public {
        require(predictedAPR >= forecastThreshold, "Forecast too weak for scrollchain logging");
        emit APRForecastLogged(barangay, civicTrigger, predictedAPR, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        forecastThreshold = newThreshold;
    }
}
