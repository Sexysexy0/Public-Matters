// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract BlessingProtocol {
    address public steward;

    struct Blessing {
        string barangay;
        string stewardName;
        string ritualPhrase;
        uint256 timestamp;
        bool approved;
    }

    mapping(uint => Blessing) public blessings;
    uint public blessingCount;

    event BlessingGranted(string barangay, string stewardName, string ritualPhrase);
    event BlessingRevoked(string barangay);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function grantBlessing(string memory barangay, string memory stewardName, string memory ritualPhrase) public onlySteward {
        blessings[blessingCount++] = Blessing(barangay, stewardName, ritualPhrase, block.timestamp, true);
        emit BlessingGranted(barangay, stewardName, ritualPhrase);
    }

    function revokeBlessing(uint id) public onlySteward {
        blessings[id].approved = false;
        emit BlessingRevoked(blessings[id].barangay);
    }

    function isBlessed(uint id) public view returns (bool) {
        return blessings[id].approved;
    }

    function getBlessing(uint id) public view returns (Blessing memory) {
        return blessings[id];
    }
}
