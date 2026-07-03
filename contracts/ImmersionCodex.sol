// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ImmersionCodex
/// @notice Covenant contract to safeguard immersive gameplay through systemic anchoring of HUD-free mode, companion bonding, and hidden detail preservation
contract ImmersionCodex {
    address public overseer;
    uint256 public immersionCount;

    struct ImmersionRule {
        uint256 id;
        string principle; // HUD-Free, Companion Bonding, Hidden Details, Player Agency
        string description; // encoded immersion safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ImmersionRule) public immersions;

    event ImmersionLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logImmersion(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        immersionCount++;
        immersions[immersionCount] = ImmersionRule({
            id: immersionCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ImmersionLogged(immersionCount, principle, description);
    }

    function viewImmersion(uint256 id) external view returns (ImmersionRule memory) {
        return immersions[id];
    }
}
