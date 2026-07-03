// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SchoolSafetyShield
/// @notice Covenant contract to safeguard schools against violence and enforce security protocols
contract SchoolSafetyShield {
    address public overseer;
    uint256 public incidentCount;

    struct SafetyEntry {
        uint256 id;
        string threatType;
        string response;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => SafetyEntry) public incidents;

    event SafetyLogged(uint256 indexed id, string threatType, string response);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSafety(
        string calldata threatType,
        string calldata response,
        string calldata location
    ) external onlyOverseer {
        incidentCount++;
        incidents[incidentCount] = SafetyEntry({
            id: incidentCount,
            threatType: threatType,
            response: response,
            location: location,
            timestamp: block.timestamp
        });
        emit SafetyLogged(incidentCount, threatType, response);
    }

    function viewSafety(uint256 id) external view returns (SafetyEntry memory) {
        return incidents[id];
    }
}
