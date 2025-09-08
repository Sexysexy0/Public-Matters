// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketCannabisReschedulingForecastOracle {
    address public steward;
    uint public triggerThreshold = 80;

    event ReschedulingForecastLogged(string agency, uint signalStrength, string forecastStatus, uint timestamp);

    function logForecast(string memory agency, uint signalStrength) public {
        string memory status = signalStrength >= triggerThreshold
            ? "🔥 Rescheduling Imminent"
            : "✅ Stable Status";
        emit ReschedulingForecastLogged(agency, signalStrength, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        triggerThreshold = newThreshold;
    }
}
