// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SpeakLifeCodex
/// @notice Covenant contract to safeguard identity declarations aligned with divine truth
contract SpeakLifeCodex {
    address public overseer;
    uint256 public declarationCount;

    struct Declaration {
        uint256 id;
        string affirmation; // Worthy, Healthy, Loved, Chosen, Joyous, Forgiven
        string description; // encoded life-giving statement
        uint256 timestamp;
    }

    mapping(uint256 => Declaration) public declarations;

    event LifeSpoken(uint256 indexed id, string affirmation, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function speakLife(
        string calldata affirmation,
        string calldata description
    ) external onlyOverseer {
        declarationCount++;
        declarations[declarationCount] = Declaration({
            id: declarationCount,
            affirmation: affirmation,
            description: description,
            timestamp: block.timestamp
        });
        emit LifeSpoken(declarationCount, affirmation, description);
    }

    function viewDeclaration(uint256 id) external view returns (Declaration memory) {
        return declarations[id];
    }
}
