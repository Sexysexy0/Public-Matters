// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LegacyCodex
/// @notice Covenant contract to symbolically safeguard intergenerational impact, narrative continuity, and cultural transmission
contract LegacyCodex {
    address public overseer;
    uint256 public legacyCount;

    struct LegacyRule {
        uint256 id;
        string principle; // Intergenerational Impact, Narrative Continuity, Cultural Transmission, Story Resonance
        string description; // encoded legacy safeguard
        uint256 timestamp;
    }

    mapping(uint256 => LegacyRule) public legacies;

    event LegacyLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLegacy(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        legacyCount++;
        legacies[legacyCount] = LegacyRule({
            id: legacyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit LegacyLogged(legacyCount, principle, description);
    }

    function viewLegacy(uint256 id) external view returns (LegacyRule memory) {
        return legacies[id];
    }
}
