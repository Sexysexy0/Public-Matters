// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketConflictRecoveryForecastOracle {
    address public steward;
    uint public recoveryThreshold = 70;

    event RecoveryForecastLogged(string region, uint aprScore, string forecastStatus, uint timestamp);

    function logForecast(string memory region, uint aprScore) public {
        string memory status = aprScore >= recoveryThreshold
            ? "✅ Recovery Likely"
            : "⚠️ Continued Fragility";
        emit RecoveryForecastLogged(region, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        recoveryThreshold = newThreshold;
    }
}
