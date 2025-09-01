// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffRestorationProtocol {
    struct Tariff {
        string country;
        string productCategory;
        uint256 rate; // in percentage
        bool defaultRestored;
    }

    mapping(string => Tariff[]) public tariffs;
    event TariffRestored(string country, string productCategory, uint256 rate);

    function restoreTariff(
        string memory _country,
        string memory _productCategory,
        uint256 _rate
    ) public {
        tariffs[_country].push(Tariff(_country, _productCategory, _rate, true));
        emit TariffRestored(_country, _productCategory, _rate);
    }

    function getTariffs(string memory _country) public view returns (Tariff[] memory) {
        return tariffs[_country];
    }
}
