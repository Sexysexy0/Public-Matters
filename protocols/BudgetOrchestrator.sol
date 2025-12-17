// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BudgetOrchestrator: link agency requests, NEP entries, and Senate reactions
contract BudgetOrchestrator {
    address public steward;

    address public agencyRequestLedger;
    address public nepRegistry;
    address public senateMirror;

    event BudgetCycleEvaluated(
        uint256 requestId,
        uint256 entryId,
        uint256 reactionId,
        string classification
    );

    constructor(
        address _agencyRequestLedger,
        address _nepRegistry,
        address _senateMirror
    ) {
        steward = msg.sender;
        agencyRequestLedger = _agencyRequestLedger;
        nepRegistry = _nepRegistry;
        senateMirror = _senateMirror;
    }

    function updateContractAddresses(
        address _agencyRequestLedger,
        address _nepRegistry,
        address _senateMirror
    ) external {
        require(msg.sender == steward, "Only steward");
        agencyRequestLedger = _agencyRequestLedger;
        nepRegistry = _nepRegistry;
        senateMirror = _senateMirror;
    }

    // Evaluate budget cycle by linking IDs from each ledger
    function evaluateCycle(
        uint256 requestId,
        uint256 entryId,
        uint256 reactionId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (reactionId > 0) {
            classification = "Senate Reaction Recorded";
        } else if (entryId > 0) {
            classification = "NEP Entry Logged";
        } else if (requestId > 0) {
            classification = "Agency Request Logged";
        } else {
            classification = "No Record";
        }

        emit BudgetCycleEvaluated(requestId, entryId, reactionId, classification);
    }
}
