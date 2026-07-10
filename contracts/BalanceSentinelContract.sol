// SPDX-License-Identifier: MIT
// Contract Name: BalanceSentinelContract
// Purpose: Guardian function to monitor systemic fairness in real time
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract BalanceSentinelContract {
    address public chiefOperator;
    uint256 public sentinelChecks;

    struct SentinelLog {
        string metric;
        int256 value;
        uint256 timestamp;
        bool alert;
    }

    SentinelLog[] public logs;

    event SentinelChecked(string metric, int256 value, bool alert, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        sentinelChecks = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Perform fairness check on a metric
    function checkMetric(string memory metric, int256 value, int256 threshold) public onlyChief {
        bool alert = false;
        if (value > threshold || value < -threshold) {
            alert = true;
        }
        logs.push(SentinelLog(metric, value, block.timestamp, alert));
        sentinelChecks++;
        emit SentinelChecked(metric, value, alert, block.timestamp);
    }

    // View log details
    function getLog(uint256 index) public view returns (string memory, int256, uint256, bool) {
        require(index < logs.length, "Invalid log index");
        SentinelLog memory l = logs[index];
        return (l.metric, l.value, l.timestamp, l.alert);
    }
}
