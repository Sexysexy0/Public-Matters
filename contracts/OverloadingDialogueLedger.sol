pragma solidity ^0.8.0;

contract OverloadingDialogueLedger {
    event DialogueRequest(string group, string issue);

    function requestDialogue(string memory group, string memory issue) public {
        emit DialogueRequest(group, issue);
    }
}
