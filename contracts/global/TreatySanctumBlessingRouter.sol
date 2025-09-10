// SPDX-License-Identifier: TreatySanctumBlessing-License
pragma solidity ^0.8.0;

contract TreatySanctumBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string region;
        string vaccineType;
        bool treatyAligned;
        bool firewallCleared;
        bool blessingConfirmed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event TreatySanctumBlessingRouted(string region, string vaccineType, bool treatyAligned, bool firewallCleared, bool blessingConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory region, string memory vaccineType, bool treatyAligned, bool firewallCleared, bool blessingConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(region, vaccineType, treatyAligned, firewallCleared, blessingConfirmed, block.timestamp));
        emit TreatySanctumBlessingRouted(region, vaccineType, treatyAligned, firewallCleared, blessingConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.region, s.vaccineType, s.treatyAligned, s.firewallCleared, s.blessingConfirmed, s.timestamp);
    }
}
