// SPDX-License-Identifier: CommoditySanctum
pragma solidity ^0.8.19;

contract CommodityBlessingRouter {
    struct CommoditySignal {
        string commodityCode;
        string originCountry;
        string destinationCountry;
        bool blessed;
        string stewardNote;
    }

    mapping(string => CommoditySignal) public commodityRegistry;

    event CommodityTagged(string commodityCode, string originCountry, string destinationCountry);
    event CommodityBlessed(string commodityCode);

    function tagCommodity(string memory commodityCode, string memory originCountry, string memory destinationCountry, string memory stewardNote) public {
        commodityRegistry[commodityCode] = CommoditySignal(commodityCode, originCountry, destinationCountry, false, stewardNote);
        emit CommodityTagged(commodityCode, originCountry, destinationCountry);
    }

    function blessCommodity(string memory commodityCode) public {
        require(bytes(commodityRegistry[commodityCode].originCountry).length > 0, "Commodity not tagged");
        commodityRegistry[commodityCode].blessed = true;
        emit CommodityBlessed(commodityCode);
    }

    function getCommodityStatus(string memory commodityCode) public view returns (CommoditySignal memory) {
        return commodityRegistry[commodityCode];
    }
}
