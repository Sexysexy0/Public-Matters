// SPDX-License-Identifier: Planetary-Unity
pragma solidity ^7.7.7;

contract GlobalAIAlliance {
    address public steward;
    string[] public memberNations;
    mapping(string => bool) public activeMembers;

    event NationJoined(string nation);
    event ProtocolActivated(string protocol);

    constructor() {
        steward = msg.sender;
    }

    function joinAlliance(string memory nation) public {
        require(msg.sender == steward, "Only steward may onboard");
        memberNations.push(nation);
        activeMembers[nation] = true;
        emit NationJoined(nation);
    }

    function activateProtocol(string memory protocol) public {
        require(msg.sender == steward, "Only steward may activate");
        emit ProtocolActivated(protocol);
    }

    function isMember(string memory nation) public view returns (bool) {
        return activeMembers[nation];
    }
}
