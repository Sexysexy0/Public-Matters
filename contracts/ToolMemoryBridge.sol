// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ToolMemoryBridge
/// @notice Bridge covenant for tool usage memory (short-term + long-term)
contract ToolMemoryBridge {
    address public oversightCommittee;
    uint256 public logCount;

    struct ToolLog {
        uint256 id;
        string toolName;
        string arguments;
        string outcome;
        bool persistent;     // true = long-term memory, false = short-term
        uint256 timestamp;
    }

    mapping(uint256 => ToolLog) public logs;

    event ToolLogged(uint256 indexed id, string toolName, string arguments, string outcome, bool persistent);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs tool usage
    function logTool(string calldata toolName, string calldata arguments, string calldata outcome, bool persistent) external onlyOversight {
        logCount++;
        logs[logCount] = ToolLog({
            id: logCount,
            toolName: toolName,
            arguments: arguments,
            outcome: outcome,
            persistent: persistent,
            timestamp: block.timestamp
        });
        emit ToolLogged(logCount, toolName, arguments, outcome, persistent);
    }

    /// @notice Citizens can view tool usage logs
    function viewToolLog(uint256 id) external view returns (ToolLog memory) {
        return logs[id];
    }
}
