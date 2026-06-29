// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AwarenessCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of awareness safeguards
contract AwarenessCodex {
    address public overseer;
    uint256 public awarenessCount;

    struct AwarenessRule {
        uint256 id;
        string principle; // Mindfulness, Situational Context, Reflective Awareness, Ethical Sensitivity
        string description; // encoded awareness form
        uint256 timestamp;
    }

    mapping(uint256 => AwarenessRule) public awarenessRules;

    event AwarenessLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAwareness(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        awarenessCount++;
        awarenessRules[awarenessCount] = AwarenessRule({
            id: awarenessCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit AwarenessLogged(awarenessCount, principle, description);
    }

    function viewAwareness(uint256 id) external view returns (AwarenessRule memory) {
        return awarenessRules[id];
    }
}
