// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LayoffRecoveryLedger
/// @notice Ledger covenant to record layoffs and recovery pathways for displaced workers
contract LayoffRecoveryLedger {
    address public overseer;
    uint256 public entryCount;

    struct RecoveryRecord {
        uint256 id;
        string company;     // Xbox, Ubisoft, etc.
        uint256 layoffs;    // number of jobs lost
        string initiative;  // retraining, rehiring, indie support
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => RecoveryRecord) public records;

    event RecoveryLogged(uint256 indexed id, string company, uint256 layoffs, string initiative);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs layoff recovery record
    function logRecovery(string calldata company, uint256 layoffs, string calldata initiative, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = RecoveryRecord({
            id: entryCount,
            company: company,
            layoffs: layoffs,
            initiative: initiative,
            notes: notes,
            timestamp: block.timestamp
        });
        emit RecoveryLogged(entryCount, company, layoffs, initiative);
    }

    /// @notice Citizens can view recovery records
    function viewRecovery(uint256 id) external view returns (RecoveryRecord memory) {
        return records[id];
    }
}
