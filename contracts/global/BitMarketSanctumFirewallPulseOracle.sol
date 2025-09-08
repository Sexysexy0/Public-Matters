// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketSanctumFirewallPulseOracle {
    address public steward;
    uint public fatigueThreshold = 75;

    event PulseForecastLogged(string zone, uint currentAPR, string fatigueStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logPulse(string memory zone, uint currentAPR) public {
        string memory status = currentAPR < fatigueThreshold
            ? "⚠️ Firewall Fatigue Detected"
            : "✅ Stable";
        emit PulseForecastLogged(zone, currentAPR, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        fatigueThreshold = newThreshold;
    }
}
