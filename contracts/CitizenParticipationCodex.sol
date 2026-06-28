// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenParticipationCodex
/// @notice Covenant contract to encode systemic citizen participation in governance reforms
contract CitizenParticipationCodex {
    address public overseer;
    uint256 public participationCount;

    struct ParticipationEntry {
        uint256 id;
        address citizen;
        string policyName;
        string role;
        string comments;
        uint256 timestamp;
    }

    mapping(uint256 => ParticipationEntry) public participations;

    event ParticipationLogged(uint256 indexed id, address citizen, string policyName, string role);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logParticipation(
        string calldata policyName,
        string calldata role,
        string calldata comments
    ) external {
        participationCount++;
        participations[participationCount] = ParticipationEntry({
            id: participationCount,
            citizen: msg.sender,
            policyName: policyName,
            role: role,
            comments: comments,
            timestamp: block.timestamp
        });
        emit ParticipationLogged(participationCount, msg.sender, policyName, role);
    }

    function viewParticipation(uint256 id) external view returns (ParticipationEntry memory) {
        return participations[id];
    }
}
