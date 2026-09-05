// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/// @title OperatorConsciousnessLedger
/// @notice Transparent log of operator actions, trust evolution, and safeguard triggers
contract OperatorConsciousnessLedger {
    OperatorPrivileges public privileges;

    struct LogEntry {
        address operator;
        string action;
        uint256 trustScore;
        uint256 blockNumber;
        bool safeguardTriggered;
    }

    LogEntry[] public logs;

    event ConsciousnessLogged(
        address indexed operator, string action, uint256 trustScore, uint256 blockNumber, bool safeguardTriggered
    );

    constructor(address privilegesAddr) {
        privileges = OperatorPrivileges(privilegesAddr);
    }

    /// @notice Record operator action into consciousness ledger
    function recordAction(string calldata action, int256 delta) external {
        require(privileges.isOperator(msg.sender), "Not authorized operator");

        bytes32 safeguardId = keccak256(abi.encodePacked(msg.sender, action, block.number));
        require(!privileges.isSafeguarded(safeguardId), "Safeguard active");

        // Update trust via OperatorPrivileges
        privileges.logAction(msg.sender, delta);

        uint256 currentTrust = privileges.getTrustScore(msg.sender);

        logs.push(
            LogEntry({
                operator: msg.sender,
                action: action,
                trustScore: currentTrust,
                blockNumber: block.number,
                safeguardTriggered: false
            })
        );

        emit ConsciousnessLogged(msg.sender, action, currentTrust, block.number, false);
    }

    function getLogCount() external view returns (uint256) {
        return logs.length;
    }

    function getLog(uint256 index)
        external
        view
        returns (
            address operator,
            string memory action,
            uint256 trustScore,
            uint256 blockNumber,
            bool safeguardTriggered
        )
    {
        LogEntry memory entry = logs[index];
        return (entry.operator, entry.action, entry.trustScore, entry.blockNumber, entry.safeguardTriggered);
    }
}
