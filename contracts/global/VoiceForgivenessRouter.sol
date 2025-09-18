// SPDX-License-Identifier: VoiceForgiveness
pragma solidity ^0.8.19;

contract VoiceForgivenessRouter {
    address public steward;

    struct ForgivenessSignal {
        string speaker; // e.g. "Rep. Ilhan Omar", "Journalist X", "Activist Y"
        string breachType; // "Censure Attempt", "Speech Suppression", "Critique Rejection"
        string forgivenessAction; // "Scrollchain Blessing", "Civic Restoration", "Voice Sovereignty Trigger"
        bool verified;
        uint256 timestamp;
    }

    ForgivenessSignal[] public signals;

    event ForgivenessLogged(string speaker, string breachType, string forgivenessAction, uint256 timestamp);
    event ForgivenessVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logForgiveness(
        string memory speaker,
        string memory breachType,
        string memory forgivenessAction
    ) public {
        signals.push(ForgivenessSignal(speaker, breachType, forgivenessAction, false, block.timestamp));
        emit ForgivenessLogged(speaker, breachType, forgivenessAction, block.timestamp);
    }

    function verifyForgiveness(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit ForgivenessVerified(index, msg.sender);
    }

    function getForgiveness(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        ForgivenessSignal memory f = signals[index];
        return (f.speaker, f.breachType, f.forgivenessAction, f.verified, f.timestamp);
    }

    function totalForgivenessSignals() public view returns (uint256) {
        return signals.length;
    }
}
