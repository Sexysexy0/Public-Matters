// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyLedger
/// @notice Covenant contract to log all data usage publicly,
///         ensuring accountability, visibility, and trust in governance.
contract TransparencyLedger {
    address public overseer;
    uint256 public logCount;

    struct Log {
        uint256 id;
        string action;       // DataAccess, DataShare, DataStore, DataDelete
        string description;  // Encoded transparency record
        uint256 timestamp;
    }

    mapping(uint256 => Log) public logs;

    event DataLogged(uint256 indexed id, string action, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Record a new data usage log
    function recordLog(
        string calldata action,
        string calldata description
    ) external onlyOverseer {
        logCount++;
        logs[logCount] = Log({
            id: logCount,
            action: action,
            description: description,
            timestamp: block.timestamp
        });
        emit DataLogged(logCount, action, description);
    }

    /// @notice View a specific log entry
    function viewLog(uint256 id) external view returns (Log memory) {
        return logs[id];
    }
}
