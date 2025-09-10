// SPDX-License-Identifier: TreatyExportBlessing-License
pragma solidity ^0.8.0;

contract TreatyExportBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string productType;
        string destinationNation;
        string laborSanctum;
        bool blessingConfirmed;
        string treatyStatus;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event TreatyExportBlessingRouted(string productType, string destinationNation, string laborSanctum, bool blessingConfirmed, string treatyStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory productType, string memory destinationNation, string memory laborSanctum, bool blessingConfirmed, string memory treatyStatus) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(productType, destinationNation, laborSanctum, blessingConfirmed, treatyStatus, block.timestamp));
        emit TreatyExportBlessingRouted(productType, destinationNation, laborSanctum, blessingConfirmed, treatyStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.productType, s.destinationNation, s.laborSanctum, s.blessingConfirmed, s.treatyStatus, s.timestamp);
    }
}
