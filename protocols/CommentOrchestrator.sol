// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CommentOrchestrator: link surveillance reactions, hiring critiques, and trust perceptions
contract CommentOrchestrator {
    address public steward;

    address public surveillanceLedger;
    address public hiringCritiqueRegistry;
    address public trustMirror;

    event CommentCycleEvaluated(
        uint256 reactionId,
        uint256 critiqueId,
        uint256 trustId,
        string classification
    );

    constructor(
        address _surveillanceLedger,
        address _hiringCritiqueRegistry,
        address _trustMirror
    ) {
        steward = msg.sender;
        surveillanceLedger = _surveillanceLedger;
        hiringCritiqueRegistry = _hiringCritiqueRegistry;
        trustMirror = _trustMirror;
    }

    function updateContractAddresses(
        address _surveillanceLedger,
        address _hiringCritiqueRegistry,
        address _trustMirror
    ) external {
        require(msg.sender == steward, "Only steward");
        surveillanceLedger = _surveillanceLedger;
        hiringCritiqueRegistry = _hiringCritiqueRegistry;
        trustMirror = _trustMirror;
    }

    // Evaluate comment cycle by linking IDs from each ledger
    function evaluateCycle(
        uint256 reactionId,
        uint256 critiqueId,
        uint256 trustId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (trustId > 0) {
            classification = "Trust Perception Recorded";
        } else if (critiqueId > 0) {
            classification = "Hiring Critique Logged";
        } else if (reactionId > 0) {
            classification = "Surveillance Reaction Logged";
        } else {
            classification = "No Record";
        }

        emit CommentCycleEvaluated(reactionId, critiqueId, trustId, classification);
    }
}
