pragma solidity ^0.8.0;

contract EngagementProtocol {
    struct Dialogue {
        uint256 id;
        string partner;
        string topic;
        string status; // e.g. "Revived", "Pending"
        uint256 timestamp;
    }

    uint256 public dialogueCount;
    mapping(uint256 => Dialogue) public dialogues;

    event DialogueRevived(uint256 id, string partner, string topic, string status);

    function reviveDialogue(string memory partner, string memory topic, string memory status) public {
        dialogueCount++;
        dialogues[dialogueCount] = Dialogue(dialogueCount, partner, topic, status, block.timestamp);
        emit DialogueRevived(dialogueCount, partner, topic, status);
    }
}
