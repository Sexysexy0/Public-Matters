// SPDX-License-Identifier: MIT
// Contract Name: WellnessMentalHealthPolicy
// Purpose: Provide wellness and mental health support for employees
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract WellnessMentalHealthPolicy {
    address public chiefOperator;
    uint256 public supportCount;

    struct Support {
        string principle;
        string program;
        uint256 timestamp;
    }

    Support[] public supports;

    event SupportAdded(string principle, string program, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        supportCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new wellness/mental health clause
    function addSupport(string memory principle, string memory program) public onlyChief {
        supports.push(Support(principle, program, block.timestamp));
        supportCount++;
        emit SupportAdded(principle, program, block.timestamp);
    }

    // View wellness/mental health clause details
    function getSupport(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < supports.length, "Invalid support index");
        Support memory s = supports[index];
        return (s.principle, s.program, s.timestamp);
    }
}
