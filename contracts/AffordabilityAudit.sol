// contracts/AffordabilityAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AffordabilityAudit
 * @notice Tracks housing affordability metrics for communal equity.
 */
contract AffordabilityAudit {
    address public admin;

    struct Metric {
        string category;   // "Rent", "Mortgage", "Utilities"
        uint256 averageCost;
        string verdict;    // "Affordable", "Unaffordable"
        uint256 timestamp;
    }

    Metric[] public metrics;

    event MetricLogged(string category, uint256 averageCost, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMetric(string calldata category, uint256 averageCost, string calldata verdict) external onlyAdmin {
        metrics.push(Metric(category, averageCost, verdict, block.timestamp));
        emit MetricLogged(category, averageCost, verdict, block.timestamp);
    }

    function totalMetrics() external view returns (uint256) { return metrics.length; }

    function getMetric(uint256 id) external view returns (Metric memory) {
        require(id < metrics.length, "Invalid id");
        return metrics[id];
    }
}
