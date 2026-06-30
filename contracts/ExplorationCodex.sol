// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ExplorationCodex
/// @notice Covenant contract to safeguard immersive gameplay through systemic anchoring of open-world exploration and discovery
contract ExplorationCodex {
    address public overseer;
    uint256 public explorationCount;

    struct ExplorationRule {
        uint256 id;
        string principle; // Freedom, Discovery, Environmental Storytelling, Player Agency
        string description; // encoded exploration safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ExplorationRule) public explorations;

    event ExplorationLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logExploration(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        explorationCount++;
        explorations[explorationCount] = ExplorationRule({
            id: explorationCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ExplorationLogged(explorationCount, principle, description);
    }

    function viewExploration(uint256 id) external view returns (ExplorationRule memory) {
        return explorations[id];
    }
}
