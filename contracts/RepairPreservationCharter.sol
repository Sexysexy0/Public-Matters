// SPDX-License-Identifier: MIT
// Contract Name: RepairPreservationCharter
// Purpose: Maintenance and preservation safeguards
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract RepairPreservationCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string assetType;       // e.g., Equipment, Vehicles, Digital Systems
        string repairRule;      // e.g., Scheduled maintenance, Emergency repair
        string preservationPlan;// e.g., Rotation, Backup, Audit
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string assetType, string repairRule, string preservationPlan, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new repair/preservation charter
    function addCharter(string memory assetType, string memory repairRule, string memory preservationPlan) public onlyChief {
        charters.push(Charter(assetType, repairRule, preservationPlan, block.timestamp));
        charterCount++;
        emit CharterAdded(assetType, repairRule, preservationPlan, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.assetType, c.repairRule, c.preservationPlan, c.timestamp);
    }
}
