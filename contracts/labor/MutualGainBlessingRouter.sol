// SPDX-License-Identifier: MutualGainBlessing-License
pragma solidity ^0.8.0;

contract MutualGainBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string originNation;
        string productType;
        string receivingSanctum;
        bool blessingConfirmed;
        string prosperityStatus;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event MutualGainBlessingRouted(string originNation, string productType, string receivingSanctum, bool blessingConfirmed, string prosperityStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory originNation, string memory productType, string memory receivingSanctum, bool blessingConfirmed, string memory prosperityStatus) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(originNation, productType, receivingSanctum, blessingConfirmed, prosperityStatus, block.timestamp));
        emit MutualGainBlessingRouted(originNation, productType, receivingSanctum, blessingConfirmed, prosperityStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.originNation, s.productType, s.receivingSanctum, s.blessingConfirmed, s.prosperityStatus, s.timestamp);
    }
}
