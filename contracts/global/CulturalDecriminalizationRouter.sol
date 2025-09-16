// SPDX-License-Identifier: DecriminalizationSanctum
pragma solidity ^0.8.19;

contract CulturalDecriminalizationRouter {
    struct DecriminalizationSignal {
        string region;
        string billID;
        string sponsor;
        bool isActive;
        string stewardNote;
    }

    mapping(string => DecriminalizationSignal) public signals;

    event BillTagged(string region, string billID);
    event DecriminalizationActivated(string region);

    function tagBill(string memory region, string memory billID, string memory sponsor, string memory stewardNote) public {
        signals[region] = DecriminalizationSignal(region, billID, sponsor, false, stewardNote);
        emit BillTagged(region, billID);
    }

    function activateDecriminalization(string memory region) public {
        require(bytes(signals[region].billID).length > 0, "Bill not tagged");
        signals[region].isActive = true;
        emit DecriminalizationActivated(region);
    }

    function getDecriminalizationStatus(string memory region) public view returns (DecriminalizationSignal memory) {
        return signals[region];
    }
}
