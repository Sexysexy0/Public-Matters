// SPDX-License-Identifier: MIT
// Contract Name: PerformanceResonanceFramework
// Purpose: Link recognition, training, and pay raise metrics
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract PerformanceResonanceFramework {
    address public chiefOperator;
    uint256 public metricCount;

    struct Metric {
        string category;       // e.g., Recognition, Training, Pay Raise
        string criteria;       // e.g., Attendance, Skill improvement
        string resonanceLink;  // How it connects to rewards or growth
        uint256 timestamp;
    }

    Metric[] public metrics;

    event MetricAdded(string category, string criteria, string resonanceLink, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        metricCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new performance metric
    function addMetric(string memory category, string memory criteria, string memory resonanceLink) public onlyChief {
        metrics.push(Metric(category, criteria, resonanceLink, block.timestamp));
        metricCount++;
        emit MetricAdded(category, criteria, resonanceLink, block.timestamp);
    }

    // View metric details
    function getMetric(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < metrics.length, "Invalid metric index");
        Metric memory m = metrics[index];
        return (m.category, m.criteria, m.resonanceLink, m.timestamp);
    }
}
