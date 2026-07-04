// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConvictionDecayLedger
/// @notice Encodes detection rules for conviction decay over time.
/// @dev Anchors decay indicators, drift detection, and reaffirmation triggers.

contract ConvictionDecayLedger {
    address public overseer;
    uint256 public decayCount;

    struct DecayRecord {
        uint256 id;
        string principle;   // Decay, Drift, Misalignment
        string description;
        uint256 timestamp;
    }

    mapping<uint256 => DecayRecord> public decayRecords;
    event DecayRecordDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareDecayRecord(string calldata principle, string calldata description) external onlyOverseer {
        decayCount++;
        decayRecords[decayCount] = DecayRecord(decayCount, principle, description, block.timestamp);
        emit DecayRecordDeclared(decayCount, principle, description);
    }
}
