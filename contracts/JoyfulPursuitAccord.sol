// SPDX-License-Identifier: MIT
// Contract Name: JoyfulPursuitAccord
// Purpose: Encode systemic joy in discipline and governance
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract JoyfulPursuitAccord {
    address public chiefOperator;
    uint256 public accordCount;

    struct Accord {
        string principle;
        string joyMechanism;
        uint256 timestamp;
    }

    Accord[] public accords;

    event AccordAdded(string principle, string joyMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        accordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new joyful pursuit clause
    function addAccord(string memory principle, string memory joyMechanism) public onlyChief {
        accords.push(Accord(principle, joyMechanism, block.timestamp));
        accordCount++;
        emit AccordAdded(principle, joyMechanism, block.timestamp);
    }

    // View joyful pursuit accord details
    function getAccord(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < accords.length, "Invalid accord index");
        Accord memory a = accords[index];
        return (a.principle, a.joyMechanism, a.timestamp);
    }
}
