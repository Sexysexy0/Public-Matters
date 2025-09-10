// SPDX-License-Identifier: TreatyCorridorBlessing-License
pragma solidity ^0.8.0;

contract TreatyCorridorBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string corridorID;
        string energyType;
        bool firewallCleared;
        bool treatyAligned;
        bool blessingConfirmed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event CorridorBlessingRouted(string corridorID, string energyType, bool firewallCleared, bool treatyAligned, bool blessingConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory corridorID, string memory energyType, bool firewallCleared, bool treatyAligned, bool blessingConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(corridorID, energyType, firewallCleared, treatyAligned, blessingConfirmed, block.timestamp));
        emit CorridorBlessingRouted(corridorID, energyType, firewallCleared, treatyAligned, blessingConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.corridorID, s.energyType, s.firewallCleared, s.treatyAligned, s.blessingConfirmed, s.timestamp);
    }
}
