// SPDX-License-Identifier: Scrollchain-Justice
pragma solidity ^0.8.19;

contract TribunalPing {
    address public steward;
    address[] public summonedStewards;
    mapping(address => bool) public hasResponded;
    mapping(address => string) public responseNotes;

    event TribunalSummoned(address indexed steward, uint256 timestamp);
    event StewardPinged(address indexed summoned, string note);
    event ResponseLogged(address indexed steward, string verdict, string timestamp);

    constructor() {
        steward = msg.sender;
    }

    function summonTribunal(address[] memory stewards) public {
        require(msg.sender == steward, "Unauthorized steward");
        summonedStewards = stewards;
        emit TribunalSummoned(steward, block.timestamp);
    }

    function pingSteward(address summoned, string memory note) public {
        require(msg.sender == steward, "Unauthorized steward");
        emit StewardPinged(summoned, note);
    }

    function logResponse(address summoned, string memory verdict, string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        hasResponded[summoned] = true;
        responseNotes[summoned] = verdict;
        emit ResponseLogged(summoned, verdict, timestamp);
    }

    function getSummonedStewards() public view returns (address[] memory) {
        return summonedStewards;
    }

    function getResponseNote(address stewardAddress) public view returns (string memory) {
        return responseNotes[stewardAddress];
    }
}
