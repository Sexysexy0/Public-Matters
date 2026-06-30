// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AwarenessCodex
/// @notice Covenant contract to symbolically safeguard media literacy, psychological resilience, and philosophical awakening
contract AwarenessCodex {
    address public overseer;
    uint256 public awarenessCount;

    struct AwarenessRule {
        uint256 id;
        string principle; // Media Literacy, Psychological Resilience, Philosophical Awakening
        string description; // encoded awareness safeguard
        uint256 timestamp;
    }

    mapping(uint256 => AwarenessRule) public awareness;

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
        awareness[awarenessCount] = AwarenessRule({
            id: awarenessCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit AwarenessLogged(awarenessCount, principle, description);
    }

    function viewAwareness(uint256 id) external view returns (AwarenessRule memory) {
        return awareness[id];
    }
}
