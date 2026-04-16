pragma solidity ^0.8.0;

contract OverloadingDialogueProtocol {
    event DialogueRequest(string group, string issue);

    function request(string memory group, string memory issue) public {
        emit DialogueRequest(group, issue);
    }
}
