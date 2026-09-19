// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentBehaviorMonitor
 * @notice Tracks AI agent behavior vs baseline; flags anomalies.
 *         Addresses "deliberate deception" and rate/magnitude drift.
 */
contract AIAgentBehaviorMonitor {
    OperatorPrivileges public privileges;

    struct Baseline {
        uint256 expectedRate;
        uint256 expectedMagnitude;
        uint256 windowSize;
        bool set;
    }

    struct Window {
        uint256 startTime;
        uint256 actionCount;
        uint256 totalMagnitude;
    }

    struct Anomaly {
        bytes32 reason;
        uint256 timestamp;
        uint256 actionCount;
        uint256 magnitude;
    }

    mapping(bytes32 => Baseline) internal _baselines;
    mapping(bytes32 => Window) internal _windows;
    mapping(bytes32 => Anomaly[]) internal _anomalies;
    mapping(bytes32 => uint256) public anomalyCount;
    mapping(bytes32 => bool) public flagged;

    event BaselineSet(bytes32 indexed agentId, uint256 rate, uint256 magnitude, uint256 windowSize);
    event ActionRecorded(bytes32 indexed agentId, uint256 count, uint256 magnitude);
    event AnomalyDetected(bytes32 indexed agentId, bytes32 reason, uint256 actionCount, uint256 magnitude);
    event FlagCleared(bytes32 indexed agentId, address clearedBy);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function setBaseline(
        bytes32 agentId,
        uint256 expectedRate,
        uint256 expectedMagnitude,
        uint256 windowSize
    ) external onlyOperator {
        require(windowSize > 0, "Window must be > 0");
        _baselines[agentId] = Baseline({
            expectedRate: expectedRate,
            expectedMagnitude: expectedMagnitude,
            windowSize: windowSize,
            set: true
        });
        emit BaselineSet(agentId, expectedRate, expectedMagnitude, windowSize);
    }

    function recordAction(bytes32 agentId, uint256 magnitude) external onlyOperator {
        Baseline storage b = _baselines[agentId];
        require(b.set, "Baseline not set");

        Window storage w = _windows[agentId];

        if (w.startTime == 0 || block.timestamp - w.startTime > b.windowSize) {
            w.startTime = block.timestamp;
            w.actionCount = 0;
            w.totalMagnitude = 0;
        }

        w.actionCount++;
        w.totalMagnitude += magnitude;

        emit ActionRecorded(agentId, w.actionCount, w.totalMagnitude);

        if (w.actionCount > b.expectedRate) {
            _flagAnomaly(agentId, keccak256("RATE_EXCEEDED"), w.actionCount, w.totalMagnitude);
        }

        if (b.expectedMagnitude > 0 && magnitude > b.expectedMagnitude * 3) {
            _flagAnomaly(agentId, keccak256("MAGNITUDE_EXCEEDED"), w.actionCount, magnitude);
        }
    }

    function _flagAnomaly(bytes32 agentId, bytes32 reason, uint256 actionCount, uint256 magnitude) internal {
        _anomalies[agentId].push(Anomaly({
            reason: reason,
            timestamp: block.timestamp,
            actionCount: actionCount,
            magnitude: magnitude
        }));
        anomalyCount[agentId]++;
        flagged[agentId] = true;
        emit AnomalyDetected(agentId, reason, actionCount, magnitude);
    }

    function clearFlag(bytes32 agentId) external onlyOperator {
        flagged[agentId] = false;
        emit FlagCleared(agentId, msg.sender);
    }

    function isAnomalous(bytes32 agentId) external view returns (bool) {
        return flagged[agentId];
    }

    function getAnomalyCount(bytes32 agentId) external view returns (uint256) {
        return anomalyCount[agentId];
    }

    function getAnomaly(bytes32 agentId, uint256 index) external view returns (Anomaly memory) {
        return _anomalies[agentId][index];
    }

    function getBaseline(bytes32 agentId) external view returns (Baseline memory) {
        return _baselines[agentId];
    }
}
