// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BlessingFixLogger
/// @notice Auto-logs flaw reports and healing rituals from SelfHealingLawProtocol.sol
contract BlessingFixLogger {
    address public steward;
    string[] public logEntries;

    event LogWritten(string entry, address indexed steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Write a log entry for a flaw fix ritual
    function writeLog(string calldata entry) external onlySteward {
        logEntries.push(entry);
        emit LogWritten(entry, msg.sender);
    }

    /// @notice Retrieve all log entries
    function getAllLogs() external view returns (string[] memory) {
        return logEntries;
    }

    /// @notice Transfer stewardship to another scrollsmith
    function transferStewardship(address newSteward) external onlySteward {
        steward = newSteward;
    }
}
