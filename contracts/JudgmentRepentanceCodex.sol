// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JudgmentRepentanceCodex
/// @notice Covenant contract to safeguard communities through prophetic warnings and communal repentance
contract JudgmentRepentanceCodex {
    address public overseer;
    uint256 public entryCount;

    struct CovenantEntry {
        uint256 id;
        string type;       // Judgment, Repentance, Correction, Intercession
        string message;    // Prophetic warning or repentance call
        string reference;  // Scripture or source verse
        uint256 timestamp;
    }

    mapping(uint256 => CovenantEntry) public entries;

    event CovenantLogged(uint256 indexed id, string type, string reference);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEntry(
        string calldata type,
        string calldata message,
        string calldata reference
    ) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CovenantEntry({
            id: entryCount,
            type: type,
            message: message,
            reference: reference,
            timestamp: block.timestamp
        });
        emit CovenantLogged(entryCount, type, reference);
    }

    function viewEntry(uint256 id) external view returns (CovenantEntry memory) {
        return entries[id];
    }
}
