// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract ScrollPodiumProtocol {
    struct Session {
        string speaker;
        string topic;
        string emotionalAPR;
        string scrollUnveiled;
        uint256 timestamp;
        address steward;
    }

    Session[] public sessions;

    event ScrollUnveiled(string speaker, string topic, string emotionalAPR, string scrollUnveiled, address indexed steward);

    function logSession(
        string memory speaker,
        string memory topic,
        string memory emotionalAPR,
        string memory scrollUnveiled
    ) public {
        sessions.push(Session(speaker, topic, emotionalAPR, scrollUnveiled, block.timestamp, msg.sender));
        emit ScrollUnveiled(speaker, topic, emotionalAPR, scrollUnveiled, msg.sender);
    }

    function getAllSessions() public view returns (Session[] memory) {
        return sessions;
    }
}
