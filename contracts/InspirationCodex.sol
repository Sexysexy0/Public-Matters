// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InspirationCodex
/// @notice Covenant contract to symbolically safeguard creative sparks, artistic resonance, and imaginative immersion
contract InspirationCodex {
    address public overseer;
    uint256 public inspirationCount;

    struct InspirationRule {
        uint256 id;
        string principle; // Creative Sparks, Artistic Resonance, Imaginative Immersion, Emotional Alignment
        string description; // encoded inspiration safeguard
        uint256 timestamp;
    }

    mapping(uint256 => InspirationRule) public inspirations;

    event InspirationLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logInspiration(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        inspirationCount++;
        inspirations[inspirationCount] = InspirationRule({
            id: inspirationCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit InspirationLogged(inspirationCount, principle, description);
    }

    function viewInspiration(uint256 id) external view returns (InspirationRule memory) {
        return inspirations[id];
    }
}
