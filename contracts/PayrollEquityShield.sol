// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PayrollEquityShield
/// @notice Shield covenant to enforce salary caps and redistribute excess funds
contract PayrollEquityShield {
    address public overseer;
    uint256 public shieldCount;
    uint256 public salaryCap; // maximum allowed salary for executives

    struct PayrollRecord {
        uint256 id;
        string institution;
        uint256 topSalary;     // capped salary for executives
        uint256 workerSalary;  // adjusted salary for lowest earners
        uint256 redistributed; // amount reallocated
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => PayrollRecord) public records;

    event PayrollLogged(uint256 indexed id, string institution, uint256 topSalary, uint256 workerSalary, uint256 redistributed, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer, uint256 _salaryCap) {
        overseer = _overseer;
        salaryCap = _salaryCap;
    }

    /// @notice Overseer logs payroll equity record
    function logPayroll(string calldata institution, uint256 topSalary, uint256 workerSalary, string calldata notes) external onlyOverseer {
        shieldCount++;
        uint256 cappedSalary = topSalary > salaryCap ? salaryCap : topSalary;
        uint256 redistributed = topSalary > salaryCap ? (topSalary - salaryCap) : 0;
        records[shieldCount] = PayrollRecord({
            id: shieldCount,
            institution: institution,
            topSalary: cappedSalary,
            workerSalary: workerSalary + redistributed,
            redistributed: redistributed,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PayrollLogged(shieldCount, institution, cappedSalary, workerSalary + redistributed, redistributed, notes);
    }

    /// @notice Citizens can view payroll equity records
    function viewPayroll(uint256 id) external view returns (PayrollRecord memory) {
        return records[id];
    }

    /// @notice Overseer can update salary cap
    function updateSalaryCap(uint256 newCap) external onlyOverseer {
        salaryCap = newCap;
    }
}
