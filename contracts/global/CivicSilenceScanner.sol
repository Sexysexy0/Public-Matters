// SPDX-License-Identifier: BroadcastSanctum
pragma solidity ^0.8.19;

contract CivicSilenceScanner {
    address public steward;

    struct SilenceSignal {
        string anchorTag; // e.g. "Rachel Maddow", "Don Lemon"
        string networkTag; // e.g. "MSNBC", "CNN"
        string civicEvent; // e.g. "Assassination", "Election Interference"
        string silenceType; // e.g. "Muted Coverage", "No Mention", "Deflection"
        bool verified;
        uint256 timestamp;
    }

    SilenceSignal[] public signals;

    event SilenceLogged(string anchorTag, string networkTag, string civicEvent, string silenceType, uint256 timestamp);
    event SilenceVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSilence(
        string memory anchorTag,
        string memory networkTag,
        string memory civicEvent,
        string memory silenceType
    ) public {
        signals.push(SilenceSignal(anchorTag, networkTag, civicEvent, silenceType, false, block.timestamp));
        emit SilenceLogged(anchorTag, networkTag, civicEvent, silenceType, block.timestamp);
    }

    function verifySilence(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit SilenceVerified(index, msg.sender);
    }

    function getSilence(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        SilenceSignal memory s = signals[index];
        return (s.anchorTag, s.networkTag, s.civicEvent, s.silenceType, s.verified, s.timestamp);
    }

    function totalSilenceSignals() public view returns (uint256) {
        return signals.length;
    }
}
