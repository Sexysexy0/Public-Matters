// SPDX-License-Identifier: MIT
// Contract Name: DialogueAccessTreaty
// Purpose: Establish open communication desk for worker voice and management feedback
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract DialogueAccessTreaty {
    address public chiefOperator;
    uint256 public dialogueCount;

    struct Dialogue {
        string participant;     // Worker or Management
        string message;         // Feedback, suggestion, or grievance
        string response;        // Management reply or resolution
        uint256 timestamp;
    }

    Dialogue[] public dialogues;

    event DialogueAdded(string participant, string message, string response, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        dialogueCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new dialogue entry
    function addDialogue(string memory participant, string memory message, string memory response) public onlyChief {
        dialogues.push(Dialogue(participant, message, response, block.timestamp));
        dialogueCount++;
        emit DialogueAdded(participant, message, response, block.timestamp);
    }

    // View dialogue details
    function getDialogue(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < dialogues.length, "Invalid dialogue index");
        Dialogue memory d = dialogues[index];
        return (d.participant, d.message, d.response, d.timestamp);
    }
}
