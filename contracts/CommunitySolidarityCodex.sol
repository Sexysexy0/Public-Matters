// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunitySolidarityCodex
/// @notice Covenant contract to safeguard communities through unity and solidarity of stakeholders in safety initiatives
contract CommunitySolidarityCodex {
    address public overseer;
    uint256 public solidarityCount;

    struct SolidarityEntry {
        uint256 id;
        string stakeholders;
        string initiative;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => SolidarityEntry) public solidarities;

    event SolidarityLogged(uint256 indexed id, string stakeholders, string initiative);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSolidarity(
        string calldata stakeholders,
        string calldata initiative,
        string calldata location
    ) external onlyOverseer {
        solidarityCount++;
        solidarities[solidarityCount] = SolidarityEntry({
            id: solidarityCount,
            stakeholders: stakeholders,
            initiative: initiative,
            location: location,
            timestamp: block.timestamp
        });
        emit SolidarityLogged(solidarityCount, stakeholders, initiative);
    }

    function viewSolidarity(uint256 id) external view returns (SolidarityEntry memory) {
        return solidarities[id];
    }
}
