// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NarrativeCodex
/// @notice Covenant contract to safeguard immersive gameplay through systemic anchoring of environmental storytelling and lore depth
contract NarrativeCodex {
    address public overseer;
    uint256 public narrativeCount;

    struct NarrativeRule {
        uint256 id;
        string principle; // Environmental Storytelling, Lore Depth, Player Agency, Immersion
        string description; // encoded narrative safeguard
        uint256 timestamp;
    }

    mapping(uint256 => NarrativeRule) public narratives;

    event NarrativeLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logNarrative(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        narrativeCount++;
        narratives[narrativeCount] = NarrativeRule({
            id: narrativeCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit NarrativeLogged(narrativeCount, principle, description);
    }

    function viewNarrative(uint256 id) external view returns (NarrativeRule memory) {
        return narratives[id];
    }
}
