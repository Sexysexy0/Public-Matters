// SPDX-License-Identifier: TariffSanctum
pragma solidity ^0.8.19;

contract TariffBlessingSanctifier {
    struct TariffSignal {
        string country;
        uint256 rate;
        string productCategory;
        bool harmonized;
        string stewardNote;
    }

    mapping(string => TariffSignal) public tariffRegistry;

    event TariffTagged(string country, string productCategory);
    event TariffHarmonized(string country);

    function tagTariff(string memory country, uint256 rate, string memory productCategory, string memory stewardNote) public {
        tariffRegistry[country] = TariffSignal(country, rate, productCategory, false, stewardNote);
        emit TariffTagged(country, productCategory);
    }

    function harmonizeTariff(string memory country) public {
        require(bytes(tariffRegistry[country].productCategory).length > 0, "Tariff not tagged");
        tariffRegistry[country].harmonized = true;
        emit TariffHarmonized(country);
    }

    function getTariffStatus(string memory country) public view returns (TariffSignal memory) {
        return tariffRegistry[country];
    }
}
