// SPDX-License-Identifier: VoiceSanctum
pragma solidity ^0.8.19;

contract VoiceSovereigntyRouter {
    address public steward;

    struct SpeechEvent {
        address speaker;
        string platform;
        string message;
        string threatType;
        bool silenced;
        uint256 timestamp;
        bool verified;
    }

    SpeechEvent[] public events;

    event SpeechLogged(address indexed speaker, string platform, string threatType, bool silenced, uint256 timestamp);
    event SpeechVerified(uint256 index, address verifier);
    event EmotionalAPRActivated(address indexed speaker, string ritual, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logSpeechEvent(
        address speaker,
        string memory platform,
        string memory message,
        string memory threatType,
        bool silenced
    ) public {
        events.push(SpeechEvent(speaker, platform, message, threatType, silenced, block.timestamp, false));
        emit SpeechLogged(speaker, platform, threatType, silenced, block.timestamp);
    }

    function verifySpeechEvent(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit SpeechVerified(index, msg.sender);
    }

    function activateEmotionalAPR(address speaker, string memory ritual) public {
        require(msg.sender == steward, "Only steward may activate APR");
        emit EmotionalAPRActivated(speaker, ritual, block.timestamp);
    }

    function getSpeechEvent(uint256 index) public view returns (
        address, string memory, string memory, string memory, bool, uint256, bool
    ) {
        SpeechEvent memory e = events[index];
        return (e.speaker, e.platform, e.message, e.threatType, e.silenced, e.timestamp, e.verified);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
