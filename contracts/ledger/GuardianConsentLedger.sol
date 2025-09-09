// SPDX-License-Identifier: GuardianConsent-License
pragma solidity ^0.8.0;

contract GuardianConsentLedger {
    address public steward;

    struct ConsentPulse {
        string city;
        string zone;
        string guardianType;
        bool consentGranted;
        uint256 timestamp;
    }

    ConsentPulse[] public pulses;

    event ConsentPulseLogged(string city, string zone, string guardianType, bool consentGranted, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logConsent(string memory city, string memory zone, string memory guardianType, bool consentGranted) public {
        require(msg.sender == steward, "Only steward can log");
        pulses.push(ConsentPulse(city, zone, guardianType, consentGranted, block.timestamp));
        emit ConsentPulseLogged(city, zone, guardianType, consentGranted, block.timestamp);
    }

    function getConsent(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ConsentPulse memory p = pulses[index];
        return (p.city, p.zone, p.guardianType, p.consentGranted, p.timestamp);
    }
}
