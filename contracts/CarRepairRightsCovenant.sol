// SPDX-License-Identifier: MIT
// Contract Name: CarRepairRightsCovenant
// Purpose: Protect rights for vehicle repair and maintenance
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CarRepairRightsCovenant {
    address public chiefOperator;
    uint256 public rightsCount;

    struct Right {
        string vehicleType;     // e.g., Car, Truck, Motorcycle
        string repairAccess;    // e.g., Manuals, Tools, Diagnostics
        string fairnessRule;    // e.g., Transparent pricing, Equal service
        uint256 timestamp;
    }

    Right[] public rights;

    event RightAdded(string vehicleType, string repairAccess, string fairnessRule, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        rightsCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new repair right
    function addRight(string memory vehicleType, string memory repairAccess, string memory fairnessRule) public onlyChief {
        rights.push(Right(vehicleType, repairAccess, fairnessRule, block.timestamp));
        rightsCount++;
        emit RightAdded(vehicleType, repairAccess, fairnessRule, block.timestamp);
    }

    // View repair right details
    function getRight(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < rights.length, "Invalid right index");
        Right memory r = rights[index];
        return (r.vehicleType, r.repairAccess, r.fairnessRule, r.timestamp);
    }
}
