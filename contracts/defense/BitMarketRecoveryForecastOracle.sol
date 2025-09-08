// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketRecoveryForecastOracle {
    address public steward;
    uint public breachThreshold = 80;

    event RecoveryForecastLogged(string zone, string breachType, uint predictedImpact, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(
        string memory zone,
        string memory breachType,
        uint predictedImpact
    ) public {
        require(predictedImpact >= breachThreshold, "Impact too low for forecast");
        emit RecoveryForecastLogged(zone, breachType, predictedImpact, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        breachThreshold = newThreshold;
    }
}
