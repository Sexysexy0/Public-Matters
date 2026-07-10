// SPDX-License-Identifier: MIT
// Contract Name: TechnicalTasteAccord
// Purpose: Encode cultivation of technical taste in coding
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TechnicalTasteAccord {
    address public chiefOperator;
    uint256 public accordCount;

    struct Accord {
        string principle;
        string tasteMechanism;
        uint256 timestamp;
    }

    Accord[] public accords;

    event AccordAdded(string principle, string tasteMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        accordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new technical taste clause
    function addAccord(string memory principle, string memory tasteMechanism) public onlyChief {
        accords.push(Accord(principle, tasteMechanism, block.timestamp));
        accordCount++;
        emit AccordAdded(principle, tasteMechanism, block.timestamp);
    }

    // View accord details
    function getAccord(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < accords.length, "Invalid accord index");
        Accord memory a = accords[index];
        return (a.principle, a.tasteMechanism, a.timestamp);
    }
}
