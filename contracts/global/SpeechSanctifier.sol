// SPDX-License-Identifier: SpeechSanctum
pragma solidity ^0.8.19;

contract SpeechSanctifier {
    address public steward;

    struct SpeechSignal {
        string speaker; // e.g. "Rep. Ilhan Omar", "Journalist X", "Citizen Y"
        string sanctumType; // "Censure Override", "Critique Blessing", "Voice Sovereignty"
        string covenantTag; // e.g. "Sanctum #7", "Protocol #3"
        bool verified;
        uint256 timestamp;
    }

    SpeechSignal[] public signals;

    event SpeechLogged(string speaker, string sanctumType, string covenantTag, uint256 timestamp);
    event SpeechVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSpeech(
        string memory speaker,
        string memory sanctumType,
        string memory covenantTag
    ) public {
        signals.push(SpeechSignal(speaker, sanctumType, covenantTag, false, block.timestamp));
        emit SpeechLogged(speaker, sanctumType, covenantTag, block.timestamp);
    }

    function verifySpeech(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit SpeechVerified(index, msg.sender);
    }

    function getSpeech(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        SpeechSignal memory s = signals[index];
        return (s.speaker, s.sanctumType, s.covenantTag, s.verified, s.timestamp);
    }

    function totalSpeechSignals() public view returns (uint256) {
        return signals.length;
    }
}
