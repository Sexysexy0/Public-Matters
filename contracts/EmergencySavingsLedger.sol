// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmergencySavingsLedger
/// @notice Ledger covenant to record emergency savings from healthcare contributions
contract EmergencySavingsLedger {
    address public overseer;
    uint256 public entryCount;

    struct SavingsRecord {
        uint256 id;
        string patientID;     // PhilHealth or national ID
        uint256 contribution; // total contribution made
        uint256 savings;      // half allocated to emergency savings
        uint256 expense;      // half allocated to hospital expense
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => SavingsRecord) public records;

    event SavingsLogged(uint256 indexed id, string patientID, uint256 contribution, uint256 savings, uint256 expense, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs emergency savings record
    function logSavings(string calldata patientID, uint256 contribution, string calldata notes) external onlyOverseer {
        entryCount++;
        uint256 savings = contribution / 2;
        uint256 expense = contribution - savings;
        records[entryCount] = SavingsRecord({
            id: entryCount,
            patientID: patientID,
            contribution: contribution,
            savings: savings,
            expense: expense,
            notes: notes,
            timestamp: block.timestamp
        });
        emit SavingsLogged(entryCount, patientID, contribution, savings, expense, notes);
    }

    /// @notice Citizens can view emergency savings records
    function viewSavings(uint256 id) external view returns (SavingsRecord memory) {
        return records[id];
    }
}
