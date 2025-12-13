// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AITrainingAnalyticsEngine: compute compliance averages and violation trends
contract AITrainingAnalyticsEngine {
    address public steward;

    struct Record {
        uint256 id;
        string dataset;
        bool compliant;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Record) public records;
    mapping(address => bool) public stewards;

    event RecordLogged(uint256 indexed id, string dataset, bool compliant);

    constructor() { 
        steward = msg.sender; 
        stewards[steward] = true; 
    }

    function addSteward(address s) external {
        require(msg.sender == steward, "Only steward");
        stewards[s] = true;
    }

    function logRecord(string calldata dataset, bool compliant) external {
        require(stewards[msg.sender], "Only steward");
        records[nextId] = Record(nextId, dataset, compliant, block.timestamp);
        emit RecordLogged(nextId, dataset, compliant);
        nextId++;
    }

    // Compute compliance rate
    function complianceRate() external view returns (uint256 rate) {
        if (nextId == 0) return 0;
        uint256 compliantCount = 0;
        for (uint256 i = 0; i < nextId; i++) {
            if (records[i].compliant) compliantCount++;
        }
        rate = (compliantCount * 100) / nextId;
    }

    // Compute violation trend (last 10 records)
    function violationTrend() external view returns (uint256 violations) {
        uint256 start = nextId > 10 ? nextId - 10 : 0;
        for (uint256 i = start; i < nextId; i++) {
            if (!records[i].compliant) violations++;
        }
    }
}
