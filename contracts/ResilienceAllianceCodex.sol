// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResilienceAllianceCodex
/// @notice Codex covenant to document collective resilience strategies and alliances in the gaming industry
contract ResilienceAllianceCodex {
    address public overseer;
    uint256 public codexCount;

    struct AllianceRecord {
        uint256 id;
        string participants; // studios, publishers, hardware makers
        string strategy;     // shared optimization, cross-platform release, cost mitigation
        string benefit;      // resilience, accessibility, profitability
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => AllianceRecord) public records;

    event AllianceLogged(uint256 indexed id, string participants, string strategy, string benefit);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs alliance resilience record
    function logAlliance(string calldata participants, string calldata strategy, string calldata benefit, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = AllianceRecord({
            id: codexCount,
            participants: participants,
            strategy: strategy,
            benefit: benefit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit AllianceLogged(codexCount, participants, strategy, benefit);
    }

    /// @notice Citizens can view alliance resilience records
    function viewAlliance(uint256 id) external view returns (AllianceRecord memory) {
        return records[id];
    }
}
