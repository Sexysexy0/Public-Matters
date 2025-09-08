// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainCivicResilienceForecastOracle {
    address public steward;
    uint public resilienceThreshold = 75;

    event ResilienceForecastLogged(string region, uint aprScore, string forecastStatus, uint timestamp);

    function forecastResilience(string memory region, uint aprScore) public {
        string memory status = aprScore >= resilienceThreshold
            ? "✅ Recovery Trajectory Confirmed"
            : "⚠️ Civic Fragility Detected";
        emit ResilienceForecastLogged(region, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        resilienceThreshold = newThreshold;
    }
}
