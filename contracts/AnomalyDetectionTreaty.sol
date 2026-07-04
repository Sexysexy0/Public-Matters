pragma solidity ^0.8.20;

/// @title AnomalyDetectionTreaty
/// @notice Encodes anomaly and change detection rules.
/// @dev Anchors alerts, deviations, and irregularity safeguards.

contract AnomalyDetectionTreaty {
    address public overseer;
    uint256 public anomalyCount;

    struct AnomalyRule {
        uint256 id;
        string principle;   // Anomaly, Change, Alert
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AnomalyRule> public anomalies;
    event AnomalyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAnomalyRule(string calldata principle, string calldata description) external onlyOverseer {
        anomalyCount++;
        anomalies[anomalyCount] = AnomalyRule(anomalyCount, principle, description, block.timestamp);
        emit AnomalyRuleDeclared(anomalyCount, principle, description);
    }
}
