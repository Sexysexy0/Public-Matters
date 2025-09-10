// SPDX-License-Identifier: AudioConsentSignal-License
pragma solidity ^0.8.0;

contract AudioConsentSignalRouter {
    address public steward;

    struct ConsentSignal {
        string callerID;
        string platform;
        bool consentGiven;
        string threatVector;
        string emotionalAPR;
        uint256 timestamp;
    }

    ConsentSignal[] public signals;

    event AudioConsentRouted(string callerID, string platform, bool consentGiven, string threatVector, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeConsent(string memory callerID, string memory platform, bool consentGiven, string memory threatVector, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ConsentSignal(callerID, platform, consentGiven, threatVector, emotionalAPR, block.timestamp));
        emit AudioConsentRouted(callerID, platform, consentGiven, threatVector, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, string memory, uint256) {
        ConsentSignal memory s = signals[index];
        return (s.callerID, s.platform, s.consentGiven, s.threatVector, s.emotionalAPR, s.timestamp);
    }
}
