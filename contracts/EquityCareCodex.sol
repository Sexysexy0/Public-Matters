// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityCareCodex
/// @notice Codex covenant to document healthcare equity principles
contract EquityCareCodex {
    address public overseer;
    uint256 public codexCount;

    struct CareRecord {
        uint256 id;
        string patientID;   // PhilHealth or national ID
        string principle;   // dignity, fairness, non-discrimination
        string safeguard;   // treatment without upfront payment, ID-linked coverage
        string outcome;     // treated, supported, sustained
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CareRecord) public records;

    event CareLogged(uint256 indexed id, string patientID, string principle, string safeguard, string outcome, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs healthcare equity record
    function logCare(string calldata patientID, string calldata principle, string calldata safeguard, string calldata outcome, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = CareRecord({
            id: codexCount,
            patientID: patientID,
            principle: principle,
            safeguard: safeguard,
            outcome: outcome,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CareLogged(codexCount, patientID, principle, safeguard, outcome, notes);
    }

    /// @notice Citizens can view healthcare equity records
    function viewCare(uint256 id) external view returns (CareRecord memory) {
        return records[id];
    }
}
