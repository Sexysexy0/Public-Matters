// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GratitudeCodexII
/// @notice Covenant contract to safeguard systemic appreciation, principled gratitude, and dignified acknowledgment
contract GratitudeCodexII {
    address public overseer;
    uint256 public gratitudeCount;

    struct GratitudeRule {
        uint256 id;
        string principle; // Appreciation, Thankfulness, Recognition, Acknowledgment
        string description; // encoded gratitude safeguard
        uint256 timestamp;
    }

    mapping(uint256 => GratitudeRule) public gratitudes;

    event GratitudeLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logGratitude(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        gratitudeCount++;
        gratitudes[gratitudeCount] = GratitudeRule({
            id: gratitudeCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit GratitudeLogged(gratitudeCount, principle, description);
    }

    function viewGratitude(uint256 id) external view returns (GratitudeRule memory) {
        return gratitudes[id];
    }
}
