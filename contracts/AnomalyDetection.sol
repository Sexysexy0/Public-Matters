// contracts/AnomalyDetection.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AnomalyDetection
 * @notice Logs detection of anomalies in cyber systems.
 */
contract AnomalyDetection {
    address public admin;

    struct Anomaly {
        string source;      // "Network", "Database", "Application"
        string description;
        uint256 timestamp;
    }

    Anomaly[] public anomalies;

    event AnomalyLogged(string source, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAnomaly(string calldata source, string calldata description) external onlyAdmin {
        anomalies.push(Anomaly(source, description, block.timestamp));
        emit AnomalyLogged(source, description, block.timestamp);
    }

    function totalAnomalies() external view returns (uint256) { return anomalies.length; }

    function getAnomaly(uint256 id) external view returns (Anomaly memory) {
        require(id < anomalies.length, "Invalid id");
        return anomalies[id];
    }
}
