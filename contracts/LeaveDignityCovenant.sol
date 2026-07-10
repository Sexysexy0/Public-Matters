// SPDX-License-Identifier: MIT
// Contract Name: LeaveDignityCovenant
// Purpose: Guarantee fair and dignified leave policies
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract LeaveDignityCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Leave {
        string leaveType;       // e.g., Sick, Vacation, Emergency
        string dignityRule;     // e.g., No stigma, Equal treatment
        string safeguard;       // e.g., Transparency log, Audit
        uint256 timestamp;
    }

    Leave[] public leaves;

    event LeaveAdded(string leaveType, string dignityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new leave covenant
    function addLeave(string memory leaveType, string memory dignityRule, string memory safeguard) public onlyChief {
        leaves.push(Leave(leaveType, dignityRule, safeguard, block.timestamp));
        covenantCount++;
        emit LeaveAdded(leaveType, dignityRule, safeguard, block.timestamp);
    }

    // View leave covenant details
    function getLeave(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < leaves.length, "Invalid leave index");
        Leave memory l = leaves[index];
        return (l.leaveType, l.dignityRule, l.safeguard, l.timestamp);
    }
}
