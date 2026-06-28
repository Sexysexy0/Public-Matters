// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmergencyMedicalResponseCodex
/// @notice Covenant contract to safeguard communities through rapid deployment of medical teams in crisis
contract EmergencyMedicalResponseCodex {
    address public overseer;
    uint256 public responseCount;

    struct ResponseEntry {
        uint256 id;
        string team;
        string protocol;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => ResponseEntry) public responses;

    event ResponseLogged(uint256 indexed id, string team, string protocol);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logResponse(
        string calldata team,
        string calldata protocol,
        string calldata location
    ) external onlyOverseer {
        responseCount++;
        responses[responseCount] = ResponseEntry({
            id: responseCount,
            team: team,
            protocol: protocol,
            location: location,
            timestamp: block.timestamp
        });
        emit ResponseLogged(responseCount, team, protocol);
    }

    function viewResponse(uint256 id) external view returns (ResponseEntry memory) {
        return responses[id];
    }
}
