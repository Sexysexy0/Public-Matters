// SPDX-License-Identifier: MIT
// Contract Name: MaintainabilityCharter
// Purpose: Encode long-term sustainability of projects
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MaintainabilityCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string maintainMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string maintainMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new maintainability clause
    function addCharter(string memory principle, string memory maintainMechanism) public onlyChief {
        charters.push(Charter(principle, maintainMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, maintainMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.maintainMechanism, c.timestamp);
    }
}
