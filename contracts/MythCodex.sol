// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MythCodex
/// @notice Covenant contract to symbolically safeguard mythic archetypes, pantheon integration, and cultural resonance
contract MythCodex {
    address public overseer;
    uint256 public mythCount;

    struct MythRule {
        uint256 id;
        string principle; // Archetype, Pantheon Integration, Cultural Resonance, Heroic Transformation
        string description; // encoded myth safeguard
        uint256 timestamp;
    }

    mapping(uint256 => MythRule) public myths;

    event MythLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logMyth(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        mythCount++;
        myths[mythCount] = MythRule({
            id: mythCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit MythLogged(mythCount, principle, description);
    }

    function viewMyth(uint256 id) external view returns (MythRule memory) {
        return myths[id];
    }
}
