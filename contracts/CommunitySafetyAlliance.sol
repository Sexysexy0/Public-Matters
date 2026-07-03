// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunitySafetyAlliance
/// @notice Covenant contract to safeguard communities through coordination of schools, LGUs, and enforcement agencies
contract CommunitySafetyAlliance {
    address public overseer;
    uint256 public allianceCount;

    struct AllianceEntry {
        uint256 id;
        string partner;
        string protocol;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => AllianceEntry) public alliances;

    event AllianceLogged(uint256 indexed id, string partner, string protocol);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAlliance(
        string calldata partner,
        string calldata protocol,
        string calldata location
    ) external onlyOverseer {
        allianceCount++;
        alliances[allianceCount] = AllianceEntry({
            id: allianceCount,
            partner: partner,
            protocol: protocol,
            location: location,
            timestamp: block.timestamp
        });
        emit AllianceLogged(allianceCount, partner, protocol);
    }

    function viewAlliance(uint256 id) external view returns (AllianceEntry memory) {
        return alliances[id];
    }
}
