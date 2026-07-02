// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PeaceAlliance
/// @notice Covenant to safeguard global peace,
///         ensuring diplomacy, conflict resolution, and cooperative security.
contract PeaceAlliance {
    address public overseer;
    uint256 public allianceCount;

    struct Alliance {
        uint256 id;
        string principle;   // Diplomacy, ConflictResolution, CooperativeSecurity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Alliance) public alliances;

    event AllianceDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareAlliance(string calldata principle, string calldata description) external onlyOverseer {
        allianceCount++;
        alliances[allianceCount] = Alliance(allianceCount, principle, description, block.timestamp);
        emit AllianceDeclared(allianceCount, principle, description);
    }

    function viewAlliance(uint256 id) external view returns (Alliance memory) {
        return alliances[id];
    }
}
