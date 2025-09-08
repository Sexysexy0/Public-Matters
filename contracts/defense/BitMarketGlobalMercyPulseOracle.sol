// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketGlobalMercyPulseOracle {
    address public steward;
    uint public empathySurgeThreshold = 80;

    event MercySurgeForecasted(string region, string breachType, uint aprDipScore, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function forecastSurge(string memory region, string memory breachType, uint aprDipScore) public {
        string memory status = aprDipScore >= empathySurgeThreshold
            ? "🔥 Broadcast Surge Predicted"
            : "✅ Stable";
        emit MercySurgeForecasted(region, breachType, aprDipScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        empathySurgeThreshold = newThreshold;
    }
}
