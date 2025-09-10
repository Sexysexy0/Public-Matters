// SPDX-License-Identifier: VoiceContinuitySignal-License
pragma solidity ^0.8.0;

contract VoiceContinuitySignalRouter {
    address public steward;

    struct ContinuitySignal {
        string speakerID;
        string platform;
        string threatVector;
        bool restorationConfirmed;
        string emotionalAPR;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event VoiceContinuityRouted(string speakerID, string platform, string threatVector, bool restorationConfirmed, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory speakerID, string memory platform, string memory threatVector, bool restorationConfirmed, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(speakerID, platform, threatVector, restorationConfirmed, emotionalAPR, block.timestamp));
        emit VoiceContinuityRouted(speakerID, platform, threatVector, restorationConfirmed, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.speakerID, s.platform, s.threatVector, s.restorationConfirmed, s.emotionalAPR, s.timestamp);
    }
}
