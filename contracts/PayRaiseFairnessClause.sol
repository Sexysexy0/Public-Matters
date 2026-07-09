// SPDX-License-Identifier: MIT
// Contract Name: PayRaiseFairnessClause
// Purpose: Ensure fair and transparent salary increases
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract PayRaiseFairnessClause {
    address public chiefOperator;
    uint256 public clauseCount;

    struct Clause {
        string criteria;        // e.g., Performance rating, Attendance, Training completion
        string raiseType;       // e.g., Percentage increase, Fixed bonus
        string safeguard;       // e.g., Audit, Transparency log
        uint256 timestamp;
    }

    Clause[] public clauses;

    event ClauseAdded(string criteria, string raiseType, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        clauseCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new pay raise clause
    function addClause(string memory criteria, string memory raiseType, string memory safeguard) public onlyChief {
        clauses.push(Clause(criteria, raiseType, safeguard, block.timestamp));
        clauseCount++;
        emit ClauseAdded(criteria, raiseType, safeguard, block.timestamp);
    }

    // View pay raise clause details
    function getClause(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < clauses.length, "Invalid clause index");
        Clause memory c = clauses[index];
        return (c.criteria, c.raiseType, c.safeguard, c.timestamp);
    }
}
