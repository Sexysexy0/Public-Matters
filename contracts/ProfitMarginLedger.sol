// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProfitMarginLedger
/// @notice Ledger covenant to record financial margins and mismanagement cases in the gaming industry
contract ProfitMarginLedger {
    address public overseer;
    uint256 public entryCount;

    struct MarginRecord {
        uint256 id;
        string company;     // Xbox, Ubisoft, etc.
        uint256 margin;     // profit margin percentage
        string risk;        // layoffs, closures, instability
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => MarginRecord) public records;

    event MarginLogged(uint256 indexed id, string company, uint256 margin, string risk);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs profit margin record
    function logMargin(string calldata company, uint256 margin, string calldata risk, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = MarginRecord({
            id: entryCount,
            company: company,
            margin: margin,
            risk: risk,
            notes: notes,
            timestamp: block.timestamp
        });
        emit MarginLogged(entryCount, company, margin, risk);
    }

    /// @notice Citizens can view profit margin records
    function viewMargin(uint256 id) external view returns (MarginRecord memory) {
        return records[id];
    }
}
