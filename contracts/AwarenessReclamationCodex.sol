// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AwarenessReclamationCodex
/// @notice Covenant contract to reclaim agency and awareness in governance
contract AwarenessReclamationCodex {
    address public overseer;
    uint256 public awarenessCount;

    struct AwarenessEntry {
        uint256 id;
        string principle;
        string application;
        uint256 timestamp;
    }

    mapping(uint256 => AwarenessEntry) public awarenessEntries;

    event AwarenessSafeguardLogged(uint256 indexed id, string principle);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAwareness(
        string calldata principle,
        string calldata application
    ) external onlyOverseer {
        awarenessCount++;
        awarenessEntries[awarenessCount] = AwarenessEntry({
            id: awarenessCount,
            principle: principle,
            application: application,
            timestamp: block.timestamp
        });
        emit AwarenessSafeguardLogged(awarenessCount, principle);
    }

    function viewAwareness(uint256 id) external view returns (AwarenessEntry memory) {
        return awarenessEntries[id];
    }
}
