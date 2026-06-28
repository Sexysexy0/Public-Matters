// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HumanitarianReliefLedger
/// @notice Covenant contract to record disaster relief and humanitarian continuity
contract HumanitarianReliefLedger {
    address public overseer;
    uint256 public reliefCount;

    struct ReliefEntry {
        uint256 id;
        string missionName;
        string resources;
        uint256 quantity;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ReliefEntry) public reliefs;

    event ReliefLogged(uint256 indexed id, string missionName);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRelief(
        string calldata missionName,
        string calldata resources,
        uint256 quantity,
        string calldata notes
    ) external onlyOverseer {
        reliefCount++;
        reliefs[reliefCount] = ReliefEntry({
            id: reliefCount,
            missionName: missionName,
            resources: resources,
            quantity: quantity,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ReliefLogged(reliefCount, missionName);
    }

    function viewRelief(uint256 id) external view returns (ReliefEntry memory) {
        return reliefs[id];
    }
}
