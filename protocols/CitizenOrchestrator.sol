// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CitizenOrchestrator: link taxpayer payments, aid requests, bureaucratic delays, and citizen sentiments
contract CitizenOrchestrator {
    address public steward;

    address public taxpayerLedger;
    address public aidMirror;
    address public bureaucracyRegistry;
    address public sentimentBoard;

    event CitizenCycleEvaluated(
        uint256 paymentId,
        uint256 aidId,
        uint256 delayId,
        uint256 sentimentId,
        string classification
    );

    constructor(
        address _taxpayerLedger,
        address _aidMirror,
        address _bureaucracyRegistry,
        address _sentimentBoard
    ) {
        steward = msg.sender;
        taxpayerLedger = _taxpayerLedger;
        aidMirror = _aidMirror;
        bureaucracyRegistry = _bureaucracyRegistry;
        sentimentBoard = _sentimentBoard;
    }

    function updateContractAddresses(
        address _taxpayerLedger,
        address _aidMirror,
        address _bureaucracyRegistry,
        address _sentimentBoard
    ) external {
        require(msg.sender == steward, "Only steward");
        taxpayerLedger = _taxpayerLedger;
        aidMirror = _aidMirror;
        bureaucracyRegistry = _bureaucracyRegistry;
        sentimentBoard = _sentimentBoard;
    }

    // Evaluate citizen cycle by linking IDs from each ledger
    function evaluateCycle(
        uint256 paymentId,
        uint256 aidId,
        uint256 delayId,
        uint256 sentimentId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (sentimentId > 0) {
            classification = "Sentiment Recorded";
        } else if (delayId > 0) {
            classification = "Bureaucratic Delay Logged";
        } else if (aidId > 0) {
            classification = "Aid Request Logged";
        } else if (paymentId > 0) {
            classification = "Taxpayer Payment Logged";
        } else {
            classification = "No Record";
        }

        emit CitizenCycleEvaluated(paymentId, aidId, delayId, sentimentId, classification);
    }
}
