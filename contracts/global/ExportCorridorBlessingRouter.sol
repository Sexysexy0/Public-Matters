// SPDX-License-Identifier: ExportCorridorBlessing-License
pragma solidity ^0.8.0;

contract ExportCorridorBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string productType;
        string destinationNation;
        string laborSanctum;
        bool blessingConfirmed;
        bool tariffExempt;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event ExportCorridorBlessingRouted(string productType, string destinationNation, string laborSanctum, bool blessingConfirmed, bool tariffExempt, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory productType, string memory destinationNation, string memory laborSanctum, bool blessingConfirmed, bool tariffExempt) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(productType, destinationNation, laborSanctum, blessingConfirmed, tariffExempt, block.timestamp));
        emit ExportCorridorBlessingRouted(productType, destinationNation, laborSanctum, blessingConfirmed, tariffExempt, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.productType, s.destinationNation, s.laborSanctum, s.blessingConfirmed, s.tariffExempt, s.timestamp);
    }
}
