// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PolicyEvolutionLedger
/// @notice Covenant contract to record lifecycle and evolution stages of policies
contract PolicyEvolutionLedger {
    address public overseer;
    uint256 public evolutionCount;

    struct EvolutionEntry {
        uint256 id;
        string policyName;
        string stage;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => EvolutionEntry) public evolutions;

    event PolicyEvolved(uint256 indexed id, string policyName, string stage);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEvolution(
        string calldata policyName,
        string calldata stage,
        string calldata notes
    ) external onlyOverseer {
        evolutionCount++;
        evolutions[evolutionCount] = EvolutionEntry({
            id: evolutionCount,
            policyName: policyName,
            stage: stage,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PolicyEvolved(evolutionCount, policyName, stage);
    }

    function viewEvolution(uint256 id) external view returns (EvolutionEntry memory) {
        return evolutions[id];
    }
}
