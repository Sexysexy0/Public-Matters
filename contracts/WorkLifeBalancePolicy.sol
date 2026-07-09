// SPDX-License-Identifier: MIT
// Contract Name: WorkLifeBalancePolicy
// Purpose: Safeguard employee rest, personal time, and prevent overwork
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract WorkLifeBalancePolicy {
    address public chiefOperator;
    uint256 public clauseCount;

    struct Clause {
        string principle;
        string guideline;
        uint256 timestamp;
    }

    Clause[] public clauses;

    event ClauseAdded(string principle, string guideline, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        clauseCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new work-life balance clause
    function addClause(string memory principle, string memory guideline) public onlyChief {
        clauses.push(Clause(principle, guideline, block.timestamp));
        clauseCount++;
        emit ClauseAdded(principle, guideline, block.timestamp);
    }

    // View work-life balance clause details
    function getClause(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < clauses.length, "Invalid clause index");
        Clause memory c = clauses[index];
        return (c.principle, c.guideline, c.timestamp);
    }
}
