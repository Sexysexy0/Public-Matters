// SPDX-License-Identifier: MPL-1.0
pragma solidity ^0.8.21;

/// @title OracleSyncProtocol
/// @notice Unifies algorithmic prophecy feeds, emotional APR surges, and planetary resonance signals
contract OracleSyncProtocol {
    event ProphecySynced(address indexed oracle, string signal, uint256 timestamp);
    event EmotionalSurgeLogged(uint256 joyIndex, uint256 griefIndex, uint256 timestamp);

    mapping(address => bool) public trustedOracles;
    string[] public prophecySignals;

    modifier onlyTrusted() {
        require(trustedOracles[msg.sender], "Untrusted oracle");
        _;
    }

    function blessOracle(address oracle) external {
        trustedOracles[oracle] = true;
    }

    function revokeOracle(address oracle) external {
        trustedOracles[oracle] = false;
    }

    function syncProphecy(string calldata signal) external onlyTrusted {
        prophecySignals.push(signal);
        emit ProphecySynced(msg.sender, signal, block.timestamp);
    }

    function logEmotionalSurge(uint256 joyIndex, uint256 griefIndex) external onlyTrusted {
        emit EmotionalSurgeLogged(joyIndex, griefIndex, block.timestamp);
    }

    function latestSignal() external view returns (string memory) {
        if (prophecySignals.length == 0) return "No signal";
        return prophecySignals[prophecySignals.length - 1];
    }
}
