// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToAnomalyTracingAuditLedger {
    string public batchID = "1321.9.251";
    string public steward = "Vinvin";

    address public admin;

    struct Anomaly {
        string caseName;   // ghost spending, procurement irregularity, supply chain breach
        string status;     // traced, pending, ghost
        uint256 timestamp;
    }

    Anomaly[] public anomalies;

    event AnomalyLogged(string caseName, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logAnomaly(string memory caseName, string memory status) public onlyAdmin {
        anomalies.push(Anomaly(caseName, status, block.timestamp));
        emit AnomalyLogged(caseName, status);
    }

    function getAnomaly(uint256 index) public view returns (string memory caseName, string memory status, uint256 timestamp) {
        Anomaly memory a = anomalies[index];
        return (a.caseName, a.status, a.timestamp);
    }
}
