// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CEOAgendaCodex
/// @notice Covenant contract to encode systemic CEO agenda safeguards
contract CEOAgendaCodex {
    address public overseer;
    uint256 public agendaCount;

    struct AgendaEntry {
        uint256 id;
        string pillar;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AgendaEntry) public agendaEntries;

    event AgendaLogged(uint256 indexed id, string pillar);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAgenda(
        string calldata pillar,
        string calldata description
    ) external onlyOverseer {
        agendaCount++;
        agendaEntries[agendaCount] = AgendaEntry({
            id: agendaCount,
            pillar: pillar,
            description: description,
            timestamp: block.timestamp
        });
        emit AgendaLogged(agendaCount, pillar);
    }

    function viewAgenda(uint256 id) external view returns (AgendaEntry memory) {
        return agendaEntries[id];
    }
}
