// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MutualAidCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of mutual aid safeguards
contract MutualAidCodex {
    address public overseer;
    uint256 public mutualAidCount;

    struct MutualAidRule {
        uint256 id;
        string principle; // Cooperation, Shared Resources, Collective Care, Reciprocity
        string description; // encoded mutual aid form
        uint256 timestamp;
    }

    mapping(uint256 => MutualAidRule) public mutualAidRules;

    event MutualAidLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logMutualAid(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        mutualAidCount++;
        mutualAidRules[mutualAidCount] = MutualAidRule({
            id: mutualAidCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit MutualAidLogged(mutualAidCount, principle, description);
    }

    function viewMutualAid(uint256 id) external view returns (MutualAidRule memory) {
        return mutualAidRules[id];
    }
}
