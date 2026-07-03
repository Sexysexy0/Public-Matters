// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MindsetCodex
/// @notice Covenant contract to safeguard leadership and personal discipline through systemic anchoring of positive thought and warrior mindset
contract MindsetCodex {
    address public overseer;
    uint256 public mindsetCount;

    struct MindsetRule {
        uint256 id;
        string principle; // Faith, Discipline, Positivity, Resilience
        string description; // encoded mindset safeguard
        uint256 timestamp;
    }

    mapping(uint256 => MindsetRule) public mindsets;

    event MindsetLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logMindset(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        mindsetCount++;
        mindsets[mindsetCount] = MindsetRule({
            id: mindsetCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit MindsetLogged(mindsetCount, principle, description);
    }

    function viewMindset(uint256 id) external view returns (MindsetRule memory) {
        return mindsets[id];
    }
}
