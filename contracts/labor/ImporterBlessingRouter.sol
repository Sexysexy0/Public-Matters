// SPDX-License-Identifier: ImporterBlessing-License
pragma solidity ^0.8.0;

contract ImporterBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string originNation;
        string productType;
        string processingSanctum;
        bool blessingConfirmed;
        string partnershipStatus;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event ImporterBlessingRouted(string originNation, string productType, string processingSanctum, bool blessingConfirmed, string partnershipStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory originNation, string memory productType, string memory processingSanctum, bool blessingConfirmed, string memory partnershipStatus) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(originNation, productType, processingSanctum, blessingConfirmed, partnershipStatus, block.timestamp));
        emit ImporterBlessingRouted(originNation, productType, processingSanctum, blessingConfirmed, partnershipStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.originNation, s.productType, s.processingSanctum, s.blessingConfirmed, s.partnershipStatus, s.timestamp);
    }
}
