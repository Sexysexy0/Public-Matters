// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrivateDebtCovenantCodex
/// @notice Covenant contract to archive treaty clauses and systemic safeguards into a permanent codex ledger
contract PrivateDebtCovenantCodex {
    address public owner;

    struct CodexEntry {
        uint256 treatyId;      // linked to PrivateDebtUnifiedTreaty entry
        string domain;         // e.g. "Private Credit Growth", "CRE Valuations", "Debt Market Resilience"
        string archiveNote;    // codex-level archival note
        uint256 timestamp;
    }

    CodexEntry[] public codexEntries;

    event CodexArchived(uint256 treatyId, string domain, string archiveNote, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Archive treaty clause into codex ledger
    function archiveCodex(uint256 treatyId, string memory domain, string memory archiveNote) public onlyOwner {
        CodexEntry memory newEntry = CodexEntry(treatyId, domain, archiveNote, block.timestamp);
        codexEntries.push(newEntry);
        emit CodexArchived(treatyId, domain, archiveNote, block.timestamp);
    }

    function getCodexEntry(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        CodexEntry memory c = codexEntries[index];
        return (c.treatyId, c.domain, c.archiveNote, c.timestamp);
    }

    function getCodexCount() public view returns (uint256) {
        return codexEntries.length;
    }
}
