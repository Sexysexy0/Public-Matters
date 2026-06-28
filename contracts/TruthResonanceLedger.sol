// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthResonanceLedger
/// @notice Covenant contract to preserve truth claims and encode resonance safeguards
contract TruthResonanceLedger {
    address public overseer;
    uint256 public entryCount;

    struct TruthEntry {
        uint256 id;
        string statement;
        string source;
        string resonanceLevel;
        uint256 timestamp;
    }

    mapping(uint256 => TruthEntry) public entries;

    event TruthLogged(uint256 indexed id, string statement, string source, string resonanceLevel);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTruth(
        string calldata statement,
        string calldata source,
        string calldata resonanceLevel
    ) external onlyOverseer {
        entryCount++;
        entries[entryCount] = TruthEntry({
            id: entryCount,
            statement: statement,
            source: source,
            resonanceLevel: resonanceLevel,
            timestamp: block.timestamp
        });
        emit TruthLogged(entryCount, statement, source, resonanceLevel);
    }

    function viewTruth(uint256 id) external view returns (TruthEntry memory) {
        return entries[id];
    }
}
