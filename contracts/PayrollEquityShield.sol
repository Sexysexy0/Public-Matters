// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PayrollEquityShield
/// @notice Shield covenant to rebalance payrolls by capping top salaries and reallocating to lowest earners
contract PayrollEquityShield {
    address public overseer;
    uint256 public shieldCount;

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

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPayroll(string calldata institution, uint256 topSalary, uint256 workerSalary, uint256 redistributed, string calldata notes) external onlyOverseer {
        shieldCount++;
        records[shieldCount] = PayrollRecord({
            id: shieldCount,
            institution: institution,
            topSalary: topSalary,
            workerSalary: workerSalary,
            redistributed: redistributed,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PayrollLogged(shieldCount, institution, topSalary, workerSalary, redistributed, notes);
    }

    function viewPayroll(uint256 id) external view returns (PayrollRecord memory) {
        return records[id];
    }
}
