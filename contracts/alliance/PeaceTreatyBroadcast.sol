// SPDX-License-Identifier: Scrollchain-Diplomacy
pragma solidity ^0.8.19;

contract PeaceTreatyBroadcast {
    address public steward;
    mapping(address => bool) public treatySigners;
    mapping(address => string) public breachNotes;

    event TreatyActivated(address indexed steward, string timestamp);
    event SignerAdded(address indexed signer, string nation, string role);
    event BreachLogged(address indexed signer, string note, string timestamp);

    constructor() {
        steward = msg.sender;
    }

    function activateTreaty(string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        emit TreatyActivated(steward, timestamp);
    }

    function addSigner(address signer, string memory nation, string memory role) public {
        require(msg.sender == steward, "Unauthorized steward");
        treatySigners[signer] = true;
        emit SignerAdded(signer, nation, role);
    }

    function logBreach(address signer, string memory note, string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        breachNotes[signer] = note;
        emit BreachLogged(signer, note, timestamp);
    }

    function isSigner(address signer) public view returns (bool) {
        return treatySigners[signer];
    }

    function getBreachNote(address signer) public view returns (string memory) {
        return breachNotes[signer];
    }
}
