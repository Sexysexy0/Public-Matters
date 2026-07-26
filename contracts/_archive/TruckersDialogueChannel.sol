pragma solidity ^0.8.0;

contract TruckersDialogueChannel {
    event DialogueInitiation(string group, string issue);

    function initiateDialogue(string memory group, string memory issue) public {
        emit DialogueInitiation(group, issue);
    }
}
