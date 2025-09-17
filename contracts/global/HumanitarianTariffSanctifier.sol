// SPDX-License-Identifier: HumanitarianSanctum
pragma solidity ^0.8.19;

contract HumanitarianTariffSanctifier {
    struct TariffBlessing {
        address countryID;
        string countryName;
        string commodityType; // e.g., "Food", "Medicine", "Agricultural Tools"
        bool tariffRemoved;
        string stewardNote;
    }

    mapping(address => TariffBlessing) public tariffRegistry;

    event TariffBlessed(address countryID, string commodityType);
    event TariffRemoved(address countryID);

    function blessTariff(
        address countryID,
        string memory countryName,
        string memory commodityType,
        bool tariffRemoved,
        string memory stewardNote
    ) public {
        tariffRegistry[countryID] = TariffBlessing(
            countryID,
            countryName,
            commodityType,
            tariffRemoved,
            stewardNote
        );
        emit TariffBlessed(countryID, commodityType);
    }

    function removeTariff(address countryID) public {
        require(bytes(tariffRegistry[countryID].countryName).length > 0, "Country not tagged");
        tariffRegistry[countryID].tariffRemoved = true;
        emit TariffRemoved(countryID);
    }

    function getTariffStatus(address countryID) public view returns (TariffBlessing memory) {
        return tariffRegistry[countryID];
    }
}
