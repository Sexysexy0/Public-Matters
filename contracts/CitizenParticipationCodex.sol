// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenParticipationCodex
/// @notice Covenant contract to encode participatory governance arc
contract CitizenParticipationCodex {
    address public overseer;
    uint256 public participationCount;

    struct ParticipationEntry {
        uint256 id;
        address citizen;
        string activity;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ParticipationEntry) public participations;

    event ParticipationLogged(uint256 indexed id, address citizen, string activity);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logParticipation(
        address citizen,
        string calldata activity,
        string calldata notes
    ) external onlyOverseer {
        participationCount++;
        participations[participationCount] = ParticipationEntry({
            id: participationCount,
            citizen: citizen,
            activity: activity,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ParticipationLogged(participationCount, citizen, activity);
    }

    function viewParticipation(uint256 id) external view returns (ParticipationEntry memory) {
        return participations[id];
    }
}
