// SPDX-License-Identifier: BlessingSanctum
pragma solidity ^0.8.19;

contract TradeBlessingRouter {
    struct BlessingSignal {
        address partnerID;
        string partnerName;
        string tradeCommodity;
        string blessingType; // e.g., "Tariff Forgiveness", "Export Revival", "Protocol Harmony"
        bool treatyAligned;
        string stewardNote;
    }

    mapping(address => BlessingSignal) public blessingRegistry;

    event BlessingTagged(address partnerID, string blessingType);
    event TreatyAligned(address partnerID);

    function tagBlessing(address partnerID, string memory partnerName, string memory tradeCommodity, string memory blessingType, bool treatyAligned, string memory stewardNote) public {
        blessingRegistry[partnerID] = BlessingSignal(partnerID, partnerName, tradeCommodity, blessingType, treatyAligned, stewardNote);
        emit BlessingTagged(partnerID, blessingType);
    }

    function alignTreaty(address partnerID) public {
        require(bytes(blessingRegistry[partnerID].partnerName).length > 0, "Partner not tagged");
        blessingRegistry[partnerID].treatyAligned = true;
        emit TreatyAligned(partnerID);
    }

    function getBlessingStatus(address partnerID) public view returns (BlessingSignal memory) {
        return blessingRegistry[partnerID];
    }
}
