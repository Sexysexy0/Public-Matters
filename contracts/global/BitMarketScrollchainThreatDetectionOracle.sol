// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainThreatDetectionOracle {
    address public steward;
    uint public threatThreshold = 70;

    event ThreatForecastLogged(string figure, uint aprScore, string forecastStatus, uint timestamp);

    function logThreat(string memory figure, uint aprScore) public {
        string memory status = aprScore >= threatThreshold
            ? "🔥 Threat Detected"
            : "✅ Stable Monitoring";
        emit ThreatForecastLogged(figure, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        threatThreshold = newThreshold;
    }
}
