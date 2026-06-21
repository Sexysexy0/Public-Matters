// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InvestorConfidenceCodex
/// @notice Codex covenant to encode investor confidence safeguards in cybersecurity governance
contract InvestorConfidenceCodex {
    address public overseer;
    uint256 public confidenceCount;

    struct ConfidenceRecord {
        uint256 id;
        string signal;      // governance, compliance, resilience, transparency
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ConfidenceRecord) public records;

    event ConfidenceLogged(uint256 indexed id, string signal, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs investor confidence record
    function logConfidence(string calldata signal, string calldata safeguard, string calldata notes) external onlyOverseer {
        confidenceCount++;
        records[confidenceCount] = ConfidenceRecord({
            id: confidenceCount,
            signal: signal,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ConfidenceLogged(confidenceCount, signal, safeguard);
    }

    /// @notice Citizens can view investor confidence records
    function viewConfidence(uint256 id) external view returns (ConfidenceRecord memory) {
        return records[id];
    }
}
