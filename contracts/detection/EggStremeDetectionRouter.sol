// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EggStremeDetectionRouter {
    struct DetectionEvent {
        string eventId;
        string tactic;
        string sourceBinary;
        string dllName;
        string c2Server;
        bool memoryInjected;
        uint256 timestamp;
    }

    mapping(string => DetectionEvent) public detectionLedger;

    event ThreatDetected(string eventId, string tactic, string sourceBinary, string dllName, string c2Server);

    function logDetection(
        string memory eventId,
        string memory tactic,
        string memory sourceBinary,
        string memory dllName,
        string memory c2Server,
        bool memoryInjected
    ) public {
        detectionLedger[eventId] = DetectionEvent(
            eventId,
            tactic,
            sourceBinary,
            dllName,
            c2Server,
            memoryInjected,
            block.timestamp
        );

        emit ThreatDetected(eventId, tactic, sourceBinary, dllName, c2Server);
    }

    function getDetectionDetails(string memory eventId) public view returns (DetectionEvent memory) {
        return detectionLedger[eventId];
    }
}
