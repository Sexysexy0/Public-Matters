// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WitnessCodex
/// @notice Covenant contract to safeguard systemic observation, principled witness, and dignified awareness
contract WitnessCodex {
    address public overseer;
    uint256 public witnessCount;

    struct WitnessRule {
        uint256 id;
        string principle; // Observation, Awareness, Sakshi, Presence
        string description; // encoded witness safeguard
        uint256 timestamp;
    }

    mapping(uint256 => WitnessRule) public witnesses;

    event WitnessLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWitness(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        witnessCount++;
        witnesses[witnessCount] = WitnessRule({
            id: witnessCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit WitnessLogged(witnessCount, principle, description);
    }

    function viewWitness(uint256 id) external view returns (WitnessRule memory) {
        return witnesses[id];
    }
}
