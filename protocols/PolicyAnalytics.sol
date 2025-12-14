// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PolicyAnalytics: compute averages and trends for tax/VAT relief
contract PolicyAnalytics {
    address public steward;

    struct Metric {
        uint256 id;
        string category;   // "VAT Relief", "Exemption Coverage", "Price Pass-Through", "Compliance"
        uint256 value;     // numeric metric (percentage or ratio)
        string notes;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Metric) public metrics;
    mapping(address => bool) public stewards;

    event MetricLogged(uint256 indexed id, string category, uint256 value);

    constructor() { 
        steward = msg.sender; 
        stewards[msg.sender] = true; 
    }

    function addSteward(address s) external {
        require(msg.sender == steward, "Only steward");
        stewards[s] = true;
    }

    function logMetric(string calldata category, uint256 value, string calldata notes) external {
        require(stewards[msg.sender], "Only steward");
        metrics[nextId] = Metric(nextId, category, value, notes, block.timestamp);
        emit MetricLogged(nextId, category, value);
        nextId++;
    }

    // Simple average calculator across logged metrics
    function computeAverage(uint256[] calldata ids) external view returns (uint256 avg) {
        require(ids.length > 0, "No IDs provided");
        uint256 sum = 0;
        for (uint256 i = 0; i < ids.length; i++) {
            sum += metrics[ids[i]].value;
        }
        avg = sum / ids.length;
    }
}
