// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SecurityOrchestrator: link victims, suspects, enforcement actions, and community sentiments
contract SecurityOrchestrator {
    address public steward;

    address public victimLedger;
    address public suspectRegistry;
    address public enforcementMirror;
    address public communitySentiment;

    event SecurityCycleEvaluated(
        uint256 victimId,
        uint256 suspectId,
        uint256 actionId,
        uint256 sentimentId,
        string classification
    );

    constructor(
        address _victimLedger,
        address _suspectRegistry,
        address _enforcementMirror,
        address _communitySentiment
    ) {
        steward = msg.sender;
        victimLedger = _victimLedger;
        suspectRegistry = _suspectRegistry;
        enforcementMirror = _enforcementMirror;
        communitySentiment = _communitySentiment;
    }

    function updateContractAddresses(
        address _victimLedger,
        address _suspectRegistry,
        address _enforcementMirror,
        address _communitySentiment
    ) external {
        require(msg.sender == steward, "Only steward");
        victimLedger = _victimLedger;
        suspectRegistry = _suspectRegistry;
        enforcementMirror = _enforcementMirror;
        communitySentiment = _communitySentiment;
    }

    // Evaluate security cycle by linking IDs from each ledger
    function evaluateCycle(
        uint256 victimId,
        uint256 suspectId,
        uint256 actionId,
        uint256 sentimentId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (sentimentId > 0) {
            classification = "Community Sentiment Recorded";
        } else if (actionId > 0) {
            classification = "Enforcement Action Logged";
        } else if (suspectId > 0) {
            classification = "Suspect Arrest Logged";
        } else if (victimId > 0) {
            classification = "Victim Rescue Logged";
        } else {
            classification = "No Record";
        }

        emit SecurityCycleEvaluated(victimId, suspectId, actionId, sentimentId, classification);
    }
}
