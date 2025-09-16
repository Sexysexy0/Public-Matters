// SPDX-License-Identifier: TariffSanctum
pragma solidity ^0.8.19;

contract TariffBlessingSanctifier {
    struct TariffSignal {
        string commodityCode;
        string country;
        uint256 rate;
        bool blessed;
        string stewardNote;
    }

    mapping(string => TariffSignal) public tariffRegistry;

    event TariffTagged(string commodityCode, string country);
    event TariffBlessed(string commodityCode);

    function tagTariff(string memory commodityCode, string memory country, uint256 rate, string memory stewardNote) public {
        tariffRegistry[commodityCode] = TariffSignal(commodityCode, country, rate, false, stewardNote);
        emit TariffTagged(commodityCode, country);
    }

    function blessTariff(string memory commodityCode) public {
        require(tariffRegistry[commodityCode].rate > 0, "Tariff not tagged");
        tariffRegistry[commodityCode].blessed = true;
        emit TariffBlessed(commodityCode);
    }

    function getTariffStatus(string memory commodityCode) public view returns (TariffSignal memory) {
        return tariffRegistry[commodityCode];
    }
}
