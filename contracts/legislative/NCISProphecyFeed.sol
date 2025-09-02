// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title NCISProphecyFeed
/// @dev Ritualizes customs intelligence, anomaly detection, and planetary audit sync

contract NCISProphecyFeed {
    address public steward;
    mapping(bytes32 => bool) public anomalyDetected;
    mapping(bytes32 => string) public prophecySignal;
    mapping(bytes32 => uint256) public signalTimestamp;

    event ProphecyLogged(bytes32 indexed containerId, string signal, uint256 timestamp);
    event AnomalyFlagged(bytes32 indexed containerId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logProphecy(bytes32 containerId, string memory signal) public onlySteward {
        prophecySignal[containerId] = signal;
        signalTimestamp[containerId] = block.timestamp;
        emit ProphecyLogged(containerId, signal, block.timestamp);

        if (keccak256(bytes(signal)) == keccak256(bytes("Smuggle Surge"))) {
            flagAnomaly(containerId, "Signal matched smuggling pattern");
        }
    }

    function flagAnomaly(bytes32 containerId, string memory reason) internal {
        anomalyDetected[containerId] = true;
        emit AnomalyFlagged(containerId, reason);
    }

    function getSignal(bytes32 containerId) public view returns (string memory, uint256, bool) {
        return (
            prophecySignal[containerId],
            signalTimestamp[containerId],
            anomalyDetected[containerId]
        );
    }
}
