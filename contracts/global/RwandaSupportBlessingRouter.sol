// SPDX-License-Identifier: RwandaSanctum
pragma solidity ^0.8.19;

contract RwandaSupportBlessingRouter {
    struct BlessingSignal {
        string recipientZone;
        string aidType;
        uint256 amountUSD;
        bool blessed;
        string stewardNote;
    }

    mapping(string => BlessingSignal) public blessingRegistry;

    event ZoneTagged(string recipientZone, string aidType);
    event BlessingReleased(string recipientZone);

    function tagZone(string memory recipientZone, string memory aidType, uint256 amountUSD, string memory stewardNote) public {
        blessingRegistry[recipientZone] = BlessingSignal(recipientZone, aidType, amountUSD, false, stewardNote);
        emit ZoneTagged(recipientZone, aidType);
    }

    function releaseBlessing(string memory recipientZone) public {
        require(blessingRegistry[recipientZone].amountUSD > 0, "Zone not tagged");
        blessingRegistry[recipientZone].blessed = true;
        emit BlessingReleased(recipientZone);
    }

    function getBlessingStatus(string memory recipientZone) public view returns (BlessingSignal memory) {
        return blessingRegistry[recipientZone];
    }
}
