// SPDX-License-Identifier: MIT
// Contract Name: WorkerVoiceAccord
// Purpose: Guarantee worker voice rights and feedback channels
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract WorkerVoiceAccord {
    address public chiefOperator;
    uint256 public accordCount;

    struct Accord {
        string workerID;        // Worker identifier
        string feedbackType;    // e.g., Suggestion, Grievance, Innovation
        string message;         // Worker’s voice content
        string resolution;      // Management response or action
        uint256 timestamp;
    }

    Accord[] public accords;

    event AccordAdded(string workerID, string feedbackType, string message, string resolution, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        accordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new worker voice accord
    function addAccord(string memory workerID, string memory feedbackType, string memory message, string memory resolution) public onlyChief {
        accords.push(Accord(workerID, feedbackType, message, resolution, block.timestamp));
        accordCount++;
        emit AccordAdded(workerID, feedbackType, message, resolution, block.timestamp);
    }

    // View accord details
    function getAccord(uint256 index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        require(index < accords.length, "Invalid accord index");
        Accord memory a = accords[index];
        return (a.workerID, a.feedbackType, a.message, a.resolution, a.timestamp);
    }
}
