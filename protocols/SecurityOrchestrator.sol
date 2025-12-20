// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SecurityOrchestrator: link worker identities, remote anomalies, and infiltration findings
contract SecurityOrchestrator {
    address public steward;

    address public workerIdentityLedger;
    address public remoteControlRegistry;
    address public infiltrationMirror;

    event SecurityCycleEvaluated(
        uint256 workerId,
        uint256 anomalyId,
        uint256 infiltrationId,
        string classification
    );

    constructor(
        address _workerIdentityLedger,
        address _remoteControlRegistry,
        address _infiltrationMirror
    ) {
        steward = msg.sender;
        workerIdentityLedger = _workerIdentityLedger;
        remoteControlRegistry = _remoteControlRegistry;
        infiltrationMirror = _infiltrationMirror;
    }

    function updateContractAddresses(
        address _workerIdentityLedger,
        address _remoteControlRegistry,
        address _infiltrationMirror
    ) external {
        require(msg.sender == steward, "Only steward");
        workerIdentityLedger = _workerIdentityLedger;
        remoteControlRegistry = _remoteControlRegistry;
        infiltrationMirror = _infiltrationMirror;
    }

    // Evaluate security cycle by linking IDs from each ledger
    function evaluateCycle(
        uint256 workerId,
        uint256 anomalyId,
        uint256 infiltrationId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (infiltrationId > 0) {
            classification = "Infiltration Finding Recorded";
        } else if (anomalyId > 0) {
            classification = "Remote Anomaly Logged";
        } else if (workerId > 0) {
            classification = "Worker Identity Logged";
        } else {
            classification = "No Record";
        }

        emit SecurityCycleEvaluated(workerId, anomalyId, infiltrationId, classification);
    }
}
