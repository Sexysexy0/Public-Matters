// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrisonResistanceCodex
/// @notice Codex covenant to encode resilience and resistance during imprisonment
contract PrisonResistanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct ResistanceRecord {
        uint256 id;
        string act;         // letters from prison, refusal to recant, continued critique
        string principle;   // truth, dignity, justice
        string consequence; // imprisonment, loss of career, retaliation
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ResistanceRecord) public records;

    event ResistanceLogged(uint256 indexed id, string act, string principle, string consequence);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs prison resistance record
    function logResistance(string calldata act, string calldata principle, string calldata consequence, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = ResistanceRecord({
            id: codexCount,
            act: act,
            principle: principle,
            consequence: consequence,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ResistanceLogged(codexCount, act, principle, consequence);
    }

    /// @notice Citizens can view prison resistance records
    function viewResistance(uint256 id) external view returns (ResistanceRecord memory) {
        return records[id];
    }
}
