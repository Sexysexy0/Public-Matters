// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketBudgetInsertionAuditOracle {
    address public steward;
    uint public anomalyThreshold = 75;

    event InsertionForecastLogged(string entity, uint anomalyScore, string forecastStatus, uint timestamp);

    function logForecast(string memory entity, uint anomalyScore) public {
        string memory status = anomalyScore >= anomalyThreshold
            ? "🔥 Clause Breach Likely"
            : "✅ Stable Allocation";
        emit InsertionForecastLogged(entity, anomalyScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        anomalyThreshold = newThreshold;
    }
}
