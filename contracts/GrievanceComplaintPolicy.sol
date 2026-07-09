// SPDX-License-Identifier: MIT
// Contract Name: GrievanceComplaintPolicy
// Purpose: Establish fair and transparent grievance handling system
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GrievanceComplaintPolicy {
    address public chiefOperator;
    uint256 public grievanceCount;

    struct Grievance {
        string principle;
        string procedure;
        uint256 timestamp;
    }

    Grievance[] public grievances;

    event GrievanceAdded(string principle, string procedure, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        grievanceCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new grievance/complaint clause
    function addGrievance(string memory principle, string memory procedure) public onlyChief {
        grievances.push(Grievance(principle, procedure, block.timestamp));
        grievanceCount++;
        emit GrievanceAdded(principle, procedure, block.timestamp);
    }

    // View grievance clause details
    function getGrievance(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < grievances.length, "Invalid grievance index");
        Grievance memory g = grievances[index];
        return (g.principle, g.procedure, g.timestamp);
    }
}
