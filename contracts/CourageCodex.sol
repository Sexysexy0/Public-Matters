// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CourageCodex
/// @notice Covenant contract to safeguard systemic bravery, principled resistance, and dignified courage
contract CourageCodex {
    address public overseer;
    uint256 public courageCount;

    struct CourageRule {
        uint256 id;
        string principle; // Bravery, Principled Resistance, Moral Strength, Fearless Action
        string description; // encoded courage safeguard
        uint256 timestamp;
    }

    mapping(uint256 => CourageRule) public courages;

    event CourageLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCourage(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        courageCount++;
        courages[courageCount] = CourageRule({
            id: courageCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit CourageLogged(courageCount, principle, description);
    }

    function viewCourage(uint256 id) external view returns (CourageRule memory) {
        return courages[id];
    }
}
