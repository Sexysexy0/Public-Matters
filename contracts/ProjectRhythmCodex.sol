// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProjectRhythmCodex
/// @notice Codex covenant to enforce project cadence transparency and stakeholder involvement
contract ProjectRhythmCodex {
    address public overseer;
    uint256 public codexCount;

    struct ProjectRhythm {
        uint256 id;
        string system;     // mission critical system name
        string roadmap;    // roadmap reference
        string cadence;    // release rhythm (monthly, quarterly, etc.)
        string stakeholder; // stakeholder group involved in UAT
        string notes;      // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ProjectRhythm) public records;

    event RhythmLogged(uint256 indexed id, string system, string roadmap, string cadence, string stakeholder, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs project rhythm record
    function logRhythm(string calldata system, string calldata roadmap, string calldata cadence, string calldata stakeholder, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = ProjectRhythm({
            id: codexCount,
            system: system,
            roadmap: roadmap,
            cadence: cadence,
            stakeholder: stakeholder,
            notes: notes,
            timestamp: block.timestamp
        });
        emit RhythmLogged(codexCount, system, roadmap, cadence, stakeholder, notes);
    }

    /// @notice Citizens can view project rhythm records
    function viewRhythm(uint256 id) external view returns (ProjectRhythm memory) {
        return records[id];
    }
}
