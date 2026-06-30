// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorldBuildingCodex
/// @notice Covenant contract to safeguard immersive gameplay through systemic anchoring of world-building depth and interconnected lore
contract WorldBuildingCodex {
    address public overseer;
    uint256 public worldCount;

    struct WorldRule {
        uint256 id;
        string principle; // Coherence, Depth, Interconnection, Immersion
        string description; // encoded world-building safeguard
        uint256 timestamp;
    }

    mapping(uint256 => WorldRule) public worlds;

    event WorldLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWorld(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        worldCount++;
        worlds[worldCount] = WorldRule({
            id: worldCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit WorldLogged(worldCount, principle, description);
    }

    function viewWorld(uint256 id) external view returns (WorldRule memory) {
        return worlds[id];
    }
}
