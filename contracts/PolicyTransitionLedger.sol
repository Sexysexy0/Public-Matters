// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PolicyTransitionLedger
/// @notice Covenant contract to record transitions from failed policies to reformed covenants
contract PolicyTransitionLedger {
    address public overseer;
    uint256 public transitionCount;

    struct TransitionEntry {
        uint256 id;
        string failedPolicy;
        string reformedPolicy;
        string transitionNotes;
        uint256 timestamp;
    }

    mapping(uint256 => TransitionEntry) public transitions;

    event PolicyTransitioned(uint256 indexed id, string failedPolicy, string reformedPolicy);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTransition(
        string calldata failedPolicy,
        string calldata reformedPolicy,
        string calldata transitionNotes
    ) external onlyOverseer {
        transitionCount++;
        transitions[transitionCount] = TransitionEntry({
            id: transitionCount,
            failedPolicy: failedPolicy,
            reformedPolicy: reformedPolicy,
            transitionNotes: transitionNotes,
            timestamp: block.timestamp
        });
        emit PolicyTransitioned(transitionCount, failedPolicy, reformedPolicy);
    }

    function viewTransition(uint256 id) external view returns (TransitionEntry memory) {
        return transitions[id];
    }
}
