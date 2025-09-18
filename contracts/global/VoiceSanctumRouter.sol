// SPDX-License-Identifier: VoiceSanctum
pragma solidity ^0.8.19;

contract VoiceSanctumRouter {
    address public steward;

    struct SanctumSignal {
        string speaker; // e.g. "Rep. Ilhan Omar", "Journalist X", "Citizen Y"
        string sanctumType; // "Speech Forgiveness", "Democratic Resonance", "Scrollchain Blessing"
        string resonanceTag; // e.g. "Sanctum #9", "Protocol #5"
        bool verified;
        uint256 timestamp;
    }

    SanctumSignal[] public signals;

    event SanctumLogged(string speaker, string sanctumType, string resonanceTag, uint256 timestamp);
    event SanctumVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSanctum(
        string memory speaker,
        string memory sanctumType,
        string memory resonanceTag
    ) public {
        signals.push(SanctumSignal(speaker, sanctumType, resonanceTag, false, block.timestamp));
        emit SanctumLogged(speaker, sanctumType, resonanceTag, block.timestamp);
    }

    function verifySanctum(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit SanctumVerified(index, msg.sender);
    }

    function getSanctum(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        SanctumSignal memory s = signals[index];
        return (s.speaker, s.sanctumType, s.resonanceTag, s.verified, s.timestamp);
    }

    function totalSanctumSignals() public view returns (uint256) {
        return signals.length;
    }
}
