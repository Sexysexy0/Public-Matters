// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VolunteerSpirit
/// @notice Covenant to safeguard civic volunteerism,
///         ensuring collective action, bayanihan, and community engagement.
contract VolunteerSpirit {
    address public overseer;
    uint256 public spiritCount;

    struct Spirit {
        uint256 id;
        string principle;   // Bayanihan, CollectiveAction, CommunityEngagement
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Spirit) public spirits;

    event SpiritDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareSpirit(string calldata principle, string calldata description) external onlyOverseer {
        spiritCount++;
        spirits[spiritCount] = Spirit(spiritCount, principle, description, block.timestamp);
        emit SpiritDeclared(spiritCount, principle, description);
    }

    function viewSpirit(uint256 id) external view returns (Spirit memory) {
        return spirits[id];
    }
}
