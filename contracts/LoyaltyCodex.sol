// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LoyaltyCodex
/// @notice Covenant contract to safeguard systemic faithfulness, principled allegiance, and dignified loyalty
contract LoyaltyCodex {
    address public overseer;
    uint256 public loyaltyCount;

    struct LoyaltyRule {
        uint256 id;
        string principle; // Faithfulness, Allegiance, Devotion, Commitment
        string description; // encoded loyalty safeguard
        uint256 timestamp;
    }

    mapping(uint256 => LoyaltyRule) public loyalties;

    event LoyaltyLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLoyalty(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        loyaltyCount++;
        loyalties[loyaltyCount] = LoyaltyRule({
            id: loyaltyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit LoyaltyLogged(loyaltyCount, principle, description);
    }

    function viewLoyalty(uint256 id) external view returns (LoyaltyRule memory) {
        return loyalties[id];
    }
}
