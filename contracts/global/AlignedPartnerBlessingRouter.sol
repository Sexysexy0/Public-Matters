// SPDX-License-Identifier: AlignedPartnerBlessing-License
pragma solidity ^0.8.0;

contract AlignedPartnerBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string partnerNation;
        string productType;
        string exportSanctum;
        bool blessingConfirmed;
        bool tariffExempt;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event AlignedPartnerBlessingRouted(string partnerNation, string productType, string exportSanctum, bool blessingConfirmed, bool tariffExempt, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory partnerNation, string memory productType, string memory exportSanctum, bool blessingConfirmed, bool tariffExempt) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(partnerNation, productType, exportSanctum, blessingConfirmed, tariffExempt, block.timestamp));
        emit AlignedPartnerBlessingRouted(partnerNation, productType, exportSanctum, blessingConfirmed, tariffExempt, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.partnerNation, s.productType, s.exportSanctum, s.blessingConfirmed, s.tariffExempt, s.timestamp);
    }
}
