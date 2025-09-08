// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketSanctionForecastOracle {
    address public steward;
    uint public breachThreshold = 80;

    event SanctionForecastLogged(string nation, string breachType, uint aprScore, string forecastStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logForecast(string memory nation, string memory breachType, uint aprScore) public {
        string memory status = aprScore < breachThreshold
            ? "⚠️ Sanction Escalation Likely"
            : "✅ Stable";
        emit SanctionForecastLogged(nation, breachType, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        breachThreshold = newThreshold;
    }
}
