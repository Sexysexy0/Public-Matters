// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CorporateBloatLedger
/// @notice Ledger covenant to record corporate bloat, layoffs, and mismanagement in the gaming industry
contract CorporateBloatLedger {
    address public overseer;
    uint256 public entryCount;

    struct BloatRecord {
        uint256 id;
        string company;     // Ubisoft, Xbox, etc.
        string issue;       // layoffs, mismanagement, overstaffing
        string detail;      // description of case
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => BloatRecord) public records;

    event BloatLogged(uint256 indexed id, string company, string issue, string detail);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs corporate bloat record
    function logBloat(string calldata company, string calldata issue, string calldata detail, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = BloatRecord({
            id: entryCount,
            company: company,
            issue: issue,
            detail: detail,
            notes: notes,
            timestamp: block.timestamp
        });
        emit BloatLogged(entryCount, company, issue, detail);
    }

    /// @notice Citizens can view corporate bloat records
    function viewBloat(uint256 id) external view returns (BloatRecord memory) {
        return records[id];
    }
}
