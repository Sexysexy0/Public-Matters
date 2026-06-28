// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityEngagementCodex
/// @notice Covenant contract to safeguard communities through participatory engagement of parents and barangay in safety programs
contract CommunityEngagementCodex {
    address public overseer;
    uint256 public engagementCount;

    struct EngagementEntry {
        uint256 id;
        string stakeholder;
        string program;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => EngagementEntry) public engagements;

    event EngagementLogged(uint256 indexed id, string stakeholder, string program);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEngagement(
        string calldata stakeholder,
        string calldata program,
        string calldata location
    ) external onlyOverseer {
        engagementCount++;
        engagements[engagementCount] = EngagementEntry({
            id: engagementCount,
            stakeholder: stakeholder,
            program: program,
            location: location,
            timestamp: block.timestamp
        });
        emit EngagementLogged(engagementCount, stakeholder, program);
    }

    function viewEngagement(uint256 id) external view returns (EngagementEntry memory) {
        return engagements[id];
    }
}
