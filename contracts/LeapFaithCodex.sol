// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LeapFaithCodex
/// @notice Covenant contract to safeguard communities by breaking waiting room stagnation and seizing kairos moments
contract LeapFaithCodex {
    address public overseer;
    uint256 public leapCount;

    struct LeapEntry {
        uint256 id;
        string actor;
        string barrier;
        string action;
        uint256 timestamp;
    }

    mapping(uint256 => LeapEntry) public leaps;

    event LeapLogged(uint256 indexed id, string actor, string action);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLeap(
        string calldata actor,
        string calldata barrier,
        string calldata action
    ) external onlyOverseer {
        leapCount++;
        leaps[leapCount] = LeapEntry({
            id: leapCount,
            actor: actor,
            barrier: barrier,
            action: action,
            timestamp: block.timestamp
        });
        emit LeapLogged(leapCount, actor, action);
    }

    function viewLeap(uint256 id) external view returns (LeapEntry memory) {
        return leaps[id];
    }
}
