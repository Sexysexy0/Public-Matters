// SPDX-License-Identifier: EmergencyKitBlessing-License
pragma solidity ^0.8.0;

contract EmergencyKitBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string sanctumID;
        string hostNation;
        string kitType;
        string disruptionLevel;
        bool blessingConfirmed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event EmergencyKitBlessed(string sanctumID, string hostNation, string kitType, string disruptionLevel, bool blessingConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blessKit(string memory sanctumID, string memory hostNation, string memory kitType, string memory disruptionLevel, bool blessingConfirmed) public {
        require(msg.sender == steward, "Only steward can bless");
        signals.push(BlessingSignal(sanctumID, hostNation, kitType, disruptionLevel, blessingConfirmed, block.timestamp));
        emit EmergencyKitBlessed(sanctumID, hostNation, kitType, disruptionLevel, blessingConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.sanctumID, s.hostNation, s.kitType, s.disruptionLevel, s.blessingConfirmed, s.timestamp);
    }
}
