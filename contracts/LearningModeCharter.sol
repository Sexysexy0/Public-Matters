// SPDX-License-Identifier: MIT
// Contract Name: LearningModeCharter
// Purpose: Safeguard intentional learning workflows with AI
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract LearningModeCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Charter {
        string principle;
        string learningMechanism;
        uint256 timestamp;
    }

    Charter[] public charters;

    event CharterAdded(string principle, string learningMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new learning mode clause
    function addCharter(string memory principle, string memory learningMechanism) public onlyChief {
        charters.push(Charter(principle, learningMechanism, block.timestamp));
        charterCount++;
        emit CharterAdded(principle, learningMechanism, block.timestamp);
    }

    // View charter details
    function getCharter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < charters.length, "Invalid charter index");
        Charter memory c = charters[index];
        return (c.principle, c.learningMechanism, c.timestamp);
    }
}
