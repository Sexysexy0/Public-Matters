// SPDX-License-Identifier: MIT
// Contract Name: LeaveAdministrationPolicy
// Purpose: Standardize leave requests, approvals, and documentation
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract LeaveAdministrationPolicy {
    address public chiefOperator;
    uint256 public leaveCount;

    struct LeaveRule {
        string principle;
        string guideline;
        uint256 timestamp;
    }

    LeaveRule[] public leaveRules;

    event LeaveRuleAdded(string principle, string guideline, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        leaveCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new leave administration clause
    function addLeaveRule(string memory principle, string memory guideline) public onlyChief {
        leaveRules.push(LeaveRule(principle, guideline, block.timestamp));
        leaveCount++;
        emit LeaveRuleAdded(principle, guideline, block.timestamp);
    }

    // View leave administration clause details
    function getLeaveRule(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < leaveRules.length, "Invalid leave rule index");
        LeaveRule memory l = leaveRules[index];
        return (l.principle, l.guideline, l.timestamp);
    }
}
