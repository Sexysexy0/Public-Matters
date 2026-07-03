// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GhostReconCodex
/// @notice Covenant contract to safeguard Ghost Recon Project OVR through systemic anchoring of development safeguards
contract GhostReconCodex {
    address public executive;
    uint256 public objectiveCount;

    struct ProjectObjective {
        uint256 id;
        string milestone; // Alpha Stability, Beta Readiness, Scope Integrity, Team Welfare
        string description; // encoded project objective form
        uint256 timestamp;
    }

    mapping(uint256 => ProjectObjective) public objectives;

    event ObjectiveLogged(uint256 indexed id, string milestone, string description);

    modifier onlyExecutive() {
        require(msg.sender == executive, "Not authorized");
        _;
    }

    constructor(address _executive) {
        executive = _executive;
    }

    function logObjective(
        string calldata milestone,
        string calldata description
    ) external onlyExecutive {
        objectiveCount++;
        objectives[objectiveCount] = ProjectObjective({
            id: objectiveCount,
            milestone: milestone,
            description: description,
            timestamp: block.timestamp
        });
        emit ObjectiveLogged(objectiveCount, milestone, description);
    }

    function viewObjective(uint256 id) external view returns (ProjectObjective memory) {
        return objectives[id];
    }
}
