// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TaxTransparencyLedger
/// @notice Ledger covenant to record and track tax allocations for transparency
contract TaxTransparencyLedger {
    address public overseer;
    uint256 public entryCount;

    struct TaxEntry {
        uint256 id;
        string source;       // e.g. income tax, VAT, corporate tax
        string allocation;   // education, health, infrastructure
        uint256 amount;      // peso value
        string safeguard;    // transparency, accountability, fairness
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => TaxEntry) public entries;

    event TaxLogged(uint256 indexed id, string source, string allocation, uint256 amount, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs tax allocation entry
    function logTax(string calldata source, string calldata allocation, uint256 amount, string calldata safeguard, string calldata notes) external onlyOverseer {
        entryCount++;
        entries[entryCount] = TaxEntry({
            id: entryCount,
            source: source,
            allocation: allocation,
            amount: amount,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TaxLogged(entryCount, source, allocation, amount, safeguard, notes);
    }

    /// @notice Citizens can view tax allocation entries
    function viewTax(uint256 id) external view returns (TaxEntry memory) {
        return entries[id];
    }
}
