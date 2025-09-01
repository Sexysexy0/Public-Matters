// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BudgetAnomalyWatcher {
    struct AnomalyLog {
        string LGU;
        string anomalyType; // e.g. "GhostProgram", "DelayedInfra", "UnverifiedFlow"
        uint256 flaggedAmount;
        string actionTaken; // e.g. "Paused", "Rerouted", "Reformed"
        string emotionalTag; // e.g. "StopReroute", "AuditGlow", "MercyPing"
        uint256 timestamp;
    }

    AnomalyLog[] public logs;

    event AnomalyFlagged(string LGU, string anomalyType, uint256 flaggedAmount, string actionTaken, string emotionalTag);

    function flagAnomaly(
        string memory _LGU,
        string memory _anomalyType,
        uint256 _flaggedAmount,
        string memory _actionTaken,
        string memory _emotionalTag
    ) public {
        logs.push(AnomalyLog(_LGU, _anomalyType, _flaggedAmount, _actionTaken, _emotionalTag, block.timestamp));
        emit AnomalyFlagged(_LGU, _anomalyType, _flaggedAmount, _actionTaken, _emotionalTag);
    }

    function getLog(uint256 index) public view returns (AnomalyLog memory) {
        return logs[index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
