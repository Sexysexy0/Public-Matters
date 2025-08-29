// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GridImpactAssessment
 * @notice Analyzes DC usage over time to compute grid stress scores and recommend scaling.
 */
contract GridImpactAssessment {
    struct UsageWindow {
        uint256 kWh;
        uint64 timestamp;
    }
    mapping(address => UsageWindow[]) public usageHistory;

    event ImpactScored(address dc, uint8 score);

    function logUsage(address dc, uint256 kWh) external {
        usageHistory[dc].push(UsageWindow(kWh, uint64(block.timestamp)));
        _scoreImpact(dc);
    }

    function _scoreImpact(address dc) internal {
        UsageWindow[] storage hist = usageHistory[dc];
        uint256 len = hist.length;
        uint256 recentLoad;
        for (uint i = len > 5 ? len - 5 : 0; i < len; i++) {
            recentLoad += hist[i].kWh;
        }
        uint8 score = recentLoad > 50000 ? 5 : recentLoad > 20000 ? 3 : 1;
        emit ImpactScored(dc, score);
    }
}
