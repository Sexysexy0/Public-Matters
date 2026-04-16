pragma solidity ^0.8.0;

contract TruckersGovDialogue {
    event DialogueSession(string group, string issue);

    function initiate(string memory group, string memory issue) public {
        emit DialogueSession(group, issue);
    }
}
