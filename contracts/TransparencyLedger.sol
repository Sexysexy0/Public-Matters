// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyLedger
/// @notice Immutable ledger covenant to record authorship commits on-chain
contract TransparencyLedger {
    address public overseer;
    uint256 public entryCount;

    struct LedgerEntry {
        uint256 id;
        string author;       // e.g. Emervin V. Gueco (Vinvin)
        string workHash;     // hash of code/doc commit
        string project;      // project/repo name
        string safeguard;    // copyright, integrity, transparency
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => LedgerEntry) public entries;

    event EntryLogged(uint256 indexed id, string author, string workHash, string project, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs immutable authorship entry
    function logEntry(string calldata author, string calldata workHash, string calldata project, string calldata safeguard, string calldata notes) external onlyOverseer {
        entryCount++;
        entries[entryCount] = LedgerEntry({
            id: entryCount,
            author: author,
            workHash: workHash,
            project: project,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit EntryLogged(entryCount, author, workHash, project, safeguard, notes);
    }

    /// @notice Citizens can view ledger entries
    function viewEntry(uint256 id) external view returns (LedgerEntry memory) {
        return entries[id];
    }
}
