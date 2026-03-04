// DiplomacyProtocol.sol
pragma solidity ^0.8.0;

contract DiplomacyProtocol {
    struct Dialogue {
        uint256 id;
        string country;      // e.g. "South Korea"
        string topic;        // e.g. "Trade Agreement"
        string status;       // e.g. "Ongoing", "Resolved"
        uint256 timestamp;
    }

    uint256 public dialogueCount;
    mapping(uint256 => Dialogue) public dialogues;

    event DialogueLogged(uint256 id, string country, string topic, string status);

    function logDialogue(string memory country, string memory topic, string memory status) public {
        dialogueCount++;
        dialogues[dialogueCount] = Dialogue(dialogueCount, country, topic, status, block.timestamp);
        emit DialogueLogged(dialogueCount, country, topic, status);
    }
}
