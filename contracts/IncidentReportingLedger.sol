// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IncidentReportingLedger
/// @notice Covenant contract to safeguard transparency through reporting of school and community incidents
contract IncidentReportingLedger {
    address public overseer;
    uint256 public incidentCount;

    struct IncidentEntry {
        uint256 id;
        string type;
        string description;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => IncidentEntry) public incidents;

    event IncidentLogged(uint256 indexed id, string type, string location);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logIncident(
        string calldata type,
        string calldata description,
        string calldata location
    ) external onlyOverseer {
        incidentCount++;
        incidents[incidentCount] = IncidentEntry({
            id: incidentCount,
            type: type,
            description: description,
            location: location,
            timestamp: block.timestamp
        });
        emit IncidentLogged(incidentCount, type, location);
    }

    function viewIncident(uint256 id) external view returns (IncidentEntry memory) {
        return incidents[id];
    }
}
