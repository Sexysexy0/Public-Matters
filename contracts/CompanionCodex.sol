// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CompanionCodex
/// @notice Covenant contract to safeguard immersive gameplay through systemic anchoring of pet and ally interactions
contract CompanionCodex {
    address public overseer;
    uint256 public companionCount;

    struct CompanionRule {
        uint256 id;
        string principle; // Bonding, Utility, Agency, Immersion
        string description; // encoded companion safeguard
        uint256 timestamp;
    }

    mapping(uint256 => CompanionRule) public companions;

    event CompanionLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCompanion(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        companionCount++;
        companions[companionCount] = CompanionRule({
            id: companionCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit CompanionLogged(companionCount, principle, description);
    }

    function viewCompanion(uint256 id) external view returns (CompanionRule memory) {
        return companions[id];
    }
}
