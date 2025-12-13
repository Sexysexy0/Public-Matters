// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CheckpointOrchestrator: link highway, local, smart, and impacts
contract CheckpointOrchestrator {
    address public steward;

    address public highwayLedger;
    address public localRegistry;
    address public smartMirror;
    address public impactGuard;

    event CheckpointEvaluated(
        string location,
        uint256 highwayId,
        uint256 localId,
        uint256 smartId,
        uint256 impactId,
        string classification
    );

    constructor(
        address _highwayLedger,
        address _localRegistry,
        address _smartMirror,
        address _impactGuard
    ) {
        steward = msg.sender;
        highwayLedger = _highwayLedger;
        localRegistry = _localRegistry;
        smartMirror = _smartMirror;
        impactGuard = _impactGuard;
    }

    function updateContractAddresses(
        address _highwayLedger,
        address _localRegistry,
        address _smartMirror,
        address _impactGuard
    ) external {
        require(msg.sender == steward, "Only steward");
        highwayLedger = _highwayLedger;
        localRegistry = _localRegistry;
        smartMirror = _smartMirror;
        impactGuard = _impactGuard;
    }

    // Evaluate checkpoint lifecycle by linking IDs from each ledger
    function evaluateCheckpoint(
        string calldata location,
        uint256 highwayId,
        uint256 localId,
        uint256 smartId,
        uint256 impactId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (impactId > 0) {
            classification = "Impact Recorded";
        } else if (smartId > 0) {
            classification = "Smart Checkpoint Deployed";
        } else if (localId > 0) {
            classification = "Local Checkpoint Logged";
        } else if (highwayId > 0) {
            classification = "Highway Checkpoint Logged";
        } else {
            classification = "No Record";
        }

        emit CheckpointEvaluated(location, highwayId, localId, smartId, impactId, classification);
    }
}
