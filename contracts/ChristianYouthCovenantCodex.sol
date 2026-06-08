// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChristianYouthCovenantCodex
/// @notice Covenant contract to archive treaty clauses and safeguards into a permanent codex ledger
contract ChristianYouthCovenantCodex {
    address public owner;

    struct CodexEntry {
        uint256 treatyClauseId; // linked to ChristianYouthUnifiedTreaty entry
        string domain;          // e.g. "Masculine Dignity", "Community Purpose", "Truth and Courage"
        string archiveNote;     // codex-level archival note
        uint256 timestamp;
    }

    CodexEntry[] public codexEntries;

    event CodexArchived(uint256 treatyClauseId, string domain, string archiveNote, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Archive treaty clause into codex ledger
    function archiveCodex(uint256 treatyClauseId, string memory domain, string memory archiveNote) public onlyOwner {
        CodexEntry memory newEntry = CodexEntry(treatyClauseId, domain, archiveNote, block.timestamp);
        codexEntries.push(newEntry);
        emit CodexArchived(treatyClauseId, domain, archiveNote, block.timestamp);
    }

    function getCodexEntry(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        CodexEntry memory c = codexEntries[index];
        return (c.treatyClauseId, c.domain, c.archiveNote, c.timestamp);
    }

    function getCodexCount() public view returns (uint256) {
        return codexEntries.length;
    }
}
