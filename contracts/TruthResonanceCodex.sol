// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthResonanceCodex
/// @notice Codex covenant to encode philosophical exploration of truth
contract TruthResonanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct TruthRecord {
        uint256 id;
        string inquiry;     // epistemic humility, existential wager, dialogue
        string insight;     // truth as process, not possession
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => TruthRecord) public records;

    event TruthLogged(uint256 indexed id, string inquiry, string insight);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs truth resonance record
    function logTruth(string calldata inquiry, string calldata insight, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = TruthRecord({
            id: codexCount,
            inquiry: inquiry,
            insight: insight,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TruthLogged(codexCount, inquiry, insight);
    }

    /// @notice Citizens can view truth resonance records
    function viewTruth(uint256 id) external view returns (TruthRecord memory) {
        return records[id];
    }
}
