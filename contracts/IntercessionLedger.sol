// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntercessionLedger
/// @notice Covenant contract to safeguard communities through communal prayers and intercessions
contract IntercessionLedger {
    address public overseer;
    uint256 public intercessionCount;

    struct IntercessionEntry {
        uint256 id;
        string community;
        string petition;
        string scripture;
        uint256 timestamp;
    }

    mapping(uint256 => IntercessionEntry) public intercessions;

    event IntercessionLogged(uint256 indexed id, string community, string petition);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logIntercession(
        string calldata community,
        string calldata petition,
        string calldata scripture
    ) external onlyOverseer {
        intercessionCount++;
        intercessions[intercessionCount] = IntercessionEntry({
            id: intercessionCount,
            community: community,
            petition: petition,
            scripture: scripture,
            timestamp: block.timestamp
        });
        emit IntercessionLogged(intercessionCount, community, petition);
    }

    function viewIntercession(uint256 id) external view returns (IntercessionEntry memory) {
        return intercessions[id];
    }
}
