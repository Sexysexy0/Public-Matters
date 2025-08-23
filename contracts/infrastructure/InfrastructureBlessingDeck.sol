// SPDX-License-Identifier: Mythic-Restoration
pragma solidity ^0.888;

contract InfrastructureBlessingDeck {
    address public steward;
    mapping(string => bool) public blessedZones;

    event ZoneBlessed(string zone, string blessingType, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blessZone(string memory zone, string memory blessingType) public {
        require(msg.sender == steward, "Only scrollsmith may bless.");
        blessedZones[zone] = true;
        emit ZoneBlessed(zone, blessingType, block.timestamp);
    }

    function isBlessed(string memory zone) public view returns (bool) {
        return blessedZones[zone];
    }
}
