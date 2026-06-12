// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityTransparencyLedger
/// @notice Immutable ledger for refund escrow allocations and community fund usage
contract CommunityTransparencyLedger {
    address public oversightCommittee;
    uint256 public entryCount;

    struct LedgerEntry {
        uint256 id;
        string source;      // e.g. refund, escrow, allocation
        string destination; // e.g. taxpayer, community project
        uint256 amount;
        uint256 timestamp;
    }

    mapping(uint256 => LedgerEntry) public entries;

    event EntryLogged(uint256 indexed id, string source, string destination, uint256 amount);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee logs refund allocation
    function logEntry(string calldata source, string calldata destination, uint256 amount) external onlyOversight {
        entryCount++;
        entries[entryCount] = LedgerEntry({
            id: entryCount,
            source: source,
            destination: destination,
            amount: amount,
            timestamp: block.timestamp
        });
        emit EntryLogged(entryCount, source, destination, amount);
    }

    /// @notice Citizens can view ledger entries
    function viewEntry(uint256 id) external view returns (LedgerEntry memory) {
        return entries[id];
    }
}
