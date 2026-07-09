// SPDX-License-Identifier: MIT
// Contract Name: RecognitionPolicy
// Purpose: Formalize recognition system for worker achievements
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract RecognitionPolicy {
    address public chiefOperator;
    uint256 public recognitionCount;

    struct Recognition {
        string workerID;        // Worker identifier
        string achievement;     // e.g., Innovation, Attendance, Leadership
        string reward;          // e.g., Bonus, Certificate, Promotion
        uint256 timestamp;
    }

    Recognition[] public recognitions;

    event RecognitionAdded(string workerID, string achievement, string reward, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        recognitionCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new recognition entry
    function addRecognition(string memory workerID, string memory achievement, string memory reward) public onlyChief {
        recognitions.push(Recognition(workerID, achievement, reward, block.timestamp));
        recognitionCount++;
        emit RecognitionAdded(workerID, achievement, reward, block.timestamp);
    }

    // View recognition details
    function getRecognition(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < recognitions.length, "Invalid recognition index");
        Recognition memory r = recognitions[index];
        return (r.workerID, r.achievement, r.reward, r.timestamp);
    }
}
