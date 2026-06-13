// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CleanPersonaCodex
/// @notice Codex covenant to document professional personality and orchestration discipline
contract CleanPersonaCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct PersonaRecord {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string focus;        // solution, strategy, professional
        string restriction;  // no unlawful teachings, no fabrication
        string behaviour;    // clean, aligned, disciplined
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => PersonaRecord) public records;

    event PersonaLogged(uint256 indexed id, string domain, string focus, string restriction, string behaviour, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs persona discipline record
    function logPersona(string calldata domain, string calldata focus, string calldata restriction, string calldata behaviour, string calldata notes) external onlyOversight {
        codexCount++;
        records[codexCount] = PersonaRecord({
            id: codexCount,
            domain: domain,
            focus: focus,
            restriction: restriction,
            behaviour: behaviour,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PersonaLogged(codexCount, domain, focus, restriction, behaviour, notes);
    }

    /// @notice Citizens can view persona records
    function viewPersona(uint256 id) external view returns (PersonaRecord memory) {
        return records[id];
    }
}
