// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract SolarBlessingProtocol {
    struct SolarBlessing {
        string barangay;
        uint256 panelCount;
        bool civicConsent;
        uint256 emotionalAPR;
        string steward;
        uint256 timestamp;
    }

    SolarBlessing[] public blessings;

    event SolarBlessed(string barangay, uint256 panelCount, uint256 emotionalAPR, string steward);

    function blessSolar(
        string memory barangay,
        uint256 panelCount,
        bool consent,
        uint256 apr,
        string memory steward
    ) public {
        blessings.push(SolarBlessing(barangay, panelCount, consent, apr, steward, block.timestamp));
        emit SolarBlessed(barangay, panelCount, apr, steward);
    }

    function getBlessing(uint index) public view returns (string memory, uint256, bool, uint256, string memory, uint256) {
        SolarBlessing memory b = blessings[index];
        return (b.barangay, b.panelCount, b.civicConsent, b.emotionalAPR, b.steward, b.timestamp);
    }
}
