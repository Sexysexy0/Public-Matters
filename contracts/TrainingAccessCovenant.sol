// SPDX-License-Identifier: MIT
// Contract Name: TrainingAccessCovenant
// Purpose: Guarantee equal access to training and skill development
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TrainingAccessCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Training {
        string program;         // e.g., Leadership, Technical, Community
        string accessRule;      // e.g., Equal slots, Rotation, Open enrollment
        string safeguard;       // e.g., Transparency log, Audit
        uint256 timestamp;
    }

    Training[] public trainings;

    event TrainingAdded(string program, string accessRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new training covenant
    function addTraining(string memory program, string memory accessRule, string memory safeguard) public onlyChief {
        trainings.push(Training(program, accessRule, safeguard, block.timestamp));
        covenantCount++;
        emit TrainingAdded(program, accessRule, safeguard, block.timestamp);
    }

    // View training details
    function getTraining(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < trainings.length, "Invalid training index");
        Training memory t = trainings[index];
        return (t.program, t.accessRule, t.safeguard, t.timestamp);
    }
}
